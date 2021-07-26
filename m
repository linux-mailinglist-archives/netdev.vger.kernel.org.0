Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110613D54B0
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhGZHPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:15:04 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59604
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231725AbhGZHPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:15:03 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4E1E63F257
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627286131;
        bh=FvaN4SdC0zxcpggC8bSxsPEztnFEL+6bxNge1diRFzQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=PZcRFcihiy2U7YbiB7bJ7YLh3MxqoWQxoGj8dmRLBIEd3X71wrpwHaaUXhs5BXCwc
         jzXrYvWp5r0elxE8aapXiIzSsCWt+hTQJyur5i7Cfrcw4m7vdwiFQY01quT3QTSuax
         TgZZ+Pa3LxGsPWWjSlBKPBbAC3gvBRkv2BZbtXh+DOE9/KIbhbkn7ZDAGCf7EmR7hY
         Zv9e8J+9+SIYnoIDHyjcZs1EWbPrkpgsKDb6YHVQaXdNqdHurL6vRI8CE11yf0Tnte
         t9nqkxag+ItEOM3nYBPmJ59ksZkn+PO6Bz/wl7OiH+xcV8OBXuxyC2W/E4BmBzkFTc
         UUUuRDQoLS2Zw==
Received: by mail-ej1-f72.google.com with SMTP id g21-20020a1709061e15b029052292d7c3b4so1816917ejj.9
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 00:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FvaN4SdC0zxcpggC8bSxsPEztnFEL+6bxNge1diRFzQ=;
        b=kZ6VLuBZ0LVrb80RORvbTjJ9e73EnpiqhSj16TWCpDods0qdcKj+iiRX3rumQaPEjo
         MIyYku6cItONxO156aseMHdtPU0HRlQI7SfkS4Lp7y12ATdZVcxPM4hI9pyn1A0ndO4H
         tL3ViUB9jK4ffYuhsd/rzBw8W34TrBmJkQIsrlJFdu/zJb9ZccT9wzaqu6oBNJ0iqRE/
         Ru3H/Ax8n3Wo2KLUsYKQX2Akc3I1M2fS81rXccLYKhjP81ImbXaqEGS4gV7jx1Msp3k3
         k2V9ww8mAr//ijor3YfRfbOGLt1AvHUsj9ITk8BRasL1qUyfwSQLY851jm1cqPL2vHRf
         4kiA==
X-Gm-Message-State: AOAM530WX4oYNzvBZrqmRuA1AnMhL7INrip/eSet1w+d+6p3jWyT7b7X
        6Z3VlAYni8LK/BUxFyU3caTfO4UsQqs89rWFkvCUGZb82A40k+gcWIh2PFV7vaP16o2gHFmvjWm
        PWkKMvLxqpyTh4zkEYEXux8108JksB5+wHA==
X-Received: by 2002:a05:6402:b8a:: with SMTP id cf10mr19704690edb.61.1627286129510;
        Mon, 26 Jul 2021 00:55:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs0UmEkOvoygFFaLmTFWp2A8ytDvkEF8K93BiDtS5olNm+AVEIwQfY3opR+oXzikcn12XV+A==
X-Received: by 2002:a05:6402:b8a:: with SMTP id cf10mr19704680edb.61.1627286129380;
        Mon, 26 Jul 2021 00:55:29 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id w13sm4023959ede.24.2021.07.26.00.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 00:55:29 -0700 (PDT)
Subject: Re: [PATCH] nfc: s3fwrn5: remove unnecessary label
To:     samirweng1979 <samirweng1979@163.com>, k.opasiak@samsung.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210726032917.30076-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <94177278-c8fe-89f3-97f0-7010078b9ba2@canonical.com>
Date:   Mon, 26 Jul 2021 09:55:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726032917.30076-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2021 05:29, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Simplify the code by removing unnecessary label and returning directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/s3fwrn5/firmware.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof

> diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
> index eb5d7a5b..1421ffd 100644
> --- a/drivers/nfc/s3fwrn5/firmware.c
> +++ b/drivers/nfc/s3fwrn5/firmware.c
> @@ -421,10 +421,9 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  
>  	tfm = crypto_alloc_shash("sha1", 0, 0);
>  	if (IS_ERR(tfm)) {
> -		ret = PTR_ERR(tfm);
>  		dev_err(&fw_info->ndev->nfc_dev->dev,
>  			"Cannot allocate shash (code=%d)\n", ret);
> -		goto out;
> +		return PTR_ERR(tfm);
>  	}
>  
>  	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);
> @@ -433,7 +432,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  	if (ret) {
>  		dev_err(&fw_info->ndev->nfc_dev->dev,
>  			"Cannot compute hash (code=%d)\n", ret);
> -		goto out;
> +		return ret;
>  	}
>  
>  	/* Firmware update process */
> @@ -446,7 +445,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  	if (ret < 0) {
>  		dev_err(&fw_info->ndev->nfc_dev->dev,
>  			"Unable to enter update mode\n");
> -		goto out;
> +		return ret;
>  	}
>  
>  	for (off = 0; off < image_size; off += fw_info->sector_size) {
> @@ -455,7 +454,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  		if (ret < 0) {
>  			dev_err(&fw_info->ndev->nfc_dev->dev,
>  				"Firmware update error (code=%d)\n", ret);
> -			goto out;
> +			return ret;
>  		}
>  	}
>  
> @@ -463,13 +462,12 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  	if (ret < 0) {
>  		dev_err(&fw_info->ndev->nfc_dev->dev,
>  			"Unable to complete update mode\n");
> -		goto out;
> +		return ret;
>  	}
>  
>  	dev_info(&fw_info->ndev->nfc_dev->dev,
>  		"Firmware update: success\n");
>  
> -out:
>  	return ret;
>  }
>  
> 
