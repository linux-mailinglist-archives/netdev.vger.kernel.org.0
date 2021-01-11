Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2EF2F10DB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbhAKLMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbhAKLMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:12:34 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592C1C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 03:11:54 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id v5so10915623qtv.7
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 03:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eO8TrWdvw4R4xWpTIDUEJA/5vB5dkqjiiFS6laGpRo4=;
        b=zdNV9cyPJhbXvAYit+eFFL2qw89Zc3csdcN2l3OruzXH7TCr9dA/ZePlv4iJzqdASu
         v6p6soyOkxGFHJtUu0q+vXuoa+7Q3EyF2BNNJU6ZOr/Y5aKyuyTZBdHmNBYFQiS9QvZP
         mhJDJ1N/qUqyU5elveqZFzrtdmCZ6PAXiRY6PXq7iZ3B7ZqMWcLlgCjoHLuY1G0CHbvr
         8Tjh7tuw48LchinkPiLfogSZfOrxpMe9WbigvCnP7AqX/Tm9gSK6LAYfWz10MgZFD6ws
         8mOAcEXaZDu2KGsYqXMcONYKVoxhyRL1WD7l15r664G8Ngsj4iEOE15s/9XnIEx/Q6U7
         LyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eO8TrWdvw4R4xWpTIDUEJA/5vB5dkqjiiFS6laGpRo4=;
        b=YfNtyEDhH5w7gOVMIPCg2sG1p7r91nLSqK/7CO458C+fEP2q4NOaLHWWCn2Z197OgJ
         nMpOGjJ9k+1Qu8oafd3+B1rmM5w3daPSM+/jaR7LvKf+c3fFaLPLvwfi4HnTsi50TSMt
         y7nL1x0IBD+LdA9XX17TSl6rPU1gSqXOs6tFYd+XJ3MtOsengjJ9fdyDITz5OJLmZVEz
         CYKahIXqeXpHmzEjjaBCNu8XnKM//xZurJ/WfDAl7qfFdBl2MMrKHaWpM0NITp/TNIrz
         KT/BOU5vo8iF95/3IzvPuuDDhG+XFCXwbWQX7cT6ZIY4PNnWw6EzTnMa7/AOILJYaKKv
         kjgg==
X-Gm-Message-State: AOAM532O+dHrB9vtS0VZgxUANKkf49y3e95v8Xt7+UxtH6Nj+2IRX24u
        e+oymspPp8UgwkHKbtC5FWmYrfUaqkvJXTihKEpJMw==
X-Google-Smtp-Source: ABdhPJxpC28EzCkh1w3QBeeBUERjVmd/FUg4zbMTTJGhKGeBof8NghzI/sBFo9v/BO8nPBRmFbWdqg1fWc8ZzgpcFtE=
X-Received: by 2002:ac8:5296:: with SMTP id s22mr14533706qtn.343.1610363513505;
 Mon, 11 Jan 2021 03:11:53 -0800 (PST)
MIME-Version: 1.0
References: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 11 Jan 2021 12:11:42 +0100
Message-ID: <CAPv3WKcCJkQxsg3dywy2ZW+e7eyy8ZzofHsTc1WO+e9wXP78Yw@mail.gmail.com>
Subject: Re: [PATCH net ] net: mvpp2: Remove Pause and Asym_Pause support
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

niedz., 10 sty 2021 o 20:25 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Packet Processor hardware not connected to MAC flow control unit and
> cannot support TX flow control.
> This patch disable flow control support.
>
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 net=
work unit")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 82c6bef..d04171d 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5861,8 +5861,6 @@ static void mvpp2_phylink_validate(struct phylink_c=
onfig *config,
>
>         phylink_set(mask, Autoneg);
>         phylink_set_port_modes(mask);
> -       phylink_set(mask, Pause);
> -       phylink_set(mask, Asym_Pause);
>
>         switch (state->interface) {
>         case PHY_INTERFACE_MODE_10GBASER:
> --
> 1.9.1
>

Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks!
