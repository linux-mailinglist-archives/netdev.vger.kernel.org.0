Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A42098763
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfHUW1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:27:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44870 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfHUW1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:27:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so2168075pgl.11;
        Wed, 21 Aug 2019 15:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZilChnAhCatXpj3hCbWl2iTCbaV6v5z9OCb9ZGyTME=;
        b=DGp4cVrEeY7rQ6+8C6gGIHORTkURTGloonDJJy1uj2XzjnAeACnBZ/7vMIYxKsadhL
         lOe20LMhKNKtOj0senMpIC+EiSDtV+IMhSF1bV8SsawU7/PEqlGO0+m+Lucc06osuIRW
         LLtFFyGsVq21DWjeparAgu8AQuyCBsOBshVe35xkwk7SvQ8++q3ulpwc3p5ihiWOLt+s
         xSuuzRlTzWmORKWUCxn64UUmbd9ZTpmjyrWYQ9q5rHJtc4GeWICpYaypgX3ITCg3RL4q
         0dAZs64HBDOehsFB6h+FIZ4VCFCTNxOxTea34WcakRpJiGZnYIANWh2ZDs4ye/G4nQQy
         ttVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UZilChnAhCatXpj3hCbWl2iTCbaV6v5z9OCb9ZGyTME=;
        b=II2BrJgUSjuvl1/2eN4cVapsjvHpS6UUFraI29HACASaJF7oaPFFYaK2Q3gdzBo6i/
         b7HoqigLUkGnp7jun/1XBMGG12Gq7TE2tbPUxRSQOKU2ct/jW38pvND8NCkn+gyRWar0
         Tpp1oE7+YpHNVO2hm5ihix7MaiAkgKkZoFe5rsnakqdXkbFIx66rlUAsQFLdagMY7dhW
         dHpwhjbOKn0xP1CAn7plJ1nzYoiodTDVtDWb4WMDOYM1qgFCbBOkRhexo4Daqo8rXSKf
         61I5xyeqJ2NJu1Br1/6VIKY0yReRswOuGwvAYkwS8faVOKQ+jLMN3aE8nwd/cIGOD7Z8
         h2WA==
X-Gm-Message-State: APjAAAXZyDTwnAC7jk/O5YaVKZTlyDCoVodAMH6EdweIdpRAaO/QtnNA
        kazNxy0VkNpWipAxzb20UB+wQpVn
X-Google-Smtp-Source: APXvYqyptyuC4sorjhVdY1VxoGWIJCPCz6rpSunupR7SvNCcPnEq7B/Nw09uu41u2ZtWjgvQmP4Wgw==
X-Received: by 2002:aa7:81ca:: with SMTP id c10mr38358467pfn.185.1566426451095;
        Wed, 21 Aug 2019 15:27:31 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 143sm26119609pgc.6.2019.08.21.15.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 15:27:30 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: use
 devm_platform_ioremap_resource() to simplify code
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190821134131.57780-1-yuehaibing@huawei.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <fae4a0f8-65c5-76ff-1be7-e7b33c9a5466@gmail.com>
Date:   Wed, 21 Aug 2019 15:27:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190821134131.57780-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 6:41 AM, YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index d3a0b61..2108e59 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3437,7 +3437,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	struct bcmgenet_priv *priv;
>  	struct net_device *dev;
>  	const void *macaddr;
> -	struct resource *r;
>  	unsigned int i;
>  	int err = -EIO;
>  	const char *phy_mode_str;
> @@ -3477,8 +3476,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  		macaddr = pd->mac_address;
>  	}
>  
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	priv->base = devm_ioremap_resource(&pdev->dev, r);
> +	priv->base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(priv->base)) {
>  		err = PTR_ERR(priv->base);
>  		goto err;
> 

Acked-by: Doug Berger <opendmb@gmail.com>
