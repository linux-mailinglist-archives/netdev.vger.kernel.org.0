Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443B369875F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjBOVat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBOVas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:30:48 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FF2313C;
        Wed, 15 Feb 2023 13:30:46 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id he5so111819wmb.3;
        Wed, 15 Feb 2023 13:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wwhRGKzzxRmhQ49hS4QWcVBIwbWV+s9hRRdXyP5iSY0=;
        b=Z6PKgfElsvUztbaP1UgQEj8lPrM9wfGWphQUsc3B7ceB6XwV29NZos2LBs2XD/Lbea
         OnFSLIPD0g7doJnmy2CzMuXfd+lZPEb9LxbrJHTvRK84geSiS420fnwq0kc5DTvFiHpI
         p/JnQHxxwJTe7cLr1dto5kt5OgOO7Ua888nhaMysM49JWuCeLQu1sAtaLrN+Xkx8tdhc
         atExoZ0RLXF7kRnVZmrqAIWuS/ErosDOatILyvTxC3Q5rlLn6Q1WE+OhL5+F1GK9daIc
         XGKrnsJqQjUfcSl2riQyVsNgv3jc8OawoXWmxHkQvczv/ZhlrhuMgsXxyIvK6jXix4NO
         1FDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wwhRGKzzxRmhQ49hS4QWcVBIwbWV+s9hRRdXyP5iSY0=;
        b=6MSUthqonT5QQ0G8xk76FR/PDp06coIWWYTsqhiKL/fMSokl6o8MeiBO+CXPu4bUb0
         BzI/u/oXusngwnvr7v5Lhq919clZmaACTtlQMGYffv+q13sgkoZSueP0NkXvcm3YMFma
         UQc/DvFZAnVNuYT+x+Wjzn8dN0NWkLYKxS0kAqFQFd0qKTV+o8vkFsmE5ifl1i8bOOpU
         Vy6bnJLmcCc5Npx6PbhO9JIu7akEwMhzvmGgBZHxsCD7bdpnAZGkmmJc1LlUqu0HBYye
         zJ8LpDm0OK4Sm/EM8SFskuGLImjSyvh/CZRDwGAEhBOX4zX/UsQXONM++Xo7BpfCRfJu
         GrMg==
X-Gm-Message-State: AO0yUKXKhuLzbyjh0OYiRzztAKMJE4yXq4ySHy61Zl17YJ7hhghqRysc
        uy13ys6ONDW7NfBMx7ytJ5o=
X-Google-Smtp-Source: AK7set8iMEK3VVHdeN+zzhoqFRVgIYezADgMMKC3NNKrFZt2Pq9ug0Jwtc11+Mj5+wUNupHmjzygQg==
X-Received: by 2002:a05:600c:816:b0:3dc:5390:6499 with SMTP id k22-20020a05600c081600b003dc53906499mr3444167wmp.1.1676496645352;
        Wed, 15 Feb 2023 13:30:45 -0800 (PST)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe947000000b002c559626a50sm7912740wrn.13.2023.02.15.13.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 13:30:44 -0800 (PST)
Message-ID: <066340d4-adec-a4da-3b88-d52f10f8bceb@gmail.com>
Date:   Wed, 15 Feb 2023 22:30:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH -next v2] wifi: mt76: mt7996: Remove unneeded semicolon
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, kuba@kernel.org
Cc:     pabeni@redhat.com, angelogioacchino.delregno@collabora.com,
        ryder.lee@mediatek.com, lorenzo@kernel.org, nbd@nbd.name,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20230215055650.88538-1-yang.lee@linux.alibaba.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20230215055650.88538-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15/02/2023 06:56, Yang Li wrote:
> ./drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:3136:3-4: Unneeded semicolon
> 

Please be more verbose in the commit message.

Regards,
Matthias

> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4059
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v2:
> Add the linux-wireless to cc list.
> 
>   drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
> index dbe30832fd88..8ad51cbfdbe8 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
> @@ -3133,7 +3133,7 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
>   			break;
>   		default:
>   			break;
> -		};
> +		}
>   
>   		buf += le16_to_cpu(tlv->len);
>   	}
