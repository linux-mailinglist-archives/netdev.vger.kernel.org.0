Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235A9235454
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 22:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgHAUsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 16:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHAUst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 16:48:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD96EC06174A;
        Sat,  1 Aug 2020 13:48:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f9so9364163pju.4;
        Sat, 01 Aug 2020 13:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9wKPsRsas14J6rLcc90OvGkDesVW+dImVS3IdYYGJ0U=;
        b=CZp4IJOwaIO2gFQtha1lV1lYM+vm6IJnhuBrWQSjkDIFQDCKBnMy/mSL9Z2SF2WL7E
         VKXTFmC9lWNFNnsIvNp1itXadVnbCLjCM7QMuPhs1Q1mkwZblGqsHt6fB/1BdcTYIGoL
         0QDA4+hWjuyCW/rRX/nqUX6GKkuUGHR0fkVYwaFfBoDdBdke3QLiwKmWH1HT6j/ipLVr
         kUDTft262j/6oGKJBOK8xk12jjRSSw+sHHeFFKqdjLkYKeZANU9GjZuSqojol68oxiYa
         7ZVyFaUt6tPuvIqH/eusCYAhbcOLWYNisw66g2TyHWrkD12gBYZBqxzfEeN7OKynjSyf
         JaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9wKPsRsas14J6rLcc90OvGkDesVW+dImVS3IdYYGJ0U=;
        b=U7irdd79GVFy8+Of30QDd2yv42HahIodAIcAN+s+zS/I3NUNouEhLTEdMiEuRNRk0G
         iMom55bGLbTjWuKQiS5fkTUc6JCJXtIU/QE/OhyA3v66656qOuWNqZ0KUqkLtECFj6Yb
         lnOR7th2nFbWpQBHbtv9rDAzWgL4pNTcjxK+YaJc8EokWN33cYSIkPxHDxR7jP6FyOEZ
         gH7KA9btjl7QjAh1IkXK5Xxj3HevLJA1Dc5n8aIcgO4LyGdVGhGy7THnfEYPv8sRz04S
         jRbKySJ3btZ1RCtK7T1pM5cj/oO2P9zAoRI9pZei1KTfbm8H6KHr3BupYWsHpc485MDz
         KIDQ==
X-Gm-Message-State: AOAM530iNDmkCsXMWJYIUUgt5LHaIrP5qiIBKTkTUTgsFRhdD9mWIkMW
        KBuFpEn9+P8Rh1LP9qWITd9bkzp3
X-Google-Smtp-Source: ABdhPJxrYGGBhjuG1t9SjQej1BuIQoPcNPFwWgfQ3A9FUuLnzOaFfC4quVby7FJ8ZrfGYpbOR0fbXg==
X-Received: by 2002:a17:90a:eb98:: with SMTP id o24mr9098627pjy.150.1596314928450;
        Sat, 01 Aug 2020 13:48:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j142sm15011790pfd.100.2020.08.01.13.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2020 13:48:47 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/2] net: dsa: qca8k: Add define for port VID
To:     Jonathan McDowell <noodles@earth.li>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200721171624.GK23489@earth.li>
 <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0658ae6-f7e2-cb79-9674-835bb15ac35e@gmail.com>
Date:   Sat, 1 Aug 2020 13:48:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2020 10:05 AM, Jonathan McDowell wrote:
> Rather than using a magic value of 1 when configuring the port VIDs add
> a QCA8K_PORT_VID_DEF define and use that instead. Also fix up the
> bitmask in the process; the top 4 bits are reserved so this wasn't a
> problem, but only masking 12 bits is the correct approach.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
