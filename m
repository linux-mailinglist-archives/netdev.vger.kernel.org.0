Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E172AB9F9F
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 21:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfIUTjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 15:39:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40000 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIUTjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 15:39:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so6645504pfb.7;
        Sat, 21 Sep 2019 12:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=olEdqj55RZspGaLOfNT6x2Xafj6rXEsyo6pBhMNSYRE=;
        b=sVl1kwWe3KUr8pOL/7xoGQ85SnKJOAhFhwwVNwtyDDNFzTrEGhMtrmzWIpxYDDSOIO
         HCtVQAJfUQ2q0H9vnlRRsnqMPU9zGLL2VZfLm0ZSEmiAh8/gYduoMRNDGWc52r4R19iN
         dLys3ah8YvW+XGrTl9zkk4ruHESoWSvXN2sWEzJ2s/ndO6v65VinGQ8wm+NbWiC0m2PE
         fxlw+67SzKAz8AaVQ/zisarFZxjda0jpMvyp5ZUpKcYFyUeDGEHU0sb6E1NMVdnUIwOz
         8H0dOv3OWAz2VNhHuIaiWsIQVBcsGga2atJj5wlnCsT/W0IpNHg0bejbWxcOQ6xrxSk+
         msbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=olEdqj55RZspGaLOfNT6x2Xafj6rXEsyo6pBhMNSYRE=;
        b=seDpfSJ1kMg4dS+Bj9CZYq9HGVWjgDmqwV1ULzThF6sxs4wWneQcot3IcxiDG9rV2R
         9Ei6fGzT3f/pqef+SrqGCFMyNwJysi3E82wOgDklscQeh3ag24QjaOT0hb4q9YvzBLt5
         yhG8NMXzxdzTakWaXRJA7IDLKyLgzbVjHpw2bvXtoKsbQDi5rEU/d8kcuTQuZ45FvgLz
         pQBML9AQkZEzLQI0EFOHLz4HhBoy2rjJiY5rgyf27pSQ3w7pP8S7Zm1RsZpCgwmMYoO/
         slUO3/vPghKcy0ljIK9AMTadfXKa4PUYApdv8tEcvbwHCxOBsNd5FDmHtgQolEL9t+pK
         y8uw==
X-Gm-Message-State: APjAAAXp/KOul8ZKWQJnd5WWl7gjCqir5kSkyreYW5sn6/gii/KoqsVc
        eDQwUBTH4VRT5qhInxfF2jLtU1DRt7A=
X-Google-Smtp-Source: APXvYqypIUrSeX2XATTvjcJuzyz85wgt6dKjlQQ5vIah2BQrbr2JIsLQJVkERviyK/Wr+Y0baIBjsg==
X-Received: by 2002:a17:90a:3086:: with SMTP id h6mr11846362pjb.1.1569094783200;
        Sat, 21 Sep 2019 12:39:43 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c16sm7164041pja.2.2019.09.21.12.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Sep 2019 12:39:42 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: Use the correct style for SPDX License
 Identifier
To:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190921134522.GA3575@nishad>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ce3b968a-df4c-8d07-6b7b-167a069da3ef@gmail.com>
Date:   Sat, 21 Sep 2019 12:39:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190921134522.GA3575@nishad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2019 6:45 AM, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Distributed Switch Architecture drivers.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
