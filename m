Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216BD4636FB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242312AbhK3Ore (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhK3Ord (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:47:33 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17440C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:44:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so87275426eds.10
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDEDWNzDGOOvqfj1Z/NnYbI6iPu0zAjWn6iQvmfxq4A=;
        b=GAvX7ZsnTPyIio0prs35hvy4SM0A9CmLNFh5fBcJmXHWXV5MJMhgILrHmDgBNOGTpA
         Ga5RGILKPwDIEdUAKPwate7uS6XVyPqn5El/41dg5JUvOywa4HPH+KFo08rgocq+RQ3t
         JWHj4J49GPiauKKgbHtLi3bDYh6WAcibcdF+tW4mCa1CZESMSUwgeNJcMLrPKMVzrR0Z
         yFDVVLeLgtlqpp4oMA7s3qOokwehhKeWEkpi3jx+PwsrHNMUqqg2ufq38GPZTkNLkmGL
         mBL4Nk7ogb5vrh4OdQHlt9oE0QsFh23U5z4HHH0eeTr6ubsWklQinxfAoBVbR46fE/T2
         c5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDEDWNzDGOOvqfj1Z/NnYbI6iPu0zAjWn6iQvmfxq4A=;
        b=HVnxcKyRQ9n4KnNT8rKhlvpepQA8en8sOi1KiLlgW4G0wXPwg13eK0b0zUgdMWnhrB
         p0RYgEEnpO6kyb7VdPDUENSVpP43BQlCp3bQlQb86iBOp2j1CysVsTrsaY0NKxpYPvc5
         3+AgQAeyugBsxY4yfx8qlNS82Iqq/nCg2UcWoK4pfCX30dRnr8c9AbZtkyh8cV9nyLng
         XW5LFi9lIFzpzTLOvH1xsbqhJHzR1Jtb0+cC2ejh+L5PkeZWkx8laFW5L1RIplT6e/tX
         25068mNus2nhUutynjNBdsCTwdsoON7f95hzfdTHKuhNbJ03Cp9UUU7fSOTYGYMuRYt4
         qVJw==
X-Gm-Message-State: AOAM530Demwhn6GxC/3mFEnbbHSESngQ4nUZJKrASLNvCxUNh5gLESBV
        9RorureYMPTi/fPGuEFTMI+BDIqzft/IfLAEQTs=
X-Google-Smtp-Source: ABdhPJzlFLfumuxUk5j98s2NjXxGfGarkBF+pUiSdjIMQ7JD6JKkL+k2dz2xMhICkIbFNAQ5mHF9hAafIJb/cGULT1I=
X-Received: by 2002:a17:906:dc94:: with SMTP id cs20mr65214444ejc.117.1638283451797;
 Tue, 30 Nov 2021 06:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20211130063939.6929-1-rdunlap@infradead.org>
In-Reply-To: <20211130063939.6929-1-rdunlap@infradead.org>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Tue, 30 Nov 2021 06:44:00 -0800
Message-ID: <CAMo8BfLwhVPgWYf4SOFkqRJC7tLHNnoT15W5nvE3gLM6iEDkqw@mail.gmail.com>
Subject: Re: [PATCH 1/2 -net] natsemi: xtensa: allow writing to const dev_addr array
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On Mon, Nov 29, 2021 at 10:39 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Let the compiler know that it's ok to write to this const field.
>
> Fixes these build errors:
>
> ../drivers/net/ethernet/natsemi/xtsonic.c: In function 'sonic_probe1':
> ../drivers/net/ethernet/natsemi/xtsonic.c:166:36: error: assignment of read-only location '*(dev->dev_addr + (sizetype)(i * 2))'
>   166 |                 dev->dev_addr[i*2] = val;
> ../drivers/net/ethernet/natsemi/xtsonic.c:167:38: error: assignment of read-only location '*(dev->dev_addr + ((sizetype)(i * 2) + 1))'
>   167 |                 dev->dev_addr[i*2+1] = val >> 8;
>
> Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")

I don't think the original code was broken. But the change
adeef3e32146 ("net: constify netdev->dev_addr")
stated that all users of net_device::dev_addr were converted
to use helpers which is not correct.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/natsemi/xtsonic.c |    7 ++++---

There's also jazzsonic.c in this directory with the same pattern
in it. I've posted another patch that fixes them both using helper
function, as I guess was originally intended, here:
https://lore.kernel.org/lkml/20211130143600.31970-1-jcmvbkbc@gmail.com/

-- 
Thanks.
-- Max
