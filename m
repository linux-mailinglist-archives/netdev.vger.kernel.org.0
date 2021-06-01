Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B773975C5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhFAOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFAOuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:50:16 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F65C061574;
        Tue,  1 Jun 2021 07:48:33 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so14373017oth.8;
        Tue, 01 Jun 2021 07:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Kj6ioPeCLs4B4BFisWU9q6uXkqmgdZ9EHR/xw+SastY=;
        b=DHzKqXNPdhx9CUOqPzR7heC1sbMC5Af0QQxq302XggNVGsl9pAdUyjsk5ijXNUxyTV
         twkZ9XrnRvIHDojV4Nev0csoiDN3O24HtrLhlJaiFFBBLJY4mDq8cZif3gjIiiA6XAtr
         VkfzfOFDI9YIDzIU6NE/jNA1bIF/xqICfXomQ7yW4C0LJeQPO8MRxmxeURmMnq23QW+H
         FZ31L2MeBxgImAoFOGROX2wgkzf2lVcJbgOou6hr/Rf4VKCGuBa7FLs16+WM0wM1+2Hj
         i2SWKmKSY/bJoX64G+zWmlLR7GKjSXbdcEdSTM5rJOij90Je1AEg03xuEfh/QJaEhMgg
         YKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kj6ioPeCLs4B4BFisWU9q6uXkqmgdZ9EHR/xw+SastY=;
        b=pOB+iDNm8Ip1F7VBdmbe+j21+jNFNo+XKxJH5AXStz9C1N3bCgXg7baxx3F/VW+19W
         DLVI+/eZAIiHlpb7GVTKmWXAd4Eg7eUAjJbCwIwzN8TrsFA0At3nsv7RUHQ9fmtpWtTb
         DEplA5GoAuJoee//JT67n+CjOTuHd7eN8VVQS+9DQMNU2tZTwFxxxrUVpw8VBlFm7UXI
         hPDbOnIj7ZdQ8AiuzKV58FtoKqO/MoXaGIZr8ytrKcWdIAiA3JeMJDzFpOZ7hIsSOh72
         RRH7muAlVlM06ka3r38esojxhiAcaJq9wF87aTPRgdHVTrsREIWBlMsrV5zFLk6Ejmkg
         fn8w==
X-Gm-Message-State: AOAM53354mPTgeolv3+fG3tBT05BNqdbi1fVIqAAJywXMXs2V2XFXWDH
        6ozjVBlX3sdyZwQ/MDoDan+aa8sPvbA=
X-Google-Smtp-Source: ABdhPJz87NUsJRnakXomDD+00Fi6iPQl+pyAX9EU7bF0mwEqsYplck6GrJbY3mIEuj3HaGsaM22vYA==
X-Received: by 2002:a9d:4584:: with SMTP id x4mr21151290ote.85.1622558912936;
        Tue, 01 Jun 2021 07:48:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x29sm335254ott.68.2021.06.01.07.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 07:48:32 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: Fix a typo
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, dsahern@kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210601141635.4131513-1-zhengyongjun3@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <61d4798a-67bf-f2f1-28a7-c2f2024d4759@gmail.com>
Date:   Tue, 1 Jun 2021 08:48:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601141635.4131513-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 8:16 AM, Zheng Yongjun wrote:
> possibile  ==> possible
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/vrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 503e2fd7ce51..07eaef5e73c2 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -274,7 +274,7 @@ vrf_map_register_dev(struct net_device *dev, struct netlink_ext_ack *extack)
>  	int res;
>  
>  	/* we pre-allocate elements used in the spin-locked section (so that we
> -	 * keep the spinlock as short as possibile).
> +	 * keep the spinlock as short as possible).
>  	 */
>  	new_me = vrf_map_elem_alloc(GFP_KERNEL);
>  	if (!new_me)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

