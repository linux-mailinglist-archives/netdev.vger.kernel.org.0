Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19D232CEAD
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhCDInl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:43:41 -0500
Received: from mail-vs1-f48.google.com ([209.85.217.48]:35637 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbhCDIng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:43:36 -0500
Received: by mail-vs1-f48.google.com with SMTP id t23so14156806vsk.2;
        Thu, 04 Mar 2021 00:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2OhTnF2creedGjCoTW6jeoXvRZlk5sHqQYV+sTcA7U=;
        b=FwmybSTMqY36JTEi5tuCmWluaj1zqa3qoQNhIhYcyIFOaMHvgTEIzu+7MN2yZ0a6Br
         c2qAqxaAJ1+NV2ekhYhEey5UgAaUjHW/atuC//rMuvKyboQ7zJQWmMRjxU3IpvzzaN32
         DV/A6mt51sxaO8fOV+1WjPZMNomCeZF6PG4PC3VENd0botsUy8qOotxj2stmRwG/gC4S
         yGaWkB2QFGMgce8cGMmMWpkSIfRDJp5C3b1Eyb27uEaMgbQe/TGBxbizpm/JOFC2aBMT
         JdbuJSYPBV2wdFliZBVRzXCz+phnJsDgZEl8ZtKUZxAwEcyEa3mHnd4zbS0tFXiSWTNU
         WtlA==
X-Gm-Message-State: AOAM531TeqX+max+U/ZUZ3LNDrRpG/pqUtZz3Uog/iSWChLII42fa4Ms
        jOdpp8IMNDdvDGm+K1rKw+rrAR2hp58RlTn7BW8=
X-Google-Smtp-Source: ABdhPJyhI1bosRWbMW0EnwUbh9sC17KiJru81eEqaAh4E9wnQjxi/4cc7+FR5+mypPP2WNuou6NQJfO3PhLs6YC8vBI=
X-Received: by 2002:a67:2245:: with SMTP id i66mr2190624vsi.18.1614847375636;
 Thu, 04 Mar 2021 00:42:55 -0800 (PST)
MIME-Version: 1.0
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru> <a92afef3-2ae8-e8c7-855d-f0e86a1beede@omprussia.ru>
In-Reply-To: <a92afef3-2ae8-e8c7-855d-f0e86a1beede@omprussia.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Mar 2021 09:42:44 +0100
Message-ID: <CAMuHMdVgasQPwQRsoi3nc6jqBaL7yhwBoyo7feac=f7dLnz5Uw@mail.gmail.com>
Subject: Re: [PATCH net 1/3] sh_eth: fix TRSCER mask for SH771x
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
> According  to  the SH7710, SH7712, SH7713 Group User's Manual: Hardware,
> Rev. 3.00, the TRSCER register actually has only bit 7 valid (and named
> differently), with all the other bits reserved. Apparently, this was not
> the case with some early revisions of the manual as we have the other
> bits declared (and set) in the original driver.  Follow the suit and add
> the explicit sh_eth_cpu_data::trscer_err_mask initializer for SH771x...
>
> Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
