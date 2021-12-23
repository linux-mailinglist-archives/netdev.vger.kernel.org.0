Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4847E265
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347977AbhLWLie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:38:34 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:45773 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLWLid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:38:33 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Ml76o-1mbDkB0f8O-00lZ2e; Thu, 23 Dec 2021 12:38:31 +0100
Received: by mail-wr1-f45.google.com with SMTP id w20so1895158wra.9;
        Thu, 23 Dec 2021 03:38:31 -0800 (PST)
X-Gm-Message-State: AOAM532esWn8ZqK4uy31FNZlbcp9EOZt/jC8SoAta9i9+/qVKjHxttVk
        uJM8uGXY8cX6fip2lb0pJ1mIO1xbmUHulslO/rU=
X-Google-Smtp-Source: ABdhPJz/EpzdpL4OwAijGaY2yhvM6m2rm6Cp3Bwh8cBWlM6S2bv5UYWdoP+HEsItUHqn5+Rq8IYuUkQcTmRnzbUfFRc=
X-Received: by 2002:a5d:6d0e:: with SMTP id e14mr1562661wrq.407.1640259510755;
 Thu, 23 Dec 2021 03:38:30 -0800 (PST)
MIME-Version: 1.0
References: <20211222191320.17662-1-repk@triplefau.lt> <CAK8P3a18b63GoPKiTey8KpEusyffbN97gxP+NM3fyZnOYXv5zg@mail.gmail.com>
 <YcRW1ckSr3ZSCDf9@pilgrim>
In-Reply-To: <YcRW1ckSr3ZSCDf9@pilgrim>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 23 Dec 2021 12:38:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0PTu2qCHGr63TBMgnjL9fQwn4=7CrURKMHQufffwOg9Q@mail.gmail.com>
Message-ID: <CAK8P3a0PTu2qCHGr63TBMgnjL9fQwn4=7CrURKMHQufffwOg9Q@mail.gmail.com>
Subject: Re: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     Arnd Bergmann <arnd@arndb.de>, Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:6A6+zaf30WfjsMtAJoKOaI0nWHT1CA17sPnmZOyqZbNYpbsz3hz
 ndngHEQ4qQVB3yrrYG/T/5xnMxpF2cRdyD7WjyUcx/IUEIvAT8ZfUPYqlvbEACbug+VM4ou
 dTaySYo9jkZsZY4vnUM9FFB4VTFO972lB2zXfcq3a5SGdzHsX9soGCG6xOUFSYUToX61m/x
 Xvh2KATDkoAGXncF+lWQQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QaRWr89eAaQ=:fZkbNBMF0uhZLIqlqHnuXd
 qMgYomNpNApc1m0Hhls2/AVhhL88UhNJ/ge7ykqcJ2nJUMrZtVnsBVW8vqxbq2LGeC9WEWF9n
 7C8BJIK608Gt2sBe8gnldVlWp/ivUughtXs6jADAiukBp7XcynhCfefKjsXEWunXAo3QftXqi
 WdaKT68VG3wwn//9l+E3lpfK6atvAltuPYsuJJiJ5P5mhYkrBVmY9vvfY7oLQ2VJC64SG4dx5
 QoKkpysBJs0+uGX8XhqO+7uyD89kWsVlQgjXexBNfuC198k7juu00rOVc92HA3IfZ9MyS1iA2
 uFsD8kstS7qZFt+VSg7BY1Jo98UwLoVn32B2js3x5f8/RSuY+MEYFAp0tGR+rXsa9x74vblEj
 1tzw1BJu6cWziH09jbabqH1pLWIYdR3Ikm6fOaGpysJDCZ52Z0cBtRs1sCSzXC+rcLrwmVs/R
 bmzTgGN0bmzqmmItkgkklUJaPUBnd/WZSG+Gai3ZRu97t+aU9q0qdU3pF9JHakfFXmDy43MB6
 neTuyg/tSMjs0b0FbQDVOhGdTHsluUA4jkk6eqtmghTjBDwQCHe8O54Bcc3n1dgtEoPAtjv8d
 K7iSc1jmjYLZCJkyIWrqQ6WehYjg6pnOfe0sZhgPK4ras5yVKfGgxpZsDCyCANpEbXj8x2lnC
 ZMC4TZ3ckJoa97Mo00C6qfje2Ebiw2/TxSF8kGg5nLWWnVbC58s/42W9vk8LPPEdCzWE=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 12:00 PM Remi Pommarel <repk@triplefau.lt> wrote:
>
> On Wed, Dec 22, 2021 at 10:52:20PM +0100, Arnd Bergmann wrote:
> > On Wed, Dec 22, 2021 at 8:13 PM Remi Pommarel <repk@triplefau.lt> wrote:
> [...]
> >
> > The intention of my broken patch was to make it work for compat mode as I did
> > in br_dev_siocdevprivate(), as this is now the only bit that remains broken.
> >
> > This could be done along the lines of the patch below, if you see any value in
> > it. (not tested, probably not quite right).
>
> Oh ok, because SIOC{S,G}IFBR compat ioctl was painfully done with
> old_bridge_ioctl() I didn't think those needed compat. So I adapted and
> fixed your patch to get that working.

Ok, thanks!

> Here is my test results.
>
> With my initial patch only :
>   - 64bit busybox's brctl (working)
>     # brctl show
>     bridge name     bridge id               STP enabled     interfaces
>     br0             8000.000000000000       n
>
>   - CONFIG_COMPAT=y + 32bit busybox's brctl (not working)
>     # brctl show
>     brctl: SIOCGIFBR: Invalid argument
>
> With both my intial patch and the one below :
>   - 64bit busybox's brctl (working)
>     # brctl show
>     bridge name     bridge id               STP enabled     interfaces
>     br0             8000.000000000000       n
>
>   - CONFIG_COMPAT=y + 32bit busybox's brctl (working)
>     # brctl show
>     bridge name     bridge id               STP enabled     interfaces
>     br0             8000.000000000000       n
>
> If you think this has enough value to fix those compatility issues I can
> either send the below patch as a V2 replacing my initial one for net
> or sending it as a separate patch for net-next. What would you rather
> like ?

If 32-bit busybox still uses those ioctls in moderately recent
versions, then it's probably worth doing this, but that would
be up to the bridge maintainers.

Your patch looks good to me, I see you caught a few mistakes
in my prototype. I would however suggest basing it on top of
your original fix, so that can be applied first and backported
to stable kernels, while the new patch would go on top and
not get backported.

If that works with everyone, please submit those two, and add
these tags to the second patch:

Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
