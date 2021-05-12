Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C194037BEFD
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhELN5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:57:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58696 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhELN5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 09:57:20 -0400
Received: from mail-vs1-f69.google.com ([209.85.217.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgpLQ-0001Nt-4p
        for netdev@vger.kernel.org; Wed, 12 May 2021 13:56:12 +0000
Received: by mail-vs1-f69.google.com with SMTP id k8-20020a67c2880000b029022833ef2244so11192616vsj.18
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lXaHKVR3mIuGrEd20jO1ipa+dY/mERv/ymrR+ENUctY=;
        b=R0EDCqy6ts13hP63wjypmO8t3Qba7NELCDMeL+y74tUVeYQNGgjeum6pvXWov1LCFo
         PF3GZmpzKfggLXjl29Qj0nJHzIsqyuHwzi3ap5wI2HUstndPALrB+awBGLYGhqShFL9f
         tu9CH6+OJFwPcLo25IbbMIvQwrUEExH8ghnGkhF7+7M28LEj2FvNPADUKcFE55/lrVIg
         GPnQC8TIZmhY38S+pJSZwCsll1RkS7HsYHN/AUY329YTCtp0Hjm8YwVfG3yHew6/uKyG
         9tzRD8s1nQTAM4YZP0B6UWvYIbifXhPWUsX+8nvTdoglJrw9c7YdXQ+fDI/BsaQJyCZ2
         ADCg==
X-Gm-Message-State: AOAM530eF+2YdYHE/WdKdDDKpqV0b0pLrOepcZbAD4UkKXprtIpAkPOP
        Hd4jxGzq2KTdNbkrJ+Zg9PsqT3/8U90r+tkSTpe1UcRoOhKbNRa+DdcgS+2qySLCZvDCg9GNFYW
        ryZzsAJVPRhFZ4gR6B9yJMGfry8bFbNNodA==
X-Received: by 2002:a1f:a156:: with SMTP id k83mr28414318vke.15.1620827770725;
        Wed, 12 May 2021 06:56:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFKHt8OP4wmzhJrUkVfrF17uR7sG1r9+2EPNedobXl/PjCRvBZV/7/nIvERgBeuVfww2lPyg==
X-Received: by 2002:a1f:a156:: with SMTP id k83mr28414306vke.15.1620827770584;
        Wed, 12 May 2021 06:56:10 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.2])
        by smtp.gmail.com with ESMTPSA id g192sm1238075vkf.10.2021.05.12.06.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 06:56:10 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH] nxp-nci: add NXP1002 id
To:     Oliver Neukum <oneukum@suse.com>, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
References: <20210512135451.32375-1-oneukum@suse.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <154ad073-f5c8-0d76-7dcd-220623cca865@canonical.com>
Date:   Wed, 12 May 2021 09:56:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210512135451.32375-1-oneukum@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 09:54, Oliver Neukum wrote:
> The driver also works with those new devices.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index 7e451c10985d..94f7f6d9cbad 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -332,6 +332,7 @@ MODULE_DEVICE_TABLE(of, of_nxp_nci_i2c_match);
>  #ifdef CONFIG_ACPI
>  static const struct acpi_device_id acpi_id[] = {
>  	{ "NXP1001" },
> +	{ "NXP1002" },
>  	{ "NXP7471" },
>  	{ }
>  };
> 

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
