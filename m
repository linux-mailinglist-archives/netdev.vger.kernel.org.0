Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF5C4C6193
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiB1DNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiB1DNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:13:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A44D424AB;
        Sun, 27 Feb 2022 19:12:57 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d15so6561307pjg.1;
        Sun, 27 Feb 2022 19:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=4rmvg3YrbmeUOYVUvXj6Lw98hGWfdNyA2HEq8oI8Lm8=;
        b=k5V8S+xl5ylAD68N3xJDxG+YYRSoVj1fac5PEaNqf3S2c+kg0z8y9CcRinFxHXes4B
         3mpuNJ/LALO39TluPJmqckIyut3FMoroZ7VKyncESok9NW6m51Mtj+jXXj07BMRun0cw
         2wfd1asBno89GGN8WyIfr9gAc5tJdHUl1T17uO1Aw/DL+mrCB+9KfTaaajGMBFCCLJtB
         xroTr01Hsvqz/0WL1ndIG/rn60yJ5ueGpW5n63Cbqak2uS0UbbLGCIvSdaaTL/LqkXkt
         cna6aL/Ejo9uyRzaAAKFqZ+FZ5NyHcB6QMDQuQhGinlf6ACl/OmIFGKkPoaIN+ajRJIZ
         fznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4rmvg3YrbmeUOYVUvXj6Lw98hGWfdNyA2HEq8oI8Lm8=;
        b=uY8oE9udvOlKgG6/v0R4yRjTHzrQKrfWqlX2IauBY9bGJteByeMTrua6w/c+0z+5sG
         eUgpyztpyl0HmF/W+0SKnttyU/HpRUl9kMcDm0ybmiUgHWOhB7KAjyfAP7q0kKVELegc
         jMr/UVZe6VFT2NoG6PdxGtCl/G6Km5wgbor6/pWpxowhPs5Th/Dyne2JEG1HZK19D7oz
         WwHgdflSxA0BHOeK0jr5hbYno/aOU+kABW3Q6mJpFSYP1WL748OZvKqMAzJLSfxB6HYO
         NW71+fT9o8yFNrWhVwcjFEFR3U9eCy9YkxF6m1Q6f6z4dfbk2eWRZKFi4CRgV97uNeuL
         lOWA==
X-Gm-Message-State: AOAM5303uN9betcwTzucTSfQAXrYX6daEqA8vGVaTxJYsTtN6nKrSpRT
        8zmhpvXliAHYMauUmTdFGyCgqHCV6gQDDA==
X-Google-Smtp-Source: ABdhPJy4wvSoH1Xm8+adqtFj0o+kFKtcYwvtyNa8uPt1ZA+zG8sZwa0asJHz7TLe85X3RuLZZlw4qA==
X-Received: by 2002:a17:90b:d91:b0:1bc:ade1:54e3 with SMTP id bg17-20020a17090b0d9100b001bcade154e3mr14588589pjb.8.1646017976806;
        Sun, 27 Feb 2022 19:12:56 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:d5fb:e6d:f9df:586a? ([2600:8802:b00:4a48:d5fb:e6d:f9df:586a])
        by smtp.gmail.com with ESMTPSA id 17-20020a056a00071100b004f0f941d1e8sm10564338pfl.24.2022.02.27.19.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 19:12:56 -0800 (PST)
Message-ID: <ec4ff2dd-9a13-ac11-8ad5-a76ab98cdf42@gmail.com>
Date:   Sun, 27 Feb 2022 19:12:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [net-next PATCH] net: dsa: qca8k: pack driver struct and improve
 cache use
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220227234804.8838-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220227234804.8838-1-ansuelsmth@gmail.com>
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



On 2/27/2022 15:48, Ansuel Smith wrote:
> Pack qca8k priv and other struct using pahole and set the first priv
> struct entry to mgmt_master and mgmt_eth_data to speedup access.
> While at it also rework pcs struct and move it qca8k_ports_config
> following other configuration set for the cpu ports.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c |  8 ++++----
>   drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
>   2 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index ee0dbf324268..83b11bb71a19 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
>   	case PHY_INTERFACE_MODE_1000BASEX:
>   		switch (port) {
>   		case 0:
> -			pcs = &priv->pcs_port_0.pcs;
> +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
>   			break;
>   
>   		case 6:
> -			pcs = &priv->pcs_port_6.pcs;
> +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
>   			break;
>   		}
>   		break;
> @@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
>   	if (ret)
>   		return ret;
>   
> -	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> -	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
> +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 6);

Should this be QCA8K_CPU_PORT6?
-- 
Florian
