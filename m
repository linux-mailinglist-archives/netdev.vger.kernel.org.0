Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3657B136D48
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgAJMqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:46:00 -0500
Received: from mout.gmx.net ([212.227.15.19]:43811 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbgAJMqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 07:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578660357;
        bh=ZjTHqr+Gx8Fm1rg7PzcVcD00KyqnugejAbDTtj+r6nw=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=iAkU8DiZfWAsHkIhUqJf14Hr5xhasm03blOUSpLVuonooK4S20e3KHHVNLimu4yRP
         JxYKnW7dkWgrR3SVeJ603Z7tkk5LIFqllQGS0zgC1gf2WfBQR1mz8Y6ix5+/hH7l9J
         N3edsrpJuSEL+bqQATGg1AVpfdRaIaNK6IGbBC4I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([149.224.164.215]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N9dwd-1jmUYD2ZlN-015e09; Fri, 10
 Jan 2020 13:45:57 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
Date:   Fri, 10 Jan 2020 12:45:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110114433.GZ25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:I7pauYy8j7DIqlC4ZJg13OLuZukebROLKzgFpELKviOT06lxaJD
 qDRKkNihC1dEhZFQl7pOjtK/09sXvL3cDMobECAwdrYm1lM8cJ832VSeKo2i/IOrxknCw6o
 DlMwZ0qFHVfAupBXafZ5YSQJcRO7aMDrdYELlfZWdeQp2ytSsfT4yalxMr5M7XYPF5cuKqg
 Ki3oalK1w1FmUhEMFJIxw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:K6U2hPDxrZM=:daN/yDfBo6mJCuPvE69TAa
 BJZaxYt/u+mobg+XSIfKC9lqkpFWiAlBhB4KikFqp4fOFoEFecnwX/5WQ7B+7N0nJK/Y6IDDs
 zaK6E64fd6caDfmYS7jugCuKG5oib/6jBXcztsSVBcGfO+zeG3iKszildUR6WqXGD904KiNjL
 ZnKg9NFxtHa6/5/FP45j7aV0uXZ83nRoe/vrsS79q1v948I84y+JddpN95Z48zLj63n+DLULC
 wKRWHRUykAsOgyG7u+QHwiG+G5LG+TxKA/YZFvnp3ie4c3zOz+xSmkRJSY9fatuHBTXOmPVGb
 PAMIB0uVxxT9qeSsIoXPUTkG1hOa7OteSrDEvhpcaiiX6pHmRWnjfUZ9nxzuhQqO319lVoDzN
 buy6GIIdlvLZa1UUd4KjxsGU5zhgiCwE/dG9skdrZX/Kh0s2zfxOag9TM6YQeWfTtTAQgTGKA
 ACt6CmNcI1ztrGLJu8TCi5HZ9OJvZoa8FT56Mcap5DnKHfZuceDdHXNKXAoMUDvF6hPLdXR02
 yaacvlcResoPm7fYbjMH7elPL845V5BjI+JfmC2gq9XIMO2SxHfHpu3Movs8IIDlRUayxzywJ
 xiVA+WS8iYhyUVtbITvwGm9/jHbl9s1NG7Q9lCJMUbeGxDJShLrO63jyd2mT4QERKBYuHdeCo
 qwqFmiAoz4o9uSKNO/BWmCFklLN6/ABdtwX8TFcKkDjPNJZ9Cw6wigFlbn8O2at8H8Zjx++8I
 kisVY67SHEI5hea/XzRYTIaoixN6ZazD4XstJ2Ff9XhTg4XylL94CpDRw+VOaamnKGlc/p5BK
 oDA7NP5P5KBjXSmdtnXcBuvJEswZNF2iEoRyI7a5MVYKNqsNlZ3z4D6KlgtDHiJzyie5mGmsX
 2EqQCqstphrdVaHQAFDfvCweSPLchJW4ma4NDv4BMV+w1rTGxos3bazMXG/H+Y9mtQK6S776+
 zCf7rNfKb6Q72MVFmIJLa++awOsV9Z/SRy9sObnlqKIio+yWsjmGzRxZJ0QplQWB03Su94eDD
 J2kwBm2TT0CeS/oPyLC1G2wsdpvtCtxRVLUg04Q9kkuE+OdOzjoQ2hM7/NrsEAS42vXxlAOr1
 M7z2hYwc8OSsDzffxhjBAdtC4HWpG+i54EEQ4Zq8oW7KWVkBOi/XLvb2ema7fjevt40atS65b
 ml7b1OAtGR1H8Cyomdr1vXWTdBbrAScNWXatqyWqKbkOK+c0ZsX9QugHmxhSEw7o6qfzT9lN1
 9IR9ZNvbhEFyWLhK2K1GgqNJYFoSAeCKc0YoK7A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 11:44, Russell King - ARM Linux admin wrote:
>
> Which is also indicating everything is correct.  When the problem
> occurs, check the state of the signals again as close as possible
> to the event - it depends how long the transceiver keeps it
> asserted.  You will probably find tx-fault is indicating
> "in  hi IRQ".
just discovered userland - gpioinfo pca9538 - which seems more verbose

gpiochip2 - 8 lines:
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 0:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0 "tx-fault"=C2=A0=C2=A0 input=C2=A0=
 active-high [used]
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 1:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed "tx-disable"=C2=A0 output=C2=A0 active-high [u=
sed]
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 2:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed "rate-select0" input active-high [used]
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 3:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "los=
"=C2=A0=C2=A0 input=C2=A0 active-high [used]
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 4:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0 "mod-def0"=C2=A0=C2=A0 input=C2=A0=
=C2=A0 active-low [used]
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 5:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unused=C2=A0=
=C2=A0 input=C2=A0 active-high
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 6:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unused=C2=A0=
=C2=A0 input=C2=A0 active-high
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line=C2=A0=C2=A0 7:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unnamed=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unused=C2=A0=
=C2=A0 input=C2=A0 active-high

The above is depicting the current state with the module working, i.e.=20
being online. Will do some testing and report back, not sure yet how to=20
keep a close watch relating to the failure events.

>> - it would appear that SFP.C is trying to communicate with Fiber-GBIC =
and
>> fails since the signal reports may not be 100% compatible
> That's a fun claim, but note carefully the wording "may" which implies
> some uncertainty in the statement.

It was a verbatim translation but yes, even in the initial language=20
correspondence such uncertainty is implied indeed.

>
> Let's look at the wording of the GBIC (SFF-8053) and SFP (INF-8074 -
> SFP MSA) documents.  The wording for the "fault recovery" is identical
> between the two, which concerns what happens when TX_FAULT is asserted
> and how to recover from that.
>
> Concerning the implementation of TX_FAULT, SFF-8053 states:
>
>    If no transmitter safety circuitry is implemented, the TX_FAULT sign=
al
>    may be tied to its negated state.
>
> but then says later in the document:
>
>    If TX_FAULT is not implemented, the signal shall be held to the low
>    state by the GBIC.
>
> Meanwhile, INF-8074 similarly states:
>
>    If no transmitter safety circuitry is implemented, the TX_FAULT sign=
al
>    may be tied to its negated state.
>
> but later on has a similar statement:
>
>    TX_FAULT shall be implemented by those module definitions of SFP
>    transceiver supporting safety circuitry. If TX_FAULT is not
>    implemented, the signal shall be held to the low state by the SFP
>    transceiver.
>
> "shall" in both cases is stronger than "may".  So, there seems to be
> little difference between the GBIC and SFP usage of this signal.
>
> Their claim is that sfp.c implements the older GBIC style of signal
> reports.  My counter-claim is that (a) sfp.c is written to the SFP MSA
> and not the GBIC standard, and (b) there is no difference as far as the=

> TX_FAULT signal is concerned between the GBIC standard and the SFP MSA.=

>
> But... it doesn't matter that much, there's a module out there (and it
> isn't the only one) which does "funny stuff" with its TX_FAULT signal.
> Either we decide we want to support it and implement a quirk, or we
> decide we don't want to support it.
>
> There is an option bit in the EEPROM that is supposed to indicate
> whether the module supports TX_FAULT, but, as you can guess, there are
> problems with using that, as:
>
> 1) there are a lot of modules, particularly optical modules, that
>     implement TX_FAULT correctly but don't set the option bit to say
>     that they support the signal.
>
> 2) the other module I'm aware of that does "funny stuff" with its
>     TX_FAULT signal does have the TX_FAULT option bit set.
>
> So, the option bit is completely untrustworthy and, therefore, is
> meaningless (which is why we don't use it.)
>

Even with "shall" carrying a potentially higher weight than "may" it=20
still does not imply something obligatory (set in stone) and leaves=20
potential wiggle room.

