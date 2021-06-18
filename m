Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF63AC6B2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhFRJD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:03:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48152 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhFRJD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:03:26 -0400
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1luANJ-0001MM-4T
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 09:01:17 +0000
Received: by mail-ej1-f70.google.com with SMTP id lt4-20020a170906fa84b0290481535542e3so1804556ejb.18
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Rpo5v0so+s5bFTiYG2x3xDNdr/p1fKsU61iXsP86UQ=;
        b=F1syu2ZwWg68fYkvBJYW0C5/Wgeyfg6e9jiYNg1SoQpKIfZ+HyL0Wu2fwvulqvF6C3
         g/GDXA6ZBc6kgXeCm6YHBKefACuBn6vFoolc7DsaOE7Gv0Q+023ZwhvZhWAk8/3Uazrq
         1R0pfcLBtATb37Mp0dgrCMDw8J9VQWzqBOFyt3vL+z0qsbte6ucBpfNq+SFd1Pjb25nU
         oOdfXUsdNdppd55wBOGw6JZ7fjP7gosNGgDOwm3bxIeyj/O5WKfww6jMQoa94GcRVG7Z
         Q2BIxzyQY3fRAo2RuLQmXAilkH3K/rHUpUY0tJ6J4RQxc8Lp5LdewUnW6AuvlMOtOoFf
         rfQQ==
X-Gm-Message-State: AOAM530EvqIxnmo8yXrd3YVlv92CJO3tyMut/zXZ6eP4B3EhTZy8qynB
        4q6iXbRRkC1jUHVldV9MJPmoFRUsp5UJcUwX/cYnuL9TgQm7R1H7Mjlbhtr7OhtgJu5kqYfzE5S
        fZKWGh5WhetTQsb0VUWdCZeB0zmue0dqzeQ==
X-Received: by 2002:a17:906:2752:: with SMTP id a18mr10451911ejd.458.1624006876931;
        Fri, 18 Jun 2021 02:01:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2MB2+Q8e0FJ/0cH1Qq/fGA0AiH6hJVmgNkJ1FexQwOk2Rh7qUGVrnNY3ri6yOvmqlsOFFpw==
X-Received: by 2002:a17:906:2752:: with SMTP id a18mr10451900ejd.458.1624006876745;
        Fri, 18 Jun 2021 02:01:16 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id de6sm402336edb.77.2021.06.18.02.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 02:01:16 -0700 (PDT)
Subject: Re: [PATCH v2] NFC: nxp-nci: remove unnecessary label
To:     samirweng1979 <samirweng1979@163.com>, charles.gorand@effinnov.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210618085226.18440-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <8ff9ac28-5d83-ebf8-a6b1-53a2a7b7d912@canonical.com>
Date:   Fri, 18 Jun 2021 11:01:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210618085226.18440-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/06/2021 10:52, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Remove unnecessary label chunk_exit and return directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/nxp-nci/firmware.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof

> diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
> index dae0c80..119bf30 100644
> --- a/drivers/nfc/nxp-nci/firmware.c
> +++ b/drivers/nfc/nxp-nci/firmware.c
> @@ -95,10 +95,8 @@ static int nxp_nci_fw_send_chunk(struct nxp_nci_info *info)
>  	int r;
>  
>  	skb = nci_skb_alloc(info->ndev, info->max_payload, GFP_KERNEL);
> -	if (!skb) {
> -		r = -ENOMEM;
> -		goto chunk_exit;
> -	}
> +	if (!skb)
> +		return -ENOMEM;
>  
>  	chunk_len = info->max_payload - NXP_NCI_FW_HDR_LEN - NXP_NCI_FW_CRC_LEN;
>  	remaining_len = fw_info->frame_size - fw_info->written;
> @@ -124,7 +122,6 @@ static int nxp_nci_fw_send_chunk(struct nxp_nci_info *info)
>  
>  	kfree_skb(skb);
>  
> -chunk_exit:
>  	return r;
>  }
>  
> 
