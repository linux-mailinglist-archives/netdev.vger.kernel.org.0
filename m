Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB0349D61
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfFRJdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:33:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39545 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbfFRJc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:32:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so13147212wrt.6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 02:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6krmeNN+08w4aZmGNN3h+dlYsILeKrK5WU7Jp0wdoWs=;
        b=NdnjhosXFrDiWKVkMzKrfuNnC4Dzu8CXW0FOJhJgeETdUkVYW1kmRX9Y2dF0JenWQo
         jXIjUlYZgbzF8baHW5adsWSgLUVfRGFI26MuHrwvDUsVgjh8Bn9D4vD7SozM9cWf7Yiz
         3P4oG3EoIiDEJ9k+bI6a6BkrbvV17DLryVwE/Oug5eOUnm2aM583waVttWPa8TjvrtKq
         y+1RovbIJ8UE55anfWKi0ffEjhAsMvYbmPXiedZ9ogzxQSX9ChNvHXBQMoPD7P+rEVFq
         wNQQpMKkIsMoSt6aSRQ1LwSEidwNtCwvdMA5jnNc9IeiwzqKcm/hPLypyIfVRHnjErGh
         jNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6krmeNN+08w4aZmGNN3h+dlYsILeKrK5WU7Jp0wdoWs=;
        b=RIf4nfFbdsKdtZGrpvOBx0lqQGn6CbjaepYChmnhXKTZ96FQC4CqNaSwQIOScU8wnN
         c/rl+Y1ZQ26BfyVMUMpOUaRJf9ITBmdYZ5zxd06ev41PiZj4hVO93FD89OnsNuVNrbNr
         /+YDBGnV1oHYfGPr+8kK7Ws14ciK4V0z1T27sVkftT67V/S6M8zFtig8TBmLOWhDkOtC
         IDjx96Wi9kps3ciYX3KpXB+p48fDR+oQWgLmEVxRb1b9nQCgnxXpyjuxDt0OnhamR2Hi
         i4dhkTkWQ89VIrcwh1IXvcOM28wXj0vSayTi9wa7n6h0y7zi/SLIPIWvfopeEZXYckbT
         nfsA==
X-Gm-Message-State: APjAAAV3bCRr9Ob+uOWpYchXZHp2i2g57lgGYiLKElFz9O8I5FV1RoT5
        05S5dmtGliYqDUWJEIoKQVjJHhgAizqOxloTtmIGnrJjL/g=
X-Google-Smtp-Source: APXvYqxfA11Cj/P5t6E/BwCz45TMQgwxpNrmhfXt/Bmj7bhfEVrZJwXNGi1EQ8ZdkuGkvuFyNbjpm0TLE/b5BEGT9mU=
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr29230086wrt.227.1560850376836;
 Tue, 18 Jun 2019 02:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
 <mvmtvco62k9.fsf@suse.de> <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
 <mvmpnnc5y49.fsf@suse.de> <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
 <mvmh88o5xi5.fsf@suse.de> <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>
 <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com> <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
 <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 18 Jun 2019 15:02:45 +0530
Message-ID: <CAAhSdy3zODw=JFaN=2F4K5-umihJDivLO8J8LBdkFkuZgzu41Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        "palmer@sifive.com" <palmer@sifive.com>
Cc:     Alistair Francis <Alistair.Francis@wdc.com>,
        "troy.benjegerdes@sifive.com" <troy.benjegerdes@sifive.com>,
        "jamez@wit.com" <jamez@wit.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "schwab@suse.de" <schwab@suse.de>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Lukas Auer <lukas.auer@aisec.fraunhofer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 8:56 AM Paul Walmsley <paul.walmsley@sifive.com> wr=
ote:
>
> On Mon, 17 Jun 2019, Alistair Francis wrote:
>
> > > The legacy M-mode U-boot handles the phy reset already, and I=E2=80=
=99ve been
> > > able to load upstream S-mode uboot as a payload via TFTP, and then
> > > load and boot a 4.19 kernel.
> > >
> > > It would be nice to get this all working with 5.x, however there are
> > > still
> > > several missing pieces to really have it work well.
> >
> > Let me know what is still missing/doesn't work and I can add it. At the
> > moment the only known issue I know of is a missing SD card driver in U-
> > Boot.
>
> The DT data has changed between the non-upstream data that people
> developed against previously, vs. the DT data that just went upstream
> here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D72296bde4f4207566872ee355950a59cbc29f852
>
> and
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Dc35f1b87fc595807ff15d2834d241f9771497205
>
> So Upstream U-Boot is going to need several patches to get things working
> again.  Clock identifiers and Ethernet are two known areas.

Done.

I just send-out few patches to fix U-Boot SiFive Clock driver.

The U-Boot SiFive Clock driver fix series can be found in
riscv_unleashed_clk_sync_v1 branch of:
https://github.com/avpatel/u-boot.git

Users will also require OpenSBI DTB fix which can be found
in sifive_unleashed_dtb_fix_v1 branch of:
https://github.com/avpatel/opensbi.git

With above fixes, we can now use same DTB for both U-Boot
and Linux kernel (5.2-rc1). Although, users are free to pass a
different DTB to Linux kernel via TFTP.

I have tested SiFive serial and Cadance MACB ethernet on
both U-Boot and Linux (5.2-rc1)

Regards,
Anup
