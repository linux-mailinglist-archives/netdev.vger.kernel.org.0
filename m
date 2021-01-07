Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DD2ECCED
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAGJiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:38:09 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:35704 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhAGJiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:38:08 -0500
Received: by mail-oi1-f178.google.com with SMTP id s2so6775448oij.2;
        Thu, 07 Jan 2021 01:37:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZUt2K+i9npBs7pxvZRnyzlReljyirAW0eiTdXkBmOF0=;
        b=iSgehNTbB5kJG+9HGaAGNP1m48DrYoqmZR4OvbNcBuWZ893we3DCwpGYk7lt4VwHh3
         jKHs1eJWH0ap05MZk62YYdd9/zWmx8NfLL9C0Vo3qgHCVpX8E81lpT9Utwv4zbSf6Xd0
         tXFN3tWy5gXCs+HjfLmojN7OmR8snubDx0uIyReQri8nwrx7JqNN820aOgdno4ao0QQ1
         1Cxxmn3kdk7V0AbJwEHTuRnzaSVwZihZkAVOHY3e+yL8ARIPJBxxikLb/QU9q2ZRRgr3
         LPJhGqUPonuwnbRlzNloG4m4QqKp2TnFxTXwhuZpwZ1dLRkzwcoTuuDzgJvpRTaCE3sh
         wM+w==
X-Gm-Message-State: AOAM533hJ731l2KgAaj+OdNBqYQamTfvDVnQciwLDl6lDebhtvDgUKuT
        v3UBlM9t1VeEKSQyIZxCtjhHD7RDsumWNVfi6cE=
X-Google-Smtp-Source: ABdhPJz3gr6tNxEeqOMrdHZW1gusfeToP8WCP418yx8Q3h2UyAd3IH950M4fyAWsd4yXzzNtZDMI5yUXU2/xIT5zDEM=
X-Received: by 2002:aca:4b16:: with SMTP id y22mr5903379oia.148.1610012247463;
 Thu, 07 Jan 2021 01:37:27 -0800 (PST)
MIME-Version: 1.0
References: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru> <e1345e35-35d1-aea0-c9c8-775b28cd9f8b@omprussia.ru>
In-Reply-To: <e1345e35-35d1-aea0-c9c8-775b28cd9f8b@omprussia.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 7 Jan 2021 10:37:16 +0100
Message-ID: <CAMuHMdXqUXH1_0j5H6dPL=jnUVi8zwqHk-zpOpGQcT7x8_dUJw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] ravb: remove APSR_DM
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 9:43 PM Sergey Shtylyov <s.shtylyov@omprussia.ru> wrote:
> According to the R-Car Series, 3rd Generation User's Manual: Hardware,
> Rev. 1.50, there's no APSR.DM field, instead therea are 2 independent

there

> RX/TX clock internal delay bits.  Follow the suit: remove #define APSR_DM
> and rename #define's APSR_DM_{R|T}DM to APSR_{R|T}DM.
>
> While at it, do several more things to the declaration of *enum* APSR_BIT:
> - remove superfluous indentation;
> - annotate APSR_MEMS as undocumented;
> - annotate APSR as R-Car Gen3 only.
>
> Fixes: 61fccb2d6274 ("ravb: Add tx and rx clock internal delays mode of APSR")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
