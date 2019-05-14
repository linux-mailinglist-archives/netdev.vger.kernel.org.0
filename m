Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911A41CC73
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfENQEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:04:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENQEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:04:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id i3so3459025wml.4
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e8ea7Z/M3TKO0e9o9SlBT8iUT8PTmvhjTFTM5vT0+co=;
        b=AQYdgmvC/hCmkpmz/UpO75ozwidPCfJzeqY4HRNqm9W1fyI+ScR22neoqTdJ75VvvE
         R7STNz1Vl3lD2IOtc0MYo4BCB7CZNnjTbV3fgd8v6wWsJIakck7tO+7adBCkgnd6ZkRz
         v7VkapFx87rJ5lP3Wp1G2Vgr4gFJaGTjb7jENW9XrSsWB1F23BXySBw0Ptrw/bxUt3KK
         CMRDcUWHpwjRli2yLfvxWkIQxfU1JJ8M+EnHBLxAqQPMPvzzlMYseXONMAHi+JvpXDV1
         wSFmm/oCxVsHo02nvFn5vW8i3aV1dG/j5iC4Po6FJs2ENHqXzYhQ7prq5f8CV97zpzKT
         y8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e8ea7Z/M3TKO0e9o9SlBT8iUT8PTmvhjTFTM5vT0+co=;
        b=O0VvGL69aHTpkqUwdyfQyzp+CgRuNZaVLl494WuGQ8mpxB+nWo8jbw/XL7TM5tD+ci
         gX/0+pF+vT4aeOpK58OR/3/6GqFta3+QuG0w1TK+KhLXmTUi4pCoQzWD7XhDAVlc1Q+7
         GEtDLttwUM8IYaHqTMaUJ+XaWfbwj+aQJzsiP+4Pn1jYLo3ghy8AfK8xFn16WtYz0f//
         XoKrRJYn4GIFCQ89OYrKULDQcrjuW2r1hUucwpGNoqf60qdIINMDngIitbWl2cdrufpI
         1TXZDp/sE42Jrcsag/xP9LrExXnpk5uu8baT2ZA8tUCs9FpBg9FruO9Huj4yoaVoeLek
         u2Kw==
X-Gm-Message-State: APjAAAUfyVxG6y+zlT8yVTTJyjUjL5thCrMBZCNcXr0QAobrc5FeNfoK
        Ohv8hku/8hucZ2cYcBvg+f3Mxw==
X-Google-Smtp-Source: APXvYqxLPOzEzIyFZEp2uZRuKf5NZXmARYnouXPNAMmmuT7QmzXnSxyx0w61cfNxJvxUs29Ic76nFw==
X-Received: by 2002:a7b:ce03:: with SMTP id m3mr18494654wmc.99.1557849886203;
        Tue, 14 May 2019 09:04:46 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id c2sm14043675wrr.13.2019.05.14.09.04.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 09:04:45 -0700 (PDT)
Date:   Tue, 14 May 2019 18:04:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH] net: Always descend into dsa/
Message-ID: <20190514160440.GA2584@nanopsycho>
References: <20190513210624.10876-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513210624.10876-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 13, 2019 at 11:06:24PM CEST, f.fainelli@gmail.com wrote:
>Jiri reported that with a kernel built with CONFIG_FIXED_PHY=y,
>CONFIG_NET_DSA=m and CONFIG_NET_DSA_LOOP=m, we would not get to a
>functional state where the mock-up driver is registered. Turns out that
>we are not descending into drivers/net/dsa/ unconditionally, and we
>won't be able to link-in dsa_loop_bdinfo.o which does the actual mock-up
>mdio device registration.
>
>Reported-by: Jiri Pirko <jiri@resnulli.us>
>Fixes: 40013ff20b1b ("net: dsa: Fix functional dsa-loop dependency on FIXED_PHY")
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Tested-by: Jiri Pirko <jiri@resnulli.us>
