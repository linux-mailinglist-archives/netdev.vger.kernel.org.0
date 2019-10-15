Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6ABD7EFB
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389135AbfJOS1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:27:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35796 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfJOS1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:27:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so13024206pfw.2;
        Tue, 15 Oct 2019 11:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H2SFc+eSh25LItu8hgIZM6RQdRwB86HeZLQqVHf/9pI=;
        b=RJGM+lNxvChm4N6e6agEvyTnJl9pFJiHhYUl62y4z/ZYAiLUIRsIvCqIS2kqyGC78Z
         WeLhghMqIpgBHjYAPeb88Jvx9F+Bq/L1W8/Q7oO+x4CvckDc44ZCHdaEm+Zp+Ghehnh/
         4mM706LdBje3Ze5JMwb6FyNp9uNe13kb6bDPcfW8cxyjtb6uW9zYZ6qXPN7NSOCeY/W1
         ElONiCKJm/TsHeagRtcfEt0bDcWM8hiCf/QEmyd07TV3IeL9BQRdVA+FzABHzOc9uhGB
         8sGtjIvRHfCm/iKoWmsTfO7t3yc1pTDnmSEfoH8HGNiziJiloK6+u4dppuVRuVO8TeFp
         zmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H2SFc+eSh25LItu8hgIZM6RQdRwB86HeZLQqVHf/9pI=;
        b=F/0ggztLtHdOvhgJ+4RWTzjW0Y1pd/aT6PuzZp4MYrk04jYq2kfPKm4l/vqDkhqapP
         Lq3P0qvY4UtWXcb6+bMx95iDFeBa4eEq2/TxeIAdnlKKgB3s9eiQn/yd7uo8oN12WmFH
         amb9blfqZYR04Ee27gbx9Ho/lCuckvcAtzDYDKJZ71Nrt3pkhWWQG5jFZwnOo0xnm6Ar
         EZssyLqooWZ1LsT6aIAe0/6S0VsOJc3nlHYU5AaR/wxQCsrmXkOR1NckuKlkMDm7xAn5
         6skWsAHu9bbiwntKGCGS1mINWDYNel6ysYQ6+md7nghgFZIpcoQbVPk3LFfYqtQ/ShYR
         QdQQ==
X-Gm-Message-State: APjAAAX7K1+aLAqcKpPq83QC1sPX1+OpW7KutYYPUo2HLZ5EBZGL0aRY
        OiCKRu9B6oNm9laiRNjHB29WWDN4
X-Google-Smtp-Source: APXvYqzs9weFptN+l9IyOAyWJSIJclhY9iV0zVqLy+NdSKFp0MxRMasYFNEBL15v7t02dCJMndXoZg==
X-Received: by 2002:a17:90a:b285:: with SMTP id c5mr43646209pjr.123.1571164053316;
        Tue, 15 Oct 2019 11:27:33 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 202sm29764643pfu.161.2019.10.15.11.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 11:27:32 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: Fix RGMII_MODE_EN value for GENET
 v1/2/3
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191015174547.9837-1-f.fainelli@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <0fd67300-7f23-0181-f3b3-8ee61c15ea39@gmail.com>
Date:   Tue, 15 Oct 2019 11:27:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015174547.9837-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/19 10:45 AM, Florian Fainelli wrote:
> The RGMII_MODE_EN bit value was 0 for GENET versions 1 through 3, and
> became 6 for GENET v4 and above, account for that difference.
> 
> Fixes: aa09677cba42 ("net: bcmgenet: add MDIO routines")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h | 1 +
>  drivers/net/ethernet/broadcom/genet/bcmmii.c   | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> index 4a8fc03d82fd..dbc69d8fa05f 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> @@ -366,6 +366,7 @@ struct bcmgenet_mib_counters {
>  #define  EXT_PWR_DOWN_PHY_EN		(1 << 20)
>  
>  #define EXT_RGMII_OOB_CTRL		0x0C
> +#define  RGMII_MODE_EN_V123		(1 << 0)
>  #define  RGMII_LINK			(1 << 4)
>  #define  OOB_DISABLE			(1 << 5)
>  #define  RGMII_MODE_EN			(1 << 6)
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index 94d1dd5d56bf..e7c291bf4ed1 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -258,7 +258,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
>  	 */
>  	if (priv->ext_phy) {
>  		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
> -		reg |= RGMII_MODE_EN | id_mode_dis;
> +		reg |= id_mode_dis;
> +		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
> +			reg |= RGMII_MODE_EN_V123;
> +		else
> +			reg |= RGMII_MODE_EN;
>  		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
>  	}
>  
> 

Acked-by: Doug Berger <opendmb@gmail.com>
