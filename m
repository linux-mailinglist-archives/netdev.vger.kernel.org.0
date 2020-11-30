Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67D52C8D0B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgK3Sl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:41:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46811 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgK3Sl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:41:26 -0500
Received: by mail-wr1-f66.google.com with SMTP id g14so17502998wrm.13;
        Mon, 30 Nov 2020 10:41:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ZOrDa6ldlj99dU4NwWopQDDabM2YX1J/bSlPxihqSc=;
        b=tb9dsEBbAlbq5zXLrNCEwwMKbGcvpGiHDGphRfkDFMrmuFVWskOwDkXu9YkYzcJ6nS
         5ssFd/NeMaBtwBouoHHwCwMNH0vVhEXZlxfsm9gAu7GhXyWUm0n0AhJs0uIYz8zucLTk
         +LcHgIJYfdnC9JsfSv5ZXyjQjDBMmQFOr3I32vCKq9SA3ldhiE+lp5bpP7A5p+Uoe1IV
         Lbt9zEwvheQWH6wF2UHnORwhDfiNEfLSvfI1f7NZUg5o53SoF8Yxyci2rchC9s8CIQu8
         jWmwdZ5MUUJ5fv2VlcMMI1vHmcPvI5+NKdLVKZgcNxkICLvpaghWLtUgw3AJ9Ex7sjuG
         0daQ==
X-Gm-Message-State: AOAM532HqTsElQnVePLMHVwpzRQgMA+AYMIp2RgL4Lp5wJ6sZnBGnEP0
        nvi7FlptLWGNJ2Q8U9ZPsUM=
X-Google-Smtp-Source: ABdhPJx/ocpaaLADvVke5dqXezlyxFV2p7C5qdqnWe5pkBjHsJXNrEB1rkx5N13R+yVHQMZj0yCuBg==
X-Received: by 2002:adf:fd0d:: with SMTP id e13mr29118129wrr.85.1606761643575;
        Mon, 30 Nov 2020 10:40:43 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id e27sm33508526wrc.9.2020.11.30.10.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:40:42 -0800 (PST)
Date:   Mon, 30 Nov 2020 20:40:41 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Message-ID: <20201130184041.GB28735@kozik-lap>
References: <1606737750-29537-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606737750-29537-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:02:30PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> The delay of 20ms is enough to enable and
> wake up the Samsung's nfc chip.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

It's really not easy to work with your way of sending the patches.

I am sorry but you have to adjust your style to the style of reviewers
and the entire community.

1. Again, you ignored/dropped my Ack.

2. I asked you to send all patches referencing each other, which you can
   achieve without any effort with git format-patch and send-email or
   with in-reply-to.
   Seriously, these tools work properly by default! You have to break
   them on purpose - so stop.  Now, all your patches are scattered over
   my mailbox. They are all over mailing list:
   https://lore.kernel.org/lkml/?q=bongsu.jeon2%40gmail.com
   Browsing this patchset is uncomfortable. It's a pain.

Please, work on your workflow. Get help in that - there are plenty of
open-source contributors in Samsung. Ask them how to do it. If you
cannot, read the mailing lists and see how others do it.

Recent example, one of thousands:
https://lore.kernel.org/linux-arm-kernel/20201130131047.2648960-1-daniel@0x0f.com/T/#m4a9ed644869b8018b8286a6b229012278141cb66

1. It comes with a cover letter,
2. All emails are properly linked with each other (scroll to the bottom).

Best regards,
Krzysztof
