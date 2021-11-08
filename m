Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF536447E5D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbhKHLB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:01:26 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:42559 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbhKHLB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:01:26 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M3UEW-1mkaKA1RyM-000bK8 for <netdev@vger.kernel.org>; Mon, 08 Nov 2021
 11:58:40 +0100
Received: by mail-wm1-f53.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so11301089wmz.2
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 02:58:40 -0800 (PST)
X-Gm-Message-State: AOAM531O0WdIsMlHC84esLZHLPMO/PgsD3cDsYnW0O+hLHzM/HvqtOnz
        03wvNZ29OfU7IV+TZ5H7AI5N9kdMSL5ufXN2Ugo=
X-Google-Smtp-Source: ABdhPJzF+4ZpZ8HnsXPorKYH6s1DedCbmyZOg3rsq/bVdYVKB8F8nEq2suGjgI59001AquTSDV9PLyPWKTZIiaPM3ts=
X-Received: by 2002:a05:600c:6d2:: with SMTP id b18mr53792833wmn.98.1636369119953;
 Mon, 08 Nov 2021 02:58:39 -0800 (PST)
MIME-Version: 1.0
References: <20190426195849.4111040-1-arnd@arndb.de> <20190426195849.4111040-6-arnd@arndb.de>
 <20211108094845.cytlyen5nptv4elu@intra2net.com>
In-Reply-To: <20211108094845.cytlyen5nptv4elu@intra2net.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 8 Nov 2021 11:58:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0=+w-CR_3uUr3Vi8E7v1z1O40K81pZU6y67u5ns8tCHA@mail.gmail.com>
Message-ID: <CAK8P3a0=+w-CR_3uUr3Vi8E7v1z1O40K81pZU6y67u5ns8tCHA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] isdn: move capi drivers to staging
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Networking <netdev@vger.kernel.org>,
        Tilman Schmidt <tilman@imap.cc>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net,
        Marcel Holtmann <marcel@holtmann.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        isdn4linux@listserv.isdn4linux.de,
        Al Viro <viro@zeniv.linux.org.uk>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Harald Welte <laforge@gnumonks.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:/8RoNsTW+BbNZB0tGip4aPA4S3QupvXSXNkp/OS2uAUd6r5cY9f
 m+otLounnYGu1Mx30N6ug7zw3uHIG16J1XruPHSPGiIaTreEYaj7wtcljLoLohudasa70Nm
 9ETBD0zwGqYWarADaGujrC0QVwNFXrYZcZDNGHCw4+D29mfLZJb0kwoXt2huE+B74zE2FaU
 COaYKH9hRbQwDjwFbGDCg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ger+K8BN02U=:VmHIWLi7vCLf+RFR6s68Mi
 RD680mmliV1fKuyOJuixygyMHZ3tiZwNN88fh8Eu156ulMXwDfBP/vuzyCVJMDoFIMU1fMYk5
 aKOvRPEM2JEVsu0KeiNzCkpaeggCBG7z++HmrRBD+bxpDj/buVjXwX6X4cM3/TmGHNAfIThR/
 x7qoPSZ8nZJgRPfMSi7A6Q1jVR00XHYnO7AptdfYuVMjtCCw1VnlsT3oTXwc70OtToR/d439F
 KxtuadU/xB5e+80SJ4unURBDruFMOGS3EFK77UDeNyUgFxdEPd596Z99Uu/KVYEnzscINu9lE
 i5lsAs4tjVQNXPNmgO5Ozvid1TH10a+WnGfGAwxvHFTemnFb9uUOixpJMt7SGcye08WzX2LwC
 FvTyQYXsCAP3qofIaYJSBY1KtOxXYKXCdwrkGXGXQbE+e3bsSbSvMQtNqA1l5k9pfBkV+tsW0
 /w5imUmC6M/QzqF4pelbGOnF55EqVYOVZtxiomW2SUI8Yc+s4W4iY3knZf9grL20LFexRPiB4
 8qx08EhQKX9TnPynRLRlFqEcEFiXbmQB/aEEKDFv66HHPXLGwHI0SdQSBS4J/rl+zT5K2zZzm
 94DAYho2IeQql3EYrIcIoWkDgg/SQghVF2uUywxbdetrf/mPawri1zmWJxZyVPsqRCUFkx+U6
 tWyc7hdfzjy/wZh2IywWPlCa3ueybfBkwqpovRZrxMDATiFzesnpv1Sthc6cixdiIpzg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 10:48 AM Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:
> You wrote on Fri, Apr 26, 2019 at 09:58:49PM +0200:
> > I tried to find any indication of whether the capi drivers are still in
> > use, and have not found anything from a long time ago.
> >
> > With public ISDN networks almost completely shut down over the past 12
> > months, there is very little you can actually do with this hardware. The
> > main remaining use case would be to connect ISDN voice phones to an
> > in-house installation with Asterisk or LCR, but anyone trying this in
> > turn seems to be using either the mISDN driver stack, or out-of-tree
> > drivers from the hardware vendors.
> >
> > I may of course have missed something, so I would suggest moving these
> > three drivers (avm, hysdn, gigaset) into drivers/staging/ just in case
> > someone still uses them.
> >
> > If nobody complains, we can remove them entirely in six months, or
> > otherwise move the core code and any drivers that are still needed back
> > into drivers/isdn.
>
> just a quick follow up on this one: Intra2net is officially
> removing ISDN fax support from our distribution on 2022-06-30.
>
> Since we are still running on kernel 4.19 and plan on upgrading to 5.10 some day
> soonish, there's one less ISDN user to care about in future kernel maintenance.
>
> This makes me even wonder how many linux ISDN users are left these days.

isdn4linux was already removed from the kernel as planned above.

I'm fairly sure the bluetooth capi/cmtp support can just be removed, it
seems to only cause security holes as recently discussed, and is otherwise
fairly useless, but Marcel still wanted to keep it as part of the bluetooth
stack. If this is still the case, we could consider merging all of
drivers/isdn/capi/ into net/bluetooth/cmtp/.

When removal of mISDN came up last, Harald Welte mentioned that some
of the code is still used by Osmocom/OpenBSC[1] to drive the E1 line cards.
I'm not sure if this is still the case, of if they have since migrated
to another
driver.

I see that Karsten's external mISDN modules were last updated for
v5.4 and don't build with newer kernels because of trivial interface changes.

      Arnd

[1] https://osmocom.org/projects/openbsc/wiki/MISDN
[2] https://github.com/ISDN4Linux/mISDN
