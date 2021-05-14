Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D72381406
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhENXCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:02:17 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39761C06174A;
        Fri, 14 May 2021 16:01:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d16so770974pfn.12;
        Fri, 14 May 2021 16:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ARtuV6Izl8dDcoFpAU9dVSMrwARq2uS1+QSfRHaBrnU=;
        b=ORly3qATx/+mrQskEmbpLxXYymFTlpSiFtwOPBDlV5Ffs+OmPTQwf9Ab42LSi1rci9
         4Cm+I6rH/A+neGbr9SLyAjb7pRY8UFNi2On7rSIcCFoOlXT+rEdz1mKP1QztKlvE3OkU
         VayfFmnE3OsnGq79+GF2/8P01CMnENEvcXwe1DfpBR+WW6insBAhr8h+EA3lVLDJDoPA
         csVVCWX6ANb6fhiSALG4bk9wnAnOIaQV2CFyuhU0OolgwOa8luMuE7YWvxL+s2kOQlir
         U7GlIDF7iae1vs6bFqvqfrQm6kI3V3OdeV4xRqofbfi6Zjnl5/yRut7hqyllkKGgJqQM
         dViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARtuV6Izl8dDcoFpAU9dVSMrwARq2uS1+QSfRHaBrnU=;
        b=J4T4t5a3R5PgJcaXl8B44GFgR9epP8rs5pmzvMn9C9q12ff6gVTj18kwmkEYeBA6wm
         sbr/IwCuNllx2aPOq+wlPAJd7yQug4OLUtE2phmmcgTktvzVRNaAkTA982mwqg+PXiJ9
         Peph3jg7a3w7hfqeQevWb5mKpF2Lvkl2lEAF8vnOwogxZNEjrq6lhTTIiQfrkhuMEFHP
         eZOqRt2fvOynhiiOquGpLMrlnvKl8pfKn89P99wIO+t7QqmU7VV2O+8D+Jd796Q8MNdW
         KurRstJmFnc2nEibIDfVYuu/t/Pri9bVjB0UbA2S7cDDBv/plJNquzRdDokclZhzfoqA
         f7lA==
X-Gm-Message-State: AOAM531lkaSyW0SDpBi1GuiIM9P5Z/t6YYCRpsmhhyOwkdnekyMSb45/
        5ypkC3yaEr/rT3KBLM29k3VeYO0RtRqb4w==
X-Google-Smtp-Source: ABdhPJwH/9G+m85mhM4evmgbW5OViYZ7PSCo8fIGHra+CKnjCJKw0SIL/DeOBtgCM/q9b4AKckaY7g==
X-Received: by 2002:a65:5288:: with SMTP id y8mr23426586pgp.31.1621033264163;
        Fri, 14 May 2021 16:01:04 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id m20sm9900205pjq.40.2021.05.14.16.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 16:01:03 -0700 (PDT)
Subject: Re: [net-next 1/3] net: mdio: ipq8064: clean whitespaces in define
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210514210351.22240-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <260b7b56-3b0c-2fe1-5a28-9a0f6e8bf167@gmail.com>
Date:   Fri, 14 May 2021 16:01:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210514210351.22240-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/2021 2:03 PM, Ansuel Smith wrote:
> Fix mixed whitespace and tab for define spacing.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
