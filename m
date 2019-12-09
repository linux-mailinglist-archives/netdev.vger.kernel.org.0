Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1721D1175C5
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfLIT1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:27:18 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:39839 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfLIT1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 14:27:16 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N3KgE-1he9Qm1eLq-010Mtl; Mon, 09 Dec 2019 20:27:14 +0100
Received: by mail-qt1-f181.google.com with SMTP id k11so281078qtm.3;
        Mon, 09 Dec 2019 11:27:14 -0800 (PST)
X-Gm-Message-State: APjAAAW6N3ovd1Gl9x31r4xo1fK3rBiK1mOsrdM4eze4YKLfeSJOUkNN
        vdirtl2LcElnD45sXuPmkW+Vtal+oOm02/RmOBw=
X-Google-Smtp-Source: APXvYqw8S7eatu+K64zQ4xgIER2Piv2OR5qIkc9fHY9hfY2/sTUPAuTv7mjAtXGPnDIgDvdsQGZVrBJHzRcDC9wlEio=
X-Received: by 2002:ac8:768d:: with SMTP id g13mr26650326qtr.7.1575919633087;
 Mon, 09 Dec 2019 11:27:13 -0800 (PST)
MIME-Version: 1.0
References: <20191209151256.2497534-1-arnd@arndb.de> <20191209151256.2497534-4-arnd@arndb.de>
 <20191209.102950.2248756181772063368.davem@davemloft.net>
In-Reply-To: <20191209.102950.2248756181772063368.davem@davemloft.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 9 Dec 2019 20:26:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a25UGV1KS1ufZsyQJk1+9Rp9is0x6eOU7pr5Xf6Z3N2gA@mail.gmail.com>
Message-ID: <CAK8P3a25UGV1KS1ufZsyQJk1+9Rp9is0x6eOU7pr5Xf6Z3N2gA@mail.gmail.com>
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
To:     David Miller <davem@davemloft.net>
Cc:     khc@pm.waw.pl, gregkh <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Qiang Zhao <qiang.zhao@nxp.com>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:7qnWVUiaxASlMAvTvom/HXL4dbDqoezMjO1lHSGf+4G5u8IuV2X
 pFkXOOQ/6ddk5gl1KfsyK1tj/zLQMt8ArSlH39A7HyP6wxDTF0cOhETKpiuQHJHB6A0f+lu
 jlyai+ijhU2h0kK20dKH1ldsTdDl553/s3lgGvcGb7MuJt1hR6VtrAfGGGDhKw0wB5ySh2D
 mU2pqXR+LbKHHtRE39Qzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8/+aPbNBCc8=:M7jNY8qixxukakRKEYGtPE
 mWWAZexkE7gKrw1xC0tEtvMj9sq0ybgDz/Bj2ZrxG9ehieGK97AA4czcQK7SCSlAXvUNrNCoS
 kFqWzMcpIfEO1IeuxunVDjvAZWi4gRAVhX2UjLxM/0XeulbWrB9RilRFfKzs3OMXwkDFI2nCN
 vRxHdHroITgI18PRjlNJTMXaS+fpmamcRrxuQ5yZ/ohJuaUrPaV3u5LM0rMqG0Dy2rgAGXVJt
 YQU8sMjCDoeLCNQzQxqQ+e6tXdERGJlknq0H6SkjDQntCyvutRu7DeKTINhYNAfWAhHqYFAsG
 h8BJAajR4cpJjA+/KO8KBD9IEuqRB8wRKZH3LHV+E2KkYrBiNCQ8Pt594FtEop834fSogodMm
 /RpxyEdrCyEMtcpv08lPG7Y7X9uZTmgSoSGFlmaOL421w4Wwi995w6/sqcIIrqL6Y8E6HSzbe
 6BKHG74vwEmgsfKkFlXtJO75KHWHz3qSDGuzlTNi9g58ZBVAzSQ8IJdF4FdW1NPZv0lr4ZaZr
 eH0kjvU71Cl+77MDwA04KGyJ3IseTKAf4GH5bR4jUZBj8maKuRhsn/kOn+YeIV8SF7sLjm2Pl
 w3GbioHLJSrPPncZt/ZzSXKr+9bty9aWX9ZuWcGMO4Wr+Xp5lNvd8FdFw7WRCZUW4Gd6jI5rW
 KycTTOpbbGv4gSPz/fcz41tmACZ1q0+Fqr/37ZMVA57jeAMqk/7MsV053FglBdSezaXhxP6OI
 RTA+7L1Ir5QNFoEayEQNUp9/hILIXmlWqvcaqKuHDgKWPMPhXe5V5xpCKuK06o7BJjXZlPCpA
 ZcbHu2KNWFmzBbu3nnhF7ED39pj07otjbXcg5I/xduZBCqocx9kJ+tcqahtE95aScInaOpRgp
 CR9UkKMcz95rvjy/FBPQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 7:29 PM David Miller <davem@davemloft.net> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Mon,  9 Dec 2019 16:12:56 +0100
>
> > syzbot keeps finding issues in the X.25 implementation that nobody is
> > interested in fixing.  Given that all the x25 patches of the past years
> > that are not global cleanups tend to fix user-triggered oopses, is it
> > time to just retire the subsystem?
>
> I have a bug fix that I'm currently applying to 'net' right now actually:
>
>         https://patchwork.ozlabs.org/patch/1205973/
>
> So your proposal might be a bit premature.

Ok, makes sense. Looking back in the history, I also see other bugfixes
from the same author.

Adding Martin Schiller to Cc: for a few questions:

- What hardware are you using for X.25?
- Would you be available to be listed in the MAINTAINERS file
  as a contact for net/x25?
- Does your bug fix address the latest issue found by syzbot[1],
  or do you have an idea to fix it if not?

        Arnd

[1] https://lore.kernel.org/netdev/CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com/
