/*
 * SPDX-FileCopyrightText: 2020-2021 Han Young <hanyoung@protonmail.com>
 * SPDX-FileCopyrightText: 2021-2022 Rohan Asokan <rohan.asokan@students.iiit.ac.in>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef MATHENGINE_H
#define MATHENGINE_H
#include "mathengine/driver.hh"
#include <QObject>
#include <QRegularExpression>
class MathEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(bool error READ error NOTIFY resultChanged)
public:
    static MathEngine *inst()
    {
        static MathEngine singleton;
        return &singleton;
    }
    Q_INVOKABLE void parse(QString expr);
    Q_INVOKABLE void parseBinaryExpression(QString expr);
    QString result()
    {
        return m_result;
    };
    bool error()
    {
        return m_driver.syntaxError;
    };
signals:
    void resultChanged();

private:
    MathEngine(){};
    driver m_driver;
    QString m_result;
    const QString bitRegex = QString("[01]+");
    const QString operatorRegex = QString("[\\+\\-\\*\\/&\\|~\\^]|<{2}|>{2}");
    QRegularExpression regexMatcher;
    QRegularExpressionMatch match;
};

#endif
