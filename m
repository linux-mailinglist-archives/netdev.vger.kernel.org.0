Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8703A1B1537
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDTS5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:57:25 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:51657 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgDTS5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:57:25 -0400
Received: from mail-qv1-f43.google.com ([209.85.219.43]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MzQbw-1j4Nox0nfU-00vR4u; Mon, 20 Apr 2020 20:57:23 +0200
Received: by mail-qv1-f43.google.com with SMTP id w18so4843855qvs.3;
        Mon, 20 Apr 2020 11:57:22 -0700 (PDT)
X-Gm-Message-State: AGi0PuYW2X+cHPalxq1d41B6dYJZAKtbCTatppUv+gPqFh7DTBEUH+/G
        7+cNvSWIBSlpfO2Tfy1F3dnFRyD3YHj2hBfIbjM=
X-Google-Smtp-Source: APiQypL3soWm0qcnc1Pl8apCyIqmvfNZS5Xqm9pLkv5lVITTxZWJ439g6o4H9UTag8MoqrM3DsBlN1fhI2bW7XmLhng=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr16425332qvp.197.1587409041974;
 Mon, 20 Apr 2020 11:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200416085627.1882-1-clay@daemons.net> <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx> <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost>
In-Reply-To: <20200420170051.GB11862@localhost>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Apr 2020 20:57:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
Message-ID: <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:JGonziQQvMq8xpUFCtBPF/y6J2ULzhxm98+04fJ2KuKB2TQFiLT
 YDkjFDtXw3c7JOpp0GOYdM6j/bxcmrjbJNygrwsiN/JmSc3IPA42YXbjEZHzIFPJOf5Jot/
 ZsmIok7fhgjHyvd7w1D95/ByPqY/JMl9EYr1S+JWVLs31Dpb5CTkMGuzCrPz4XgojEhv9Ly
 Fj8rmXa1iruTFNewihb0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RURF41x0JKM=:K19zyKboovO+UcjkGYpToE
 z8eDA1KVpcb2aNQKnM1Sfu4+MLBtnmE5FCkav5G2TpMhyxiTePRBv0Kx0EHgsXl8KEkgm8uv/
 wrvZ7O3QmE5ScVclwMiF/meXCmPv5ZJuEjUeJiQNa/GnKgsUhLDlMLEg8hp99/HYe1imlI6Si
 tT0PFltkD2qR6O+riolUQ5Y8hiVupnd83/cwOPfYoTbZQ/MOlHT9+exHG134vcWL4qcQTjP0k
 T0aTKVX0WAcwD9AFriEYSmYaSj6NJZHUY7edN5h4uPMP4VhzlHaCE6CVdxiTkR020J/uX0WVK
 FCNXQ3Bbbrx2RCWeSowKBqYyR1Zn0J6pvAEvvoe6gEv61uD/o1HOzRE1tTjI5PYURX/4oz0GV
 4SBxWh4I8beADRLzGh0pU7QoYrbd+v6GG2ccT+u+5doiBm25LwVCA4fzsrnRS8CWpA5d/tQfb
 4jFGsBbG/z1lob7vRhZXFvXPd0fNKq+5e2emVhD7xHMS6LtzjYBuvR4UVwTt5/DFQlZjVwdSA
 qZGTPYNPyNJixj1NMo2HXDcCdB3R3/jO7TszxbdgvfP7DqBSSh81n3mrUNUVKTITYyjpzyybL
 h6Kim54FbuUVRMbVYxehe8V08e0WXR+zb1+RedEPGslieHAdLQrlii7m1YBPA69TB7q8wGdgn
 +gOE+87UNvI5WJHxO+708t3AUj62SixtKFsxyQ4qjx9LPy/eDXQkD+HGtsO0Df5/tCwVSglFa
 rWerbCiY5hQeSGtHScWr44beGj6yaEg1YejAnVHoNiBG2hdg+3kJssXJh3P2WXM6tj0UL22Sn
 C3r9fCfYA0UjFMv6efCDUsEgNSEmqS4R2rx1TDV/1vbG9whMf8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 7:00 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 04:38:32PM +0200, Arnd Bergmann wrote:
> >
> > I suspect we should move all of them back. This was an early user
> > of 'imply', but the meaning of that keyword has now changed
> > in the latest Kconfig.
>
> Can you please explain the justification for changing the meaning?
>
> It was a big PITA for me to support this in the first place, and now
> we are back to square one?

I don't understand it either. Apparently it didn't always do what users
expected, though the new definition seems less useful to me, as it
only changes the default.

> > Something else is wrong if you need IS_ERR_OR_NULL(). Any
> > kernel interface should either return an negative error code when
> > something goes wrong, or should return NULL for all errors, but
> > not mix the two.
>
> On the contrary, this is exactly what the whole "imply" thing
> demanded.
>
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 172) #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 173)
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 174) /**
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 175)  * ptp_clock_register() - register a PTP hardware clock driver
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 176)  *
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 177)  * @info:   Structure describing the new clock.
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 178)  * @parent: Pointer to the parent device of the new clock.
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 179)  *
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 180)  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 181)  * support is missing at the configuration level, this function
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 182)  * returns NULL, and drivers are expected to gracefully handle that
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 183)  * case separately.
> d1cbfd771ce82 (Nicolas Pitre       2016-11-11 184)  */

The key here is "gracefully". The second patch from Clay just turns NULL into
 -EOPNOTSUPP and treats the compile-time condition into a runtime error.
I don't see a point in allowing the driver to compile if it just always returns
an error. The two callers then go on to print a message for any error
and just keep going.

      Arnd
