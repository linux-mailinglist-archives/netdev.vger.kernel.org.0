Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8AF245990
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgHPVA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 17:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgHPVA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 17:00:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA0FC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:00:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f10so6478022plj.8
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MRGMMA6Q23PGZufcPpdCqraL6erNZVItjaVW/zeFf2E=;
        b=jL//M0gCZGBDp5xhsAWICdjOIGwaijipLWxbNibwCtatKMC2btdqd9wgpr8D8bBhVx
         ppXqtmiJvu4wQ9RALx45aXma7LnS9VCWjgdGtScvXSt/XwYErs3tbPHvdYuTcMzD6+NC
         4Zm6WexixmibQDFBJxuI+zL5R5izKopWW1m57BbdJtmInha7g7uBNfTxQIbq9RR1T78S
         ghSRC0Sam+zLNbtVcryojc1BorhC9R0R3aIv8Xbu5ylczmOE2gWJq/e5Lo04bsSWYWJE
         blR8J1DbGhTL8xT5wgZJE96LY+k/iqYZuwvBBsnxjtBP3w5pleYKttiHKAv5me84/JaR
         zgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRGMMA6Q23PGZufcPpdCqraL6erNZVItjaVW/zeFf2E=;
        b=T6tVB+HXZ0FhDkkl15kFq55ks9JpDyiEDGjBj7AVJ+sDfHDbkNz59ytvTfvNxsOum0
         wwey+LvTPdzV389/Rl3r4B9LWI+WrgjgXprhXpRt9y6ikVflr9fD87zHGOZRLMaNGf6k
         03fD7k8j+uSH9TmDEEBur+TJ8wYkb9vNqQammzdeeV8S6cjNwcYj16v20SDhTomwtvlm
         +G1t22vX1pGEYiG8ICtaGT5aYkJrRnE28eDkHjP5F/i2VtyE3h+4e3PUx6xJvtA41Y1H
         4nS89yxYVZPab6qOAsK7BBGv6X7qy2lxOAcivW158Lf0O3cdawVpFBsEIcroD4xUh0KX
         TJBQ==
X-Gm-Message-State: AOAM530ipz4rr1WVW7ogIL+hqSlOxYRpyn90DskEDNOdM63uneWe9Fb+
        U6tLGwauXSYyvOBewJOG4D0=
X-Google-Smtp-Source: ABdhPJxiCOAFUdGODYe43APmahcUCTtPzonLsyotcN+7LWJOGiGTIXajpF2Em9siapReJxyO459drQ==
X-Received: by 2002:a17:902:b708:: with SMTP id d8mr9037771pls.138.1597611625655;
        Sun, 16 Aug 2020 14:00:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s61sm15210892pjb.57.2020.08.16.14.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 14:00:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/5] net: phy: Sort Kconfig and Makefile
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200816185611.2290056-1-andrew@lunn.ch>
 <20200816185611.2290056-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d64a9d51-90b9-9d8e-6b9f-b7baea8875cb@gmail.com>
Date:   Sun, 16 Aug 2020 14:00:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200816185611.2290056-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2020 11:56 AM, Andrew Lunn wrote:
> Sort the Kconfig based on the text shown in make menuconfig and sort
> the Makefile by CONFIG symbol.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
