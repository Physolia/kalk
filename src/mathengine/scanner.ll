/*
 SPDX-FileCopyrightText: 2020 Han Young <hanyoung@protonmail.com>
 SPDX-License-Identifier: GPL-3.0-or-later
*/

%{ /* -*- C++ -*- */
# include <cerrno>
# include <climits>
# include <cstdlib>
# include <cstring> // strerror
# include <string>
# include <knumber.h>
# include <QString>
# include "driver.hh"
# include "parser.hh"
%}

%{
#if defined __clang__
# define CLANG_VERSION (__clang_major__ * 100 + __clang_minor__)
#endif

// Clang and ICC like to pretend they are GCC.
#if defined __GNUC__ && !defined __clang__ && !defined __ICC
# define GCC_VERSION (__GNUC__ * 100 + __GNUC_MINOR__)
#endif

// Pacify warnings in yy_init_buffer (observed with Flex 2.6.4)
// and GCC 6.4.0, 7.3.0 with -O3.
#if defined GCC_VERSION && 600 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wnull-dereference"
#endif

// This example uses Flex's C back end, yet compiles it as C++.
// So expect warnings about C style casts and NULL.
#if defined CLANG_VERSION && 500 <= CLANG_VERSION
# pragma clang diagnostic ignored "-Wold-style-cast"
# pragma clang diagnostic ignored "-Wzero-as-null-pointer-constant"
#elif defined GCC_VERSION && 407 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wold-style-cast"
# pragma GCC diagnostic ignored "-Wzero-as-null-pointer-constant"
#endif

#define FLEX_VERSION (YY_FLEX_MAJOR_VERSION * 100 + YY_FLEX_MINOR_VERSION)

// Old versions of Flex (2.5.35) generate an incomplete documentation comment.
//
//  In file included from src/scan-code-c.c:3:
//  src/scan-code.c:2198:21: error: empty paragraph passed to '@param' command
//        [-Werror,-Wdocumentation]
//   * @param line_number
//     ~~~~~~~~~~~~~~~~~^
//  1 error generated.
#if FLEX_VERSION < 206 && defined CLANG_VERSION
# pragma clang diagnostic ignored "-Wdocumentation"
#endif

// Old versions of Flex (2.5.35) use 'register'.  Warnings introduced in
// GCC 7 and Clang 6.
#if FLEX_VERSION < 206
# if defined CLANG_VERSION && 600 <= CLANG_VERSION
#  pragma clang diagnostic ignored "-Wdeprecated-register"
# elif defined GCC_VERSION && 700 <= GCC_VERSION
#  pragma GCC diagnostic ignored "-Wregister"
# endif
#endif

#if FLEX_VERSION < 206
# if defined CLANG_VERSION
#  pragma clang diagnostic ignored "-Wconversion"
#  pragma clang diagnostic ignored "-Wdocumentation"
#  pragma clang diagnostic ignored "-Wshorten-64-to-32"
#  pragma clang diagnostic ignored "-Wsign-conversion"
# elif defined GCC_VERSION
#  pragma GCC diagnostic ignored "-Wconversion"
#  pragma GCC diagnostic ignored "-Wsign-conversion"
# endif
#endif
%}

%option noyywrap nounput noinput batch

%{
  // A number symbol corresponding to the value in S.
  yy::parser::symbol_type
  make_NUMBER (const std::string &s, const yy::parser::location_type& loc);
%}

knumber   [0-9]+|([0-9]+)?("."|",")[0-9]+

%{
  // Code run each time a pattern is matched.
  # define YY_USER_ACTION  loc.columns (yyleng);
%}
%%
%{
  // A handy shortcut to the location held by the driver.
  yy::location& loc = drv.location;
  // Code run each time yylex is called.
  loc.step ();
%}

"-"        return yy::parser::make_MINUS  (loc);
"+"        return yy::parser::make_PLUS   (loc);
"×"        return yy::parser::make_STAR   (loc);
"÷"        return yy::parser::make_SLASH  (loc);
"("        return yy::parser::make_LPAREN (loc);
")"        return yy::parser::make_RPAREN (loc);
"^"        return yy::parser::make_POWER (loc);
"sin"      return yy::parser::make_SIN (loc);
"cos"      return yy::parser::make_COS (loc);
"tan"      return yy::parser::make_TAN (loc);
"log"      return yy::parser::make_LOG (loc);
"log10"      return yy::parser::make_LOG10 (loc);
"log2"      return yy::parser::make_LOG2 (loc);
"√"      return yy::parser::make_SQUAREROOT (loc);
"π"      return yy::parser::make_NUMBER (KNumber::Pi(), loc);
"e"      return yy::parser::make_NUMBER (KNumber::Euler(), loc);
"%"      return yy::parser::make_PERCENTAGE (loc);
"="       loc.step ();
"asin"     return yy::parser::make_ASIN (loc);
"acos"      return yy::parser::make_ACOS (loc);
"atan"      return yy::parser::make_ATAN (loc);
"abs"      return yy::parser::make_ABS (loc);

{knumber}      return make_NUMBER (yytext, loc);
<<EOF>>    return yy::parser::symbol_type (0, loc);
%%

yy::parser::symbol_type
make_NUMBER (const std::string &s, const yy::parser::location_type& loc)
{
  errno = 0;
  KNumber n = KNumber(QString::fromStdString(s));
  return yy::parser::make_NUMBER ((KNumber) n, loc);
}

void
driver::scan_begin (std::string s)
{
  yy_switch_to_buffer(yy_scan_string(s.c_str()));
}
