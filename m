Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26D1A42F8
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 09:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgDJH0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 03:26:51 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35783 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgDJH0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 03:26:50 -0400
Received: by mail-ot1-f68.google.com with SMTP id v2so1132327oto.2;
        Fri, 10 Apr 2020 00:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGqUDkMyUDGl7VVhXa8WG/REtqhU4iY/2ocjn64gPfM=;
        b=BMQrUUhqdlYPjlEmvICjtVVt7Sb8NynK1VcgdrW+rHu1wVmasxhERdfiiKkiGjBLvG
         p/tTMgDRG7A/6TroNlZzYq0H+H8wYAtiEDpoHhLLrkUFgsNfmlAD21Cv44UIny0gaMVV
         /dNYf1L92DEy9bStiatfuaMp4XTpPn0WytEayZ+57dyN/KYkTAQ6WJ6gzgkVt8uoKajT
         bY/uoly4ygrDJmUBR2U0B1QzeVH8Jp2+THePo7TWa1e9JC6Qo4z2EVBokXeUnb3148PG
         IIAcUVN0H7nkwsYSyD7RcurOYiWQtReoeG6+1upnVoasRm35SqBJFbSFZFK3zHvx3Vfa
         vDxQ==
X-Gm-Message-State: AGi0Puadhc72Zm2QTvsWlaOFnMZtinIIrzPv/jEb0+Lbu1iS4cJaWsjc
        t4ERlzt+7w8ytsURPCCDleo03JZ/8zTgGxMEswE=
X-Google-Smtp-Source: APiQypLr/sjrnpwB9pQixWC8DWS5YZ4U3S4bp7uZRbD2EmxXJKK1SVMTlqAkvYa8eK2CJywp2s4W8K/RnCjoFP80X8o=
X-Received: by 2002:a05:6830:1e0e:: with SMTP id s14mr3054376otr.107.1586503609934;
 Fri, 10 Apr 2020 00:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com> <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
In-Reply-To: <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Apr 2020 09:26:38 +0200
Message-ID: <CAMuHMdXnGdxqy6KUnJW69zwmNvHZhSpfXz0PancNrK91SMZp_g@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "arnd@arndb.de" <arnd@arndb.de>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Fri, Apr 10, 2020 at 4:41 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Thu, 2020-04-09 at 11:41 +0300, Jani Nikula wrote:
> > For example, you have two graphics drivers, one builtin and another
> > module. Then you have backlight as a module. Using IS_REACHABLE(),
> > backlight would work in one driver, but not the other. I'm sure there
> > is
> > the oddball person who finds this desirable, but the overwhelming
> > majority would just make the deps such that either you make all of
> > them
> > modules, or also require backlight to be builtin.
>
> the previous imply semantics handled this by forcing backlight to be
> built-in, which worked nicely.

Which may have worked fine for backlight, but not for other symbols
with dependencies that are not always met.

=> Use "select" to enable something unconditionally, but this can only
    be used if the target's dependencies are met.
=> Use "imply" to enable an optional feature conditionally.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
