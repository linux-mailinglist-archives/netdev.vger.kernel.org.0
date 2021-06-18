Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8C3AC5E1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhFRIXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:23:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47088 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhFRIXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:23:05 -0400
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lu9kF-000675-QI
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 08:20:55 +0000
Received: by mail-ej1-f70.google.com with SMTP id de48-20020a1709069bf0b029048ae3ebecabso22103ejc.16
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 01:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d/K0H906YUUKfdepwlReDstttzt/rZTiSrnXu1rsGl4=;
        b=PAOmb8GMB9Pdk8e5m8GHHCykz+GWLFdwVaMPGKHOT9FsQlgM7tBNqYRLk+7Ge8aQ5t
         nGEQViMFOsCtL94O8xy+9ffAMdUlSUTU2mYng9cIkuZi3z/U8bW0NYviyI2oNuQ8aR8R
         vZK3R/bsO8gN1LhYN8KM63Og99x0Xxtun7WawDqseB8fbi4NkwhqHst67HVAiSWZnxj4
         PEhxABm7Y3G158Cguvvq48r4zt9VJfkPq6ok1BtC8/sRJ1Po85qeMomN3ZDTZflZptbR
         1Y5z5rfpiwYCckhu1NUEAExqkz8RmSrcOfj6HzOjhptsj4YeywwMuO9MGZhqdIAAdRXv
         JwgQ==
X-Gm-Message-State: AOAM533UXQAVNxL5h+CEesNO7zFKWqJRND4w15rkUdCqggY71WinwEG9
        XQlbJUef6MpzDuYfaaHppWwizu8JFrahtQYJt/JrWrnfGVTNi3zVIEImL65MT7gicdpojZWeRAc
        kaHTL3mpR4+0o4bjHaNsjhO7C67UuijiXng==
X-Received: by 2002:aa7:d799:: with SMTP id s25mr2326478edq.161.1624004455076;
        Fri, 18 Jun 2021 01:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/I7P0xXP0OFvYW9YaIccS4kemIdCdzd2LI7F/6hxbx946RKljIW2c8ALFC5WoxW7v5BggJw==
X-Received: by 2002:aa7:d799:: with SMTP id s25mr2326465edq.161.1624004454904;
        Fri, 18 Jun 2021 01:20:54 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id ci4sm704168ejc.110.2021.06.18.01.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 01:20:54 -0700 (PDT)
Subject: Re: [PATCH] NFC: nxp-nci: remove unnecessary label
To:     samirweng1979 <samirweng1979@163.com>, charles.gorand@effinnov.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210618074456.17544-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <99c12036-5444-b41b-165b-9f6a1812810e@canonical.com>
Date:   Fri, 18 Jun 2021 10:20:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210618074456.17544-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/06/2021 09:44, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Label chunk_exit is unnecessary, so we delete it and
> directly return -ENOMEM.

There is no plural here, no collective "we". Please, use simple statements:
"Remove unnecessary label chunk_exit and return directly."

You could add here the explanation for question "why doing this?", e.g.
"Simplify the code by removing unnecessary label chunk_exit and
returning directly."

> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/nxp-nci/firmware.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
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


Best regards,
Krzysztof
