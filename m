Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456F250D605
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbiDXXiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiDXXiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:38:50 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830F815A16
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:35:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so12024896pga.0
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8Y6oc0IcKScQBHyuounIhW3Xh2S7LFXrY2u50c/VWBc=;
        b=bpf5lKgxK1BqM8l85KToxiHjVdhAIuSbJ9bydnzEB2xLx5mo9B9jknmTzePRpheVkp
         i1cqKJPuDgMu6MLZj+T8lyEU+1ICpGlo4X9SrxCOD5bbpIxFucrXbCA6U7PtKAb6ogPO
         mbb33w1jDdAl0xMeKbbLfkBrmOnkeLyIEzuZspc+iYW7GsR7Gilf3+t3aCm55Ey+K9ax
         3dXHXSAPghHUaxjfu9Fp4AcY2EXnV1LJxWunBAvcgycl/z39kxPA1D+O0NXkjKAczZZJ
         f8eqZB072h707kOaiwquH0q7zQdnMRvs5vb/6g8p++WK6qeB8caue3/3EZEQLH7ItUj1
         c1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Y6oc0IcKScQBHyuounIhW3Xh2S7LFXrY2u50c/VWBc=;
        b=C8tcg3dOuhoK9rXKbjXb0vAty+B4u/kO0Hdgd/rJEFbcdIl+xszl0a9zqfq0bahYBQ
         ZjmitNxBN3br/C72FQh0udRrt+wtU4Mm61on/k4hWf8qyi932DWeDiWhqaxtwvcrvE+G
         jr/ylfi7yw6nqMTQ9eLDWnkYcvz9aDa1DuqKaM1k7ddS8SWqEdzVp6+GeaJ0n91xstT5
         L2WkOjOj7j+dv8y6D74BLrtKRcoZgDQOvAZD207zC6qtoDsik8Ec74QQZq7WR75IVYng
         fVHRhfFed9ejkkGvhFpA3ZVrh8UxBhVHVpuF63GzU7xRWwA1SSgEc7qjoiriqvDUOBPO
         E5QQ==
X-Gm-Message-State: AOAM530p/2Hz7mE3R/3jM8rfVYyvfTz1f5jsz3wsyXJUMin0xan3bZFL
        z5NW195fsFExfhIstrtUg6s=
X-Google-Smtp-Source: ABdhPJwugIYbxq0k5QALps9khYUuOOtLVo7C/plKg+NfgIjE2skJDHCBBaGfoppJTTpcY4qASGf+Rw==
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id b3-20020a6541c3000000b003635711e234mr12967906pgq.386.1650843347540;
        Sun, 24 Apr 2022 16:35:47 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c17-20020a056a00249100b00508389d6a7csm9503866pfv.39.2022.04.24.16.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 16:35:46 -0700 (PDT)
Message-ID: <cf3bd081-25ed-8747-89d0-24ff5eab1870@gmail.com>
Date:   Sun, 24 Apr 2022 16:35:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 2/4] net: phy: broadcom: Add Broadcom PTP
 hooks to bcm-phy-lib
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-3-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424022356.587949-3-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/2022 7:23 PM, Jonathan Lemon wrote:
> Add the public bcm_ptp_probe() and bcm_ptp_config_init() functions
> to the bcm-phy library.  The PTP functions are contained in a separate
> file for clarity, and also to simplify the PTP clock dependencies.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   drivers/net/phy/bcm-phy-lib.c | 13 +++++++++++++
>   drivers/net/phy/bcm-phy-lib.h |  3 +++
>   2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
> index 287cccf8f7f4..b9d2d1d48402 100644
> --- a/drivers/net/phy/bcm-phy-lib.c
> +++ b/drivers/net/phy/bcm-phy-lib.c
> @@ -816,6 +816,19 @@ int bcm_phy_cable_test_get_status_rdb(struct phy_device *phydev,
>   }
>   EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status_rdb);
>   
> +#if !IS_ENABLED(CONFIG_BCM_NET_PHYPTP)
> +struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
> +{
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(bcm_ptp_probe);
> +
> +void bcm_ptp_config_init(struct phy_device *phydev)
> +{
> +}
> +EXPORT_SYMBOL_GPL(bcm_ptp_config_init);
> +#endif

I would place those in bcm-phy-lib.h instead of in bcm-phy-lib.c and 
have them be static inline stubs.
-- 
Florian
