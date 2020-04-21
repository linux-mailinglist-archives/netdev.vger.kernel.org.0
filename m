Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C556B1B2218
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgDUIzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:55:13 -0400
Received: from mout.gmx.net ([212.227.15.15]:35087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUIzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1587459310;
        bh=J2Z74hgcwHHGGdPBH0C5iJA/8hhsUGYOmZw/I4UMpV8=;
        h=X-UI-Sender-Class:From:Subject:Reply-To:To:Date;
        b=gYP7yHQuSNW+mb8UHQtytO9W8RH0uiX4rd9m0w8cA0FjzpnDd2BJMt7vy2+bBqFSa
         9LkmpDiVcqFLnhsFpF4lU7tgA0P6tL6650djQYXxNMc4We+vdiJhuFzA4dlEAJ8MRP
         0Dqzrt+bzIC5KJ9KEexXN0Wwvp01uunkJ9h6Iiqs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([95.81.9.244]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MybKp-1j1iBk3VhF-00yuW3 for
 <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:55:10 +0200
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Subject: [switchdev] bridge fdb vs. switch's ATU - connection timeout when
 roaming from LAN port to WLan port
Reply-To: vtol@gmx.net
To:     netdev@vger.kernel.org
Message-ID: <9a060c11-1f41-f3a4-3135-1045524bb9b5@gmx.net>
Date:   Tue, 21 Apr 2020 08:55:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:BGP7jM6d4n8Xt6lejuAP10DEJTUJh+ppZKVUGCjdaAzemdP89B4
 tV36u0ngPI2MJ2nNd+KlNbGHiKb/ZyEObU6aVWborPYngIy7UoSgW6Oh2JC9YHvVgHc9BxD
 mZFOIO6xdHB+df9cGl2dT3txRZ8CgxnDVUO1wWfO+iCUiwq4lRuQdxSQLVmF0r/rDS6aKdt
 WLY+vx3WJBnq5XlF/bN0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mjrrjtWY8bQ=:zD7aubO3wtZGuvhViBq0My
 3XyvqNxXGrkv/E3o/jvB+M/U25TanT6iun2u4KGz2z6apLqln/0+fwyFnLr7n3izU3Ek1dUVB
 4jl3eZ6JYiYgU1hWjbA8rs96nx/ZoykXZzthvZcyp+SsspE1xSRCIiisYFVrTK6GGdZ9S0b3Y
 r1JAdcRr2BqdOUOYx0i8pvOzmZILtASWFn+KWgi+8yfRS0GSTpZwfZiYup6uRMfLweGqBi75P
 P38mSK2WLwefxETHtyVNQAFPeV6hflOEwiKHgSgZMXb2jsHzlqy9UlT5CTaEXBfWmCJl5LMRt
 C7OuItCiqtfcezD+HuuXd9Npq3gsZVHZSkGh1yXAlp/xq/x1WAY0uZTIeFSFAUcCK7AdwzzeH
 irQ8UtCMVjG5UyDOhzP8GhMK2SLlzsXEt+M35AE7mx7Ia85ZadIh9a1QXfWgiCELAk1HJKUaw
 EZET2LP1mnrPAfdnQVnPdvYeFgYBPvFk5NwdtSnGDbyqKbM7pKjTj0ptoqlbw3kJC1jfGwOn+
 WIy1Z9Ry242Q12GRmiSXZ+A2+4D0uphm00q9ONfGUagbhp3IrUDnCJe+5mZHaciDEW6o5qqz5
 LB4ydUmqBHZ9B757LwAcAcWvT3hRTq69KCYxrrydT5ZKH4S62FjujR9+rbkUa932egH1ngUJW
 uW8M5sMpa/Q73ICtt8+dXuo1l4P69pK4DSyS3qa82PfWDVU1qfJzFcP8jkErbXN6Y0Y2Y8zlF
 o1HsEeDyWa7tGWmUs9528cWavM+99KsI+7Cfp14p/7cy1DjwOI48sUxmjPSKcRDm9ZRMPW96t
 YzeKyDgV2xHgS1ypFNCaxCw/J+HQRxZOk8DAgpfBRCy8A7tJW4ilrsTorifrGkLYhbX+fnPlr
 f/fuJuO6w3MhV/KS9Z8rnowJfjVKSPrWCZlFT4n0xbyu7wbJ32DkpICIyNM5Saj3XYv03JUEs
 jFlaKlGnbnBjKBq5/v+E0PLUmidlY0fQNtCH/ojh9ngeSQ+VaYPtJmp7XUo/UkeoskooC3M09
 W906+x9z0FYKOiVyP7XZ+qWirNYgDJdtc/aXpd0nJLZEv5OqxKYHEM22pigZs5l+S2jmLYH/o
 jFSOJy90xiiK3w50WA3+ja4oQMUm5EEJefCSMd2UTSu+xT7Q+zQo1aK7dw3KqwJx9U6/XyvU3
 9vtB/8PoEtlaq0+wKJAxy3Tb1wBcyFEnKW3Ex+UB1IVyr88VzFYOus5f1EvmJfRUzYvVdav4D
 PTTow9JJRcXQ/l8o2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HOST config
* kernel 4.19.93
* SoC Cortex-A9 (armv7l)
* switch Marvell 88E6176 via PHY lane (mdio-mii) to SoC
* switch's downstream port driven by DSA
* switch's ATU=E2=80=99s /AgeTime/ control register default value =3D 0x13=
 (19 x
16 =3D 304 seconds)
* WLan card via mPCIe to SoC
________

Moving a client node from a (HOST) switch's downstream port (either
directly wired or indirectly via wireless AP that is wired into a switch
downstream port) to the HOST provided AP results in the client node not
being able to reach any other client node connected to a (HOST) switch's
downstream port.
Only after the switch's ATU=E2=80=99s /AgeTime/ has expired (and the MAC a=
ddress
of the roaming client node been cleared in the ATU) the client node
(that been moved/roamed) is able to establish connectivity with any
other client node connected to a (HOST) switch's downstream port.

Whilst bridge fdb is learning on the switch's downstream ports and the
WLan ports the switch's ATU is learning only on its downstream ports.
That sort of constitutes a communication gap and leading to the
aforementioned connectivity issue in the described roaming scenario.

Should switchdev be expected to communicate (align) changes from the
bridge fdb to the switch's ATU and thus prevent the aforementioned
connectivity issue? Or else, how to remedy?




