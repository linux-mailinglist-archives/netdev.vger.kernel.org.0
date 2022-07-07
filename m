Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1228569E55
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiGGJNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiGGJNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:13:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549FA27B05;
        Thu,  7 Jul 2022 02:13:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v12so9695426edc.10;
        Thu, 07 Jul 2022 02:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x+63eUrjXUS+FoLmYUnXUsHGEfQ+CC/XntxoPecjWQY=;
        b=MZSl682fLdY5iXGZZoTOwJ/2sZL5DCelmQ9ACkQCf9eXeXxmEo7j93wyWmcpKINfRu
         XbyS9U9t9bE/kGVT/NBlYlFkJf6CpCkWo68pTY5j3dgWwzW564NCmsbX4ULon0D5WuW1
         tRaZMZ1EPnxbAnVxCbPgAzX2cEoSXt2/eiR240jY2pIryUebGuEgTS94+SKf4HPTgbLP
         mguGaQtE+T0ounVqFWMK/CV6RA6M7hNqipiSLxPyyIcM31pxmvANtkBWaXt6JBWlafrS
         s+e8ZeyjS19IBk9l7YgDh5u6CnfgyogFltZwFJBpKhbRYLa953ItBdO39iUzn3Lg5fTx
         JrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x+63eUrjXUS+FoLmYUnXUsHGEfQ+CC/XntxoPecjWQY=;
        b=sacVKz/oDnsyX6hcAy4FUbZVqJ6psdQhPJZaHJ4mswtSgwVbtLaATETxp8wyqb1bLb
         5cWUay5c30ylnDsUqwNgaceflG9Gpcc5IBAALGwMq+ljCyAohu20bmmILU93ArcYGah7
         K/P0StM5nV4cPdGtGKEKRlSCVb4Uv1COOzr1xw/44Sce2IPwLL54F74KUZjC880MvkNi
         qeznJf7m3nmY/AXbVdmz+A+/VClHiPMrbJI1PuHcJjKTmoui990eoS91mW8KhUhpukvM
         oVDJm4HQ1bTLxORwzeP/dGBwRFudTKEND/cz/ba5e2wZz9+B59xICXpDYQbDT/VNmDBD
         5uGQ==
X-Gm-Message-State: AJIora8Hn3gX8Qcj73dLAAZkTw0oRXlr4euwbqNVaISio+BZJBv+3Zm+
        JHHzQH1s2xdpPOsp3j/xZUw=
X-Google-Smtp-Source: AGRyM1tYBw5UwvRzB1BekPXgl8hXIyXb25xvzrpMxlE3LhiqtZQ/kkB01z6WGG45sSJVN4TuEjaKwA==
X-Received: by 2002:a05:6402:34c5:b0:43a:8f90:e643 with SMTP id w5-20020a05640234c500b0043a8f90e643mr8925308edc.88.1657185183791;
        Thu, 07 Jul 2022 02:13:03 -0700 (PDT)
Received: from debian64.daheim (pd9e295da.dip0.t-ipconnect.de. [217.226.149.218])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090630c700b0072aebed5937sm3385767ejb.221.2022.07.07.02.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 02:13:03 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1o9NZH-00084J-0W;
        Thu, 07 Jul 2022 11:13:03 +0200
Message-ID: <1e1c7c7e-ef86-e4c9-92cc-f28bf6ec6b8a@gmail.com>
Date:   Thu, 7 Jul 2022 11:13:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RESEND] [PATCH] p54: Use the bitmap API to allocate bitmaps
Content-Language: de-DE
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm sending this again because Android added HTML. Sorry for that.

On 04/07/2022 15:02, Christophe JAILLET wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/intersil/p54/fwio.c | 6 ++----
>   drivers/net/wireless/intersil/p54/main.c | 2 +-
>   2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index bece14e4ff0d..b52cce38115d 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -173,10 +173,8 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   		 * keeping a extra list for uploaded keys.
>   		 */
>   
> -		priv->used_rxkeys = kcalloc(BITS_TO_LONGS(priv->rx_keycache_size),
> -					    sizeof(long),
> -					    GFP_KERNEL);
> -
> +		priv->used_rxkeys = bitmap_zalloc(priv->rx_keycache_size,
> +						  GFP_KERNEL);
>   		if (!priv->used_rxkeys)
>   			return -ENOMEM;
>   	}
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index 115be1f3f33d..c1e1711382a7 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -830,7 +830,7 @@ void p54_free_common(struct ieee80211_hw *dev)
>   	kfree(priv->output_limit);
>   	kfree(priv->curve_data);
>   	kfree(priv->rssi_db);
> -	kfree(priv->used_rxkeys);
> +	bitmap_free(priv->used_rxkeys);
>   	kfree(priv->survey);
>   	priv->iq_autocal = NULL;
>   	priv->output_limit = NULL;

