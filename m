Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DF53F865B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhHZL0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241887AbhHZL0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441A0C061757;
        Thu, 26 Aug 2021 04:25:14 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n5so4419588wro.12;
        Thu, 26 Aug 2021 04:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pTv7rMpcJIe661VZq5nd5lL6sVkRZaxPyz6ErnGBqok=;
        b=CwJKkFHj3n7PTwJzYvFzA3zUudaoBzgU7+CL/dGy1BUy5XrKUubWrXrgLbGEfYRmRB
         q4FiHy157gLdLKlKhi3Ogz5jkmVcFGAwDCURVsvZmDvAxOrTS1Gc5d3+Vhwx6kHau8DQ
         UA3L6coG0q0wnW3l4/My6v8oReLEGReUCmw8vFWETe7pCaZ3MsuZgrIMKXgL4bzZs1pa
         Ox0O6bPbxhn/VOOp9z/GqniaxVrvzUBqt4kIVmICipWGpTGj/r6j3cQa7BUFx85a04qX
         uw7xC/6ghOyWMQlJt31vNTd+mcfRuSklRzIcIqVU8Hwuah/PrF4WvkNV3CgdlkjfwCwD
         yRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pTv7rMpcJIe661VZq5nd5lL6sVkRZaxPyz6ErnGBqok=;
        b=nrCR7IpZn4erEI/mPVNNP/CobBrcimcZQTBvJQ58jk8XbeT2AHuVQj/baRS5JByU7n
         xOGaWbRqCydsADjuisNOqGLZKO1lKYhXEuXYTPwNFeax/0i1kvTgn/fY/ggJIBZbzVFe
         uH9ykla7W58LnF20dbUztJZTZbggBJsxco4iLGB7c7V0/aN9e7LzJA9KKKjIVhXx/dGm
         tKaSXRJXQINGrN2Py5JtdxgxoNIL3g0UDhy/Zdl1xOey6JJ0Pk8InGppbLT9Ehobg8tw
         funZvU84sqQOlaEmk0sajHRTxNM8X/KnAGOGFzJ2zrl2cmRFF2FX21umPKfAf0zeOVLU
         rDJQ==
X-Gm-Message-State: AOAM532OjaUvgAq8vSq5wdGICoUdR40ZJS/YzX3BArQeN7LL/ekffC19
        LrNwkm23YSzBC9GN+qoihAc=
X-Google-Smtp-Source: ABdhPJwtGOwCnpR/i7FuKRsr3XCRi2i+k+aHeDy2KW6Xgiy3a0yeQ6dmVnSMG4hfWYcTDyDTno521A==
X-Received: by 2002:a5d:6301:: with SMTP id i1mr3194937wru.423.1629977112806;
        Thu, 26 Aug 2021 04:25:12 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8192:e700:d55b:a197:684c:2cfe? (2a01cb058192e700d55ba197684c2cfe.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:d55b:a197:684c:2cfe])
        by smtp.gmail.com with UTF8SMTPSA id h16sm2916676wre.52.2021.08.26.04.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 04:25:12 -0700 (PDT)
Message-ID: <96014c79-44f6-dea2-2b53-6cbfebac9351@gmail.com>
Date:   Thu, 26 Aug 2021 13:25:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Content-Language: en-US
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>
Cc:     Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-3-saravanak@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210826074526.825517-3-saravanak@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/2021 9:45 AM, Saravana Kannan wrote:
> This is just a quick fix to make this driver work with fw_devlink=on.
> The proper fix might need a significant amount of rework of the driver
> of the framework to use a component device model.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>   drivers/net/dsa/realtek-smi-core.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
> index 8e49d4f85d48..f79c174f4954 100644
> --- a/drivers/net/dsa/realtek-smi-core.c
> +++ b/drivers/net/dsa/realtek-smi-core.c
> @@ -394,6 +394,13 @@ static int realtek_smi_probe(struct platform_device *pdev)
>   	var = of_device_get_match_data(dev);
>   	np = dev->of_node;
>   
> +	/* This driver assumes the child PHYs would be probed successfully
> +	 * before this functions returns. That's not a valid assumption, but
> +	 * let fw_devlink know so that this driver continues to function with
> +	 * fw_devlink=on.
> +	 */
> +	np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;

Are we positive this is not an issue that applies generally to all DSA 
drivers?
-- 
Florian
