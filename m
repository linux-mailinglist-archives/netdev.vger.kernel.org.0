Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1332632CEB4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhCDIpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:45:18 -0500
Received: from mail-vk1-f170.google.com ([209.85.221.170]:45597 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhCDIo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:44:59 -0500
Received: by mail-vk1-f170.google.com with SMTP id i4so5048334vkc.12;
        Thu, 04 Mar 2021 00:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjTjCbmpaRqWMFA5UJHtIDu4DTO8Uevja8yqVq+vdQ8=;
        b=JRKxGtLQjOZ5zd9VRbSdmA2sbZ9PdhTNsOZL8Yo4/SJqKJYptOoUkvi/o1D/gJvxT2
         c7Dzn7sWP/qhdCANmMCHjxPnW/gGqbNYWM29pPwdHb2ZV8hvOadWBU/JD/Rg/rXBfSdV
         Hg15/USEU2yhNLqMi68XqzA92OcGTSliCuB09eE8iNSBpmd0u1790mUzndqJTgfsTY/P
         yhEiaHoClJIbr6rDt/y2BbqLb7KJ5c4EFRbtOYMxPMmqobkynPFEOcIK4PrbA/d0ldug
         GGoac2FyTgzU0bXaiX4XJzTB8tu2W1tF6qWJ7UGxSEhpQf/pJSzVrDWw8jSMaL7dEdou
         C35w==
X-Gm-Message-State: AOAM5330TBttHIb7F1AZ+mQy6e8CjwwrQKr3DR+qY5BpPyVRcD/1hv3s
        TOF9WE2E97cM1707xPuXs8IbIDnWvyDrPHwOYCKglC6l
X-Google-Smtp-Source: ABdhPJxdXH9McnYH/NH2/JCgbklPU0YJByirHpKQh1bqj2kvd6WsJGq7NfasTlmLb5foaAjC/Odi8+FlNvr7opPwwRM=
X-Received: by 2002:a1f:fe89:: with SMTP id l131mr1901735vki.1.1614847459094;
 Thu, 04 Mar 2021 00:44:19 -0800 (PST)
MIME-Version: 1.0
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru> <8e901c23-65ad-d76d-5a05-11d9aa7c4fc3@omprussia.ru>
In-Reply-To: <8e901c23-65ad-d76d-5a05-11d9aa7c4fc3@omprussia.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Mar 2021 09:44:07 +0100
Message-ID: <CAMuHMdWt3vsMPya5eq-QYrZEguXWqXWeXkWk6yPnJztmaEpQtg@mail.gmail.com>
Subject: Re: [PATCH net 2/3] sh_eth: fix TRSCER mask for R7S72100
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 9:54 PM Sergey Shtylyov <s.shtylyov@omprussia.ru> wrote:
> According  to  the RZ/A1H Group, RZ/A1M Group User's Manual: Hardware,
> Rev. 4.00, the TRSCER register has bit 9 reserved, hence we can't use
> the driver's default TRSCER mask.  Add the explicit initializer for
> sh_eth_cpu_data::trscer_err_mask for R7S72100.
>
> Fixes: db893473d313 ("sh_eth: Add support for r7s72100")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
