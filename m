Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB77214F6C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgGEUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgGEUkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:40:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A835C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:40:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x8so13631215plm.10
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5E2/xymIHd/oE2wG0/KbyavhphO+AZFeonAQnQ3LGSw=;
        b=sKoGGkv7RQ8leGBT4u7PIqpXT1OAG2k5DtI6OTaFoJW3P6kXmhmlEV8gNoZxFgpRYv
         +bEM9FGCkL+5GjK7Emn1G1pCbsE2wR8C4+0yMLf7ISpXrZSYQRJTF9VPBGIYm0YNUf3U
         GEqmdla4q92u6mNJtkFE9ixISvIB6OCt4AB19fcLfRqc852Fn2Zpy/6pewtw2/8puSwU
         FE9KY7DN9+pJpRWXFWSZQBxYyp+65APqoR3p/7SO3ZYszsFXjpQ93L/mtMSOAGYojbsA
         KtMyZ8ztK4Rpeg7oiSHnTPMSj3rkIgb/yw1ZuksiLp8jlLb3LlrmAp77QYt9zKk2otrk
         oV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5E2/xymIHd/oE2wG0/KbyavhphO+AZFeonAQnQ3LGSw=;
        b=RNWz6XfX53q5tjquMzsZJ5CZN7wRrZnf6PfWOOsNBvAOOse3K5yiGoLsZfZH+zDRL+
         orvZqsVNHYfzvX7ApVVfHPO+O7NFPLj6gYjglffc5ZKITZViv6tQpw2NiX43LuCcy5Q3
         P1pmWv9YLmQTEjtRuVyb4VbLp7nAqxyqKLXHKvesw1NeAUiLWHN88J6yFrBSxjOn5dCN
         cVZroBYDW+UjOhnZjYu07kzxaUkqnbhiUtqXB+qXd3rp4YNYMAaXzdheL6zHDLVntGKv
         t/kKJJHswtYJ8XheNLHqFbw/XRUX6f0DDXQY6dw5hfn3AghhZOZxkUPBrB2WdcP+JuMu
         mwKQ==
X-Gm-Message-State: AOAM533x68QUXO5tpzBsioZQS7U1bNcoHD2WDHY+cRW+PLhsP6kfh39U
        BRoVZo/+96K4igsSEev/XF2gOJ47
X-Google-Smtp-Source: ABdhPJw9dHzHmhz7FBhjvcsRNJ4VL0s7BwFIEZ1jj2kgEhP3tmP43aldMOp+fQtht+dpRX7a7uuizQ==
X-Received: by 2002:a17:90a:f007:: with SMTP id bt7mr30060723pjb.214.1593981600540;
        Sun, 05 Jul 2020 13:40:00 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id s89sm7648926pjj.28.2020.07.05.13.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:39:59 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] dsa: bmc_sf2: Pass GENMASK() signed bits
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200705203625.891900-1-andrew@lunn.ch>
 <20200705203625.891900-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3e6a8859-1481-04c9-d3bc-1cfd0db2ff4a@gmail.com>
Date:   Sun, 5 Jul 2020 13:39:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705203625.891900-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 1:36 PM, Andrew Lunn wrote:
> Oddly, GENMASK() requires signed bit numbers, so that it can compare
> them for < 0. If passed an unsigned type, we get warnings about the
> test never being true. There is no danger of overflow here, udf is
> always a u8, so there is plenty of space when expanding to an int.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Likewise for this patch, the subject should be:

net: dsa: bcm_sf2: Pass GENMASK() signed bits

(not the typo on bmc_sf2 vs. bcm_sf2), with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
