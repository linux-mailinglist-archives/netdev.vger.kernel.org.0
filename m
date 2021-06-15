Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294FB3A77D1
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFOHTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:19:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48926 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhFOHTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:19:42 -0400
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lt3KL-0004Mh-MQ
        for netdev@vger.kernel.org; Tue, 15 Jun 2021 07:17:37 +0000
Received: by mail-ej1-f70.google.com with SMTP id n19-20020a1709067253b029043b446e4a03so4101612ejk.23
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e/PGUSSpRwJWtOH4gYs4F2atjkd8/9rJ+b2AcY5oXpY=;
        b=FO7CadB3ZlzuC7oVVHg/9K1qfEf1dt+JHXHDg1nwBlIEYscn6bThOuQvqE0L5xIk4w
         WQ5yknexPiyJjNDEo6+4znIdKsp0hb+h3RKLGeixgaxrG71OyZModVVkaNEcKhFql96W
         aoM6h0fXNJuoe92wut5dkLlnvMzG3406CjvPi1fBqumZBk9uFbX7TyFgKhIkzeKv6Reh
         ybRiTqXTIPtn/BfIYs5dnyd9eiusEopj6oaNQVw4f6jlAfKFd6IiuCBugbooBGOJW9AN
         Z/rjJhArvx15F1fFY4mZaTzq/fAFyzc9q0fUCVr8RjbrRvwnoXAm4BznTpP7SAumv3FT
         r+zg==
X-Gm-Message-State: AOAM532hy6VsQFwL2peYFRqJ9Q6NO7oyhX6rQk+9U9eSdKIZ4RlI2C2Z
        iFle4eQ49V9P2q7sVikx+c5D9D8RCFaUTuKtrpPbo/09D2k9Mm9fpnfQ5PTunvG//McNWku3V4H
        odVOkT5RSsC1Lr4Y/rkGQ1UwU2F2VfYTjdA==
X-Received: by 2002:aa7:c983:: with SMTP id c3mr21129857edt.58.1623741457510;
        Tue, 15 Jun 2021 00:17:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0PXWMekssI+Wot2EYeDEnefKlmFz9PWFpU7VvbROKRhq9a7DccSGxXH8ArVcWKBS7xmM1lQ==
X-Received: by 2002:aa7:c983:: with SMTP id c3mr21129853edt.58.1623741457398;
        Tue, 15 Jun 2021 00:17:37 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id f23sm9279588ejb.101.2021.06.15.00.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 00:17:37 -0700 (PDT)
Subject: Re: [PATCH] NFC: nxp-nci: remove unnecessary labels
To:     samirweng1979 <samirweng1979@163.com>, charles.gorand@effinnov.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210615015256.13944-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <6129efc3-fe4f-8b09-22cd-3d17354e1c7a@canonical.com>
Date:   Tue, 15 Jun 2021 09:17:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210615015256.13944-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/06/2021 03:52, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Some labels are meaningless, so we delete them and use the
> return statement instead of the goto statement.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/nxp-nci/core.c | 39 +++++++++++++--------------------------
>  1 file changed, 13 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
> index a0ce95a..2b0c723 100644
> --- a/drivers/nfc/nxp-nci/core.c
> +++ b/drivers/nfc/nxp-nci/core.c
> @@ -70,21 +70,16 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  	struct nxp_nci_info *info = nci_get_drvdata(ndev);
>  	int r;
>  
> -	if (!info->phy_ops->write) {
> -		r = -ENOTSUPP;
> -		goto send_exit;
> -	}
> +	if (!info->phy_ops->write)
> +		return -EOPNOTSUPP;

You changed ENOTSUPP into EOPNOTSUPP, which unrelated to the patch. Make
it a separate patch with its own explanation.


Best regards,
Krzysztof
