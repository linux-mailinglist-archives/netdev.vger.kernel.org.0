Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631CD25C6F0
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgICQeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:34:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0FEC061244;
        Thu,  3 Sep 2020 09:34:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14so1724471pjb.3;
        Thu, 03 Sep 2020 09:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0SreTI5dox8s28M6/auODVGh1xK1K6zrOSFNfC6w3vs=;
        b=ATnKmeKZUHExDczaj8xkMPJN2gS11BwMtDb7bUQ6g4pIklbuK0WQd9f93dgXtWVw2D
         5tOYirn4FAV8bDM8GA9GDvDNc3njkWEnDURleWktNDzN7Byqaj3IOLRdnPxR58Pvgxlj
         SzB+9dqW68Lc6EzcBC7xvh9K9Vlcxa1SNYHjs9GzoFBzN73lQrsMP5jBmQl9doxA1KEh
         g7nZppOQyq/NPHKpnyH03u2hk8J19Q39DbJlAKvfSuH4xslkv38yZzx5YoaHs/ntWBer
         q6yGcb8GWEXJ5l/c5waspPuwwej1k91zaEh6+6W8Ci5i68H7cwcas9k5rNsX4ZVmK1RM
         axpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0SreTI5dox8s28M6/auODVGh1xK1K6zrOSFNfC6w3vs=;
        b=k2gQ16C3vr9P2lh7SO3+js9TSOGJNcM9kwh8gcVLgvyMrnzsWwJxWXLTo3ZJbG5kEi
         Fsgd6VytLrukOjEvWZwUmPO74xhbDl4ZkbaVRZzZJSseqGFEnMjIMHndunseI8lX+vfQ
         63ismO/IhXxWx/uF2jr3B0jwDVkBM64CR19qBHca9OngtEZBIE6NbaXRoI5foPyhbJee
         NO2VWj1iBkX4C0wUnFyw5oVSolorMQma2NhS3Grr81cKkmPc56wfj549qi7oszdwSeFa
         dc5IacEo3dXSMfU+ucfMwQfJ2OYsPBpZjVRS99ClaHAkydGPwKj9BcucC5dP656Sjjrg
         UP0Q==
X-Gm-Message-State: AOAM530/mkyEF2a0G+fe0s+GkwgtzJ7RcMu2dmxdX2qyFDhyTs+ayrl0
        istWTmFMCoEWY/gHUXwJAoAEDCqT7lo=
X-Google-Smtp-Source: ABdhPJwkgKsBtCE1829dvyTApxuLPbPox3qrXCmcgEqLDh/V8fZGiZ1vw6uKb8/fz/uGwyktFN1Iag==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr3935482pjb.160.1599150859236;
        Thu, 03 Sep 2020 09:34:19 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w185sm4098976pfc.36.2020.09.03.09.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:34:18 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: dp83867: Fix various styling and space
 issues
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200903141510.20212-1-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <76046e32-a17d-b87c-26c7-6f48f4257916@gmail.com>
Date:   Thu, 3 Sep 2020 09:34:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903141510.20212-1-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 7:15 AM, Dan Murphy wrote:
> Fix spacing issues reported for misaligned switch..case and extra new
> lines.
> 
> Also updated the file header to comply with networking commet style.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>   drivers/net/phy/dp83867.c | 47 ++++++++++++++++++---------------------
>   1 file changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index cd7032628a28..f182a8d767c6 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -1,6 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0
> -/*
> - * Driver for the Texas Instruments DP83867 PHY
> +/* Driver for the Texas Instruments DP83867 PHY
>    *
>    * Copyright (C) 2015 Texas Instruments Inc.
>    */
> @@ -35,7 +34,7 @@
>   #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
>   #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
>   #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
> -#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
> +#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    BIT(5)

Now the definitions are inconsistent, you would want to drop this one 
and stick to the existing style.

The rest of the changes look good, so with that fixed, and the subject 
correct to "net-next" (this is no bug fix material), you can add:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
