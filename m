Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F115217AA6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgGGVqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:46:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B4C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:46:35 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so756933wmg.1
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YyI1mBNFJE/tAvFWJnGwURikTC/iIAum2GLC5TKOBYQ=;
        b=pclxRsOIiB3s+LoeHEE5ZwnLZYY9TguYBPa9wKj+GEOxngYy86Vc19YCkeoesBcbbh
         G7NcTmPehgUGFavCBL88/0yFS+FxlHX6leczbLM/pVqACe5BFt7gCNmuT9TQtB+f46pY
         8tA2E2VIy1uYIEZGDv4kf/o1EzugUnx3m5w4MmjYwHAM97/dOBlfeWTJWojh6h6bgFHI
         M2YO4z6YVr/+9tMpsvHSbg4Mq7dkhsCJMOSYAUl+QEWZxZYO8eJIhwOKoY0rEvgS8aTN
         lkRa0N+ZhBWgfYvHVqfwIm3tn7zXNRWj6HsWBQuOjcdQjK//8VuUw5pDXQXfp3VM4V1L
         O1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YyI1mBNFJE/tAvFWJnGwURikTC/iIAum2GLC5TKOBYQ=;
        b=YhS70/J/2KNIx247gjbZder4W2pFWIjLPYj5IehtYRZRGeF9xpPE2F0j7/5a3i5OLA
         V3AqnexU3tsv6JowKEtvXurS+wTvMLypXNnxhYBH5f69Q3/zmV5KRJmgOjikdkaM8ps+
         4RSXCBrT1EcKlFENc4M+2ocZmclnHd4HqPLxYah6ZBDhvrbjvs344vFD29ZunuEas3c2
         5u/WIJoNEB7IdtCjkQ8CMv3vksgOSEiS1vw2ynyx0N/3tFPe0cXufppRyWgoXveZI7DM
         TD5/zvX3W/OfQqa3a9MrekF4P2AffleWpmB0IZjs7pQXlof7N9oDNoAObNw2umliMuHk
         u4HQ==
X-Gm-Message-State: AOAM532Rfiw5zZ3piYpiG1zynODZRKcGu3hQvXwdgx5I/SfXny4vU324
        qUs//4o7fRx9JZtVc0A5+aw=
X-Google-Smtp-Source: ABdhPJxi4SBok7q4Vxpzv3ofbmFe73nS7f886LTFK4ixgOKv8caA89JP8IFqFJH2mOvHsnsnPwCEnQ==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr5842942wmi.109.1594158393916;
        Tue, 07 Jul 2020 14:46:33 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u8sm2540652wrt.28.2020.07.07.14.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:46:33 -0700 (PDT)
Subject: Re: [net-next PATCH 0/2 v5] RTL8366RB tagging support
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200707211614.1217258-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1addd57-49d4-b186-78f9-bd601959bcc9@gmail.com>
Date:   Tue, 7 Jul 2020 14:46:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707211614.1217258-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 2:16 PM, Linus Walleij wrote:
> This is essentially the two first patches of the previous
> patch set: we split off the tagging support and deal
> with the VLAN set-up in a separate patch set since it
> seems we need some more discussion around that.

Yes, good idea to split them that way.

> 
> Linus Walleij (2):
>   net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
>   net: dsa: rtl8366rb: Support the CPU DSA tag
> 
>  drivers/net/dsa/Kconfig     |   1 +
>  drivers/net/dsa/rtl8366rb.c |  31 +++------
>  include/net/dsa.h           |   2 +
>  net/dsa/Kconfig             |   7 ++
>  net/dsa/Makefile            |   1 +
>  net/dsa/tag_rtl4_a.c        | 130 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 149 insertions(+), 23 deletions(-)
>  create mode 100644 net/dsa/tag_rtl4_a.c
> 

-- 
Florian
