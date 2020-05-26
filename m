Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB641E310B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391084AbgEZVTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390009AbgEZVTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:19:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C33C061A0F;
        Tue, 26 May 2020 14:19:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v2so5674365pfv.7;
        Tue, 26 May 2020 14:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JeAQlLbjnTzSsEHohZQ0vJ5FLklCwj2YxNU2h1n7NuQ=;
        b=NtswoNCNvSHXQHLdhbKDMF4mbwJ4/k4/AYx7avK5d7NkHxwb3TOI3WLyF85XDbUreC
         rVy3kLeEQLfLUksmXBnThukV4FcIRhvE+wkxyvurL32zr759NbMQqxcbdGqUr/dVFtLJ
         5zeai2YcCr0eAOOYhQ/XesR0cJLQKESpnQkpgO/5GK3LkMTagccdrGlzZ96UrwDLTdax
         vmBS5os3yhzVgL+OS/gSbbT6asxpngAO/kGItaSS0G+lNnm9avs0m034e35M8H02TBxy
         uYWut7qXhGX6HODzX8vBY6L2o7dUUyk5tauJtINodNTydY75/EqPq8rKZiFVusIT5fID
         3Rdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JeAQlLbjnTzSsEHohZQ0vJ5FLklCwj2YxNU2h1n7NuQ=;
        b=tiiQWv6Dq+d6y+txRDWwHEs0IQM0CsvDMcNR1mU5mCQ67j/LSF7U7tkB28eAJAtxWt
         sBjyclX3B2JGUnfCyHGyJ2Ou7vey8Dw0cC43q4hdDGHMCyGplkTl1xwX9a3UQP0bBWMw
         GKlPD5EzMlEbHrvrg4o9cfS2s7HsryNv97wD2hSgYJEbsTiQsj9KgyNgphTLjrb/4NHV
         RMQfgPEHKbJpfQxx10nRG3kcT0iyud0U+XnO6gYugC93iGRqsqS+Bv3EVhYQa9BORxFv
         irf4UrN4BOk4j9Zf+r+13aH+HkdnsjGFcoBGdEUL08CofdQHNaS0q/3MMu6zn/qjBedu
         jjpg==
X-Gm-Message-State: AOAM531gLCUYHRkfJZaCg2mQrKDcRgCBRUlWqDlZdRPLy/jaguFcYTxs
        prvR2XUzFbnTEhbjcdV4CGhkkfyr
X-Google-Smtp-Source: ABdhPJxxPvECfHMjgO8qZyLNEDh/2j4pXjnq+vWu+/VRuhgso78TB7MIxphvnBJfvk8nEqVZ6JSUfA==
X-Received: by 2002:a62:6041:: with SMTP id u62mr699242pfb.62.1590527958496;
        Tue, 26 May 2020 14:19:18 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y5sm369664pff.150.2020.05.26.14.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:19:17 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: phy: mscc-miim: use more reasonable
 delays
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-2-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1941644c-4f10-7480-4195-66e39f9c14d8@gmail.com>
Date:   Tue, 26 May 2020 14:19:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526162256.466885-2-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 9:22 AM, Antoine Tenart wrote:
> The MSCC MIIM MDIO driver uses delays to read poll a status register. I
> made multiple tests on a Ocelot PCS120 platform which led me to reduce
> those delays. The delay in between which the polling function is allowed
> to sleep is reduced from 100us to 50us which in almost all cases is a
> good value to succeed at the first retry. The overall delay is also
> lowered as the prior value was really way to high, 10000us is large
> enough.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
