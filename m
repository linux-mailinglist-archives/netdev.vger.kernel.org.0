Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2495B5E2E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiILQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiILQZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:25:33 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C639E1EAC9
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:25:31 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id d17so5627447qko.13
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=o1qzyV3JsT+xfEHsxGMFOGkeUvwAWRdC86gvatcWfcg=;
        b=mFB5GlffzZFJnkJBSDc1CrSDW4tbof7DJrX6oVtEeBY7xfBPIraAs861bwR7ijoTq4
         yTW34XbiEiTtm2Fgm0H0iKT5xP1KOUVlaACB1KCAzL+E3qK5lX2hUnMecGMQw9o1opGA
         jxV08nvsNra2tGhWOX26awLNEIW506cm74QZAr34e70VOEmUP+9iCTe7ap7MoY3e/PmS
         44qDbvHLyVf73o+EstWZoAXKFiZF9qF/2YRCrcTfKhre7IpH4JbG+OYbsQYr6rSaVU6B
         IDHG3YNmQXzcW1x2wzk+6TcsERaUK+8Sw5vsMCKXoyR+UluxE2+SmzS6OvSOZHg09ULO
         mwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=o1qzyV3JsT+xfEHsxGMFOGkeUvwAWRdC86gvatcWfcg=;
        b=walPQfBGAxANatyV3yDPT04VipW7fSioaAjG0NmOqyov0GNyMT9xEj963DvFidzqzM
         LrpjMor86EFjXucD76lsZb3C3fhoHX6QLGvYIZ3oI3wZL7g6SajHw+LGnz2IBOvy0VKA
         is8owT44AlYIYtHcZlum670H/U/ggxI1JWZ8MofEq9Y8NhF+2+7u3xGGzDfD1uRx16QB
         ElbLH1C2CcRB6qe5zPJhNMHZzW+k02lz/OSD7PUkXGIzmrOy6tekmxaAXUEhBFg5BRGX
         MA3HgfDEHchJa1iJA18w58JPNamEExuDAct9F9ouazPhd5WVapHF26zCr3EckOnGLoCQ
         QjDA==
X-Gm-Message-State: ACgBeo2wZZtpnBuitdRoOyfNF7eMp8XoSuMam49VLpX2x+rZNLdO7u7N
        lppXtT2ya4yi4653rkuqOQA=
X-Google-Smtp-Source: AA6agR7KffBxnsmdhAzl5K2VkA1GqqmZREMsnrvPeqBxw9ip36x/s+NQ8IUA3GK8g35jdQQSgwKSdg==
X-Received: by 2002:a05:620a:43a1:b0:6cd:4fd9:40d6 with SMTP id a33-20020a05620a43a100b006cd4fd940d6mr10891799qkp.204.1662999930594;
        Mon, 12 Sep 2022 09:25:30 -0700 (PDT)
Received: from [10.69.77.229] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bs34-20020a05620a472200b006ce0733caebsm5691783qkb.14.2022.09.12.09.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 09:25:30 -0700 (PDT)
Message-ID: <4bd8b33b-cb48-9cc7-671b-3b1431af6858@gmail.com>
Date:   Mon, 12 Sep 2022 09:25:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH V2 linux-next] net: dsa: microchip: remove the unneeded
 result variable
Content-Language: en-US
To:     cgel.zte@gmail.com, woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
References: <20220912080740.17542-1-xu.panda@zte.com.cn>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220912080740.17542-1-xu.panda@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2022 1:07 AM, cgel.zte@gmail.com wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Return the value ksz_get_xmii() directly instead of storing it in
> another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

One comment below:

> ---
>   drivers/net/dsa/microchip/ksz9477.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 42d7e4c12459..ab7245b24493 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -884,7 +884,6 @@ void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
> 
>   static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
>   {
> -       phy_interface_t interface;
>          bool gbit;
> 
>          if (dev->info->internal_phy[port])
> @@ -892,9 +891,7 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
> 
>          gbit = ksz_get_gbit(dev, port);


Same logic applies here, you could fold ksz_get_gbit()'s return value 
into the tail call, and once you do that, this begs the question of how 
specific the KSZ9477 implementation has really become..
> 
> -       interface = ksz_get_xmii(dev, port, gbit);
> -
> -       return interface;
> +       return ksz_get_xmii(dev, port, gbit);
>   }
> 
>   static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,

-- 
Florian
