Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960A2463689
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbhK3OZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbhK3OZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:25:14 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC06C061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:21:55 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x6so87109287edr.5
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DGPn2igXjXNc8cgTPBuml5CwmFX/CD+2Keay7uyMRh0=;
        b=pMi/lgXophVm8I4rifCAQ4FjWVpr4WuiivIO27548curclquUOmDTx70WDlgsqjymb
         RN+CyupF8uTByPHmTIYxaRgjzD4/At01HayyDmp+cGag+Ec5bWD3zIyvFgXzkims9vyM
         durGmMmwTx+72mbunHJOf7Jx3oWiEqKa3vdt4frx6/eHLVyfnynl/XIABLlq1W71Rtke
         H/oQ0ZN+IE2QsCNxb1MeY+HOj9ovwQ9GkcaLGMi0KPMj6ei/mJBEzT23rqlHnpjFWdC5
         mbNqjwbtmFgRoXZ3xLdes4F3exHS3fw3kxuviQ+n9oznv7nre0VxeCV9K81VyRhA9MQA
         vZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DGPn2igXjXNc8cgTPBuml5CwmFX/CD+2Keay7uyMRh0=;
        b=tIm2UzLl4Px1hMzyZoC7/on7nW4VqIffhqfJ3ozbv7a0iuGH5BFT9zCLfJsY72G/Td
         CYGurUDd81Qdg9umc5k6dRNDr7f4kLq9wnA9lbCmFehtS6f3DAen7+OkhdmnxeiogG+7
         SN5hDstDEEzp0SXKArL8YPIE/e0kSg4ae/16fkCa9wvP9IqE4FjdPLoyxMtPTIRYKI/Q
         9n7EKd/XDz2apA/ibPKvb0GRx/vodlGpHlarIPCtJPkkC8IBoql7htnG4VLTfOkWMEBS
         Q0F0eIIx17x2tgg2B/NQsUlDg/OX6X6f0riHh/RFjncpVnMuclEqBEQ5MSAaxx8AuecJ
         Qi8Q==
X-Gm-Message-State: AOAM531WCLd+k9WwJWunxCM8W0aLrfJ32Pr8s8RYrFpsCkEhiSN3xbJa
        ZKn5NDia5QfsDzhpZhGuyDOkSdmI1CwOguOyUVQ=
X-Google-Smtp-Source: ABdhPJy08y9US9PvDTQKzgL1kwGY+PN7sObUf9L0BDKGmQW+Vmk0oNos6HUV7ktnVzJyiQq8Zy1CKn21Ajrnvcuc3WI=
X-Received: by 2002:a17:907:1b0d:: with SMTP id mp13mr31150269ejc.29.1638282112054;
 Tue, 30 Nov 2021 06:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20211130063947.7529-1-rdunlap@infradead.org>
In-Reply-To: <20211130063947.7529-1-rdunlap@infradead.org>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Tue, 30 Nov 2021 06:21:40 -0800
Message-ID: <CAMo8Bf+0SUnc6FqSziykcr6GEhHp6-xtgk+_TKukhn+gTc6CEg@mail.gmail.com>
Subject: Re: [PATCH 2/2 -net] natsemi: xtensa: fix section mismatch warnings
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev <netdev@vger.kernel.org>, kernel test robot <lkp@intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Finn Thain <fthain@telegraphics.com.au>,
        Chris Zankel <chris@zankel.net>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 10:39 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Fix section mismatch warnings in xtsonic. The first one appears to be
> bogus and after fixing the second one, the first one is gone.
>
> WARNING: modpost: vmlinux.o(.text+0x529adc): Section mismatch in reference from the function sonic_get_stats() to the function .init.text:set_reset_devices()
> The function sonic_get_stats() references
> the function __init set_reset_devices().
> This is often because sonic_get_stats lacks a __init
> annotation or the annotation of set_reset_devices is wrong.
>
> WARNING: modpost: vmlinux.o(.text+0x529b3b): Section mismatch in reference from the function xtsonic_probe() to the function .init.text:sonic_probe1()
> The function xtsonic_probe() references
> the function __init sonic_probe1().
> This is often because xtsonic_probe lacks a __init
> annotation or the annotation of sonic_probe1 is wrong.
>
> Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")

The original code had the __devinit attribute
for the function xtsonic_probe, it then was dropped in change
6980cbe4a6db ("natsemi: remove __dev* attributes").
I'd say that this is the change that this patch fixes.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/net/ethernet/natsemi/xtsonic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
