Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD24B03ED
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiBJDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:30:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiBJDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:30:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A023BD5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 19:30:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so4263540pjm.2
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 19:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=USJZEpWHKpxWW74+xZjMYeip/O4IXiuRf0a3MyMXSzY=;
        b=RS3nNIlIRjF0Y14a0lflALD4n/Unmd/bvWFaP7r9UNrzvXSkWfWU0ymkM0sSam+drk
         gASAUkEaAXUWbpFgvEFfgmnHA/jk1b7c6Rz795+58EtvamJyVLJ4Iex7IGWqOarffX+J
         uv8RjADKJeXPTT3aY6RaEzPg50c1lrsoI9VdZ+8fU9pNVPsaykwmoYeStXcX2OBSUAfP
         2qXA/rtRd6vZf68OerAr+R2iTE+QRrXQEf/zXsMw3p41GuQDdp9/w4UsFxdx5psK+1NK
         K2WkNqExM+L7H4YEGSfwVRRLT9q/Tl0Hl0SMHCD+XrIXR+M+PGnnSEdZW4OcVfRY1wCd
         TagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=USJZEpWHKpxWW74+xZjMYeip/O4IXiuRf0a3MyMXSzY=;
        b=e+6aqC5qo2xATN9YZFor2U6aXfuLDaanYP11oRepB+TE+FN2jz2+jand0BDHPNexqf
         INYHl7snBHMpYiXdN1X0yvDe+x2+EuN50fUjrfcEj6LnxX2vP20TjP1FLUyofsOl5rhk
         zB9HSHvBhWfJwLqE06utWQKsPtnrcDg1noZPH0T/FPZMuA84MYHBIvLLCN1OMrMlZU6K
         TxOwrCJoQQQrGu0FKy7WgaXZnt7UGWdgBTZrm9gWiKCUhTL5aMmqJ6Ahyi/87wO97DQz
         BpzZ2wL71Z593Jxqde+jXcMMs4S2hnp5/Z3QJrm5ZdUKEr/boRYbyhiajU5i8fkfoLNY
         UOTw==
X-Gm-Message-State: AOAM530Kw7CugdUsjcaY5oynwqzd+MKwdGgq0KMxGeTmgm68GsBof4rV
        uz1MbhOxfdRAl3N9WntPnCo=
X-Google-Smtp-Source: ABdhPJzn3YnQDlUeuDS+tIC5FIkE/Vqa7jxbwCRB/mtKHfskpBMEiznCu/x5e+o0HXj+GNluUNwLbw==
X-Received: by 2002:a17:902:a708:: with SMTP id w8mr5449013plq.101.1644463821443;
        Wed, 09 Feb 2022 19:30:21 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g7sm3538257pfi.7.2022.02.09.19.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 19:30:20 -0800 (PST)
Message-ID: <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
Date:   Wed, 9 Feb 2022 19:30:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with
 realtek-mdio
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20220209224538.9028-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220209224538.9028-1-luizluca@gmail.com>
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



On 2/9/2022 2:45 PM, Luiz Angelo Daros de Luca wrote:
> realtek-smi creates a custom ds->slave_mii_bus and uses a mdio
> device-tree subnode to associates the interrupt-controller to each port.
> However, with realtek-mdio, ds->slave_mii_bus is created and configured
> by the switch with no device-tree settings. With no interruptions, the
> switch falls back to polling the port status.
> 
> This patch adds a new ds_ops->port_setup() to configure each phy_device
> interruption. It is only used by realtek-mdio but it could probably be
> used by realtek-smi as well, removing the need for a mdio subnode in the
> realtek device-tree node.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   drivers/net/dsa/realtek/rtl8365mb.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index 2ed592147c20..45afe57a5d31 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -1053,6 +1053,23 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
>   	}
>   }
>   
> +static int rtl8365mb_port_setup(struct dsa_switch *ds, int port)
> +{
> +	struct realtek_priv *priv = ds->priv;
> +	struct phy_device *phydev;
> +
> +	if (priv->irqdomain && ds->slave_mii_bus->irq[port] == PHY_POLL) {
> +		phydev = mdiobus_get_phy(ds->slave_mii_bus, port);

This assumes a 1:1 mapping between the port number and its PHY address 
on the internal MDIO bus, is that always true?

It seems to me like we are resisting as much as possible the creating of 
the MDIO bus using of_mdiobus_register() and that seems to be forcing 
you to jump through hoops to get your per-port PHY interrupts mapped.

Maybe this needs to be re-considered and you should just create that 
internal MDIO bus without the help of the DSA framework and reap the 
benefits? We could also change the DSA framework's way of creating the 
MDIO bus so as to be OF-aware.
-- 
Florian
