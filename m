Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9E647EEC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfFQJ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:58:23 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37672 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFQJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:58:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id w13so15296350eds.4
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 02:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=k/FkMrNeRTkozEqierq2rmbV5zRaMHg6J2eVIWl4duU=;
        b=GztjFeCgsx2WVQQlaCXYbhcPsiu/7YqqR997H6U3zan9rYs0xa6xFeiRivc/RtwM4x
         b/Q9XQ210Gv+8E+J7NDLQUrKd2naU4exI1G+xlsKnjxh/RGc/6gcZqi2NpV2DfMZRC5K
         uidbnB9l/Kn69qIo4+cWA4rb4+B2Fbf4QJ/WAvydPHIP2SHKcIj6K6yDJx+lbjldoNwQ
         UP6mmVLBfZ9zo0ukP6Krhe016u7ATMe7UCtiXsIHvD6jCTsMINZu9tNSxpgXv2A5W3EG
         yp6OIeyJeWq7Gzf4F/jGva/OHSnuOxtAeQ0eLKUmMQ9+PLwB9QJyd3EX1UeD+D7wl7ni
         xSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=k/FkMrNeRTkozEqierq2rmbV5zRaMHg6J2eVIWl4duU=;
        b=oxMkS5NMLY51iahC00fUl4f2zUnLBxIz/nIKaZ1ijH7dLkZun0oBxUYIGjlXCACgB5
         XEwlJCN67R2ory1Mk4r6itO7PE4oH31jf25AQvdFNeGeruaNLlivEWgOPKrJWEiTF5HR
         4EHJ5manCZdiomvlGTuRz5EdQsxY7xxceDGQLzmHTHQpe8p8v7DxiH8mGTVy9ntOgUCM
         U8Xcg3vxvUck7QCZi6L4j2SbxzLvZtNkbqSdx3rfiRS8Qmyd+zyacz/a1sZUYOuzgX3o
         JuzpdrexxzvBGB299h3aepGlvDpuJ/x7ycgSsg1VkLKsAd9wAr/I87Ron/m27r6DA7dN
         m7WQ==
X-Gm-Message-State: APjAAAVa3tFXlLcAGo84/NjFKV2ba1dwgiepq9ck3FMRpZ7mK5D4F6K7
        3Hx0HMIJ2He+IM+5GottEFmL6A==
X-Google-Smtp-Source: APXvYqzzFOn2TYEUiWfO5QA45ng6P677kxEghJAuKXYs/UNNAuPRaE//NwSmVe/Dj1EArVjJXXbs+A==
X-Received: by 2002:a50:ad45:: with SMTP id z5mr95083437edc.21.1560765501430;
        Mon, 17 Jun 2019 02:58:21 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id d5sm2095575ejk.71.2019.06.17.02.58.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 02:58:20 -0700 (PDT)
Date:   Mon, 17 Jun 2019 02:58:20 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Yash Shah <yash.shah@sifive.com>
cc:     Andreas Schwab <schwab@suse.de>, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
In-Reply-To: <mvmtvco62k9.fsf@suse.de>
Message-ID: <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com> <mvmtvco62k9.fsf@suse.de>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yash,

On Mon, 17 Jun 2019, Andreas Schwab wrote:

> On Jun 17 2019, Yash Shah <yash.shah@sifive.com> wrote:
> 
> > - Add "MACB_SIFIVE_FU540" in Kconfig to support SiFive FU540 in macb
> >   driver. This is needed because on FU540, the macb driver depends on
> >   SiFive GPIO driver.
> 
> This of course requires that the GPIO driver is upstreamed first.

What's the impact of enabling CONFIG_MACB_SIFIVE_FU540 when the GPIO 
driver isn't present?  (After modifying the Kconfig "depends" line 
appropriately.)

Looks to me that it shouldn't have an impact unless the DT string is 
present, and even then, the impact might simply be that the MACB driver 
may not work?


- Paul
