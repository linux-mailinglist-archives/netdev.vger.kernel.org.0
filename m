Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF449B1DA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356128AbiAYKaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352036AbiAYKY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:24:59 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C80C0613DE;
        Tue, 25 Jan 2022 02:24:57 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o12so12377814lfg.12;
        Tue, 25 Jan 2022 02:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=9BG2GS4zinb7Ow72+Oc/dISNMPxbcJYV6aq+uT4bdK0=;
        b=blXz03GfcmGHo8II4aBz3Obb+udMVXJzDsGHCznCs3ZCPSRdsakcLuHbROuo1SK4GA
         SuXp367kkdb+yMu6eMKCScOGPafKSq7CceAdgCuWq4Z9277qMxceJIsKDWqdCnEeorOQ
         2H586I5mrrK0vzkFrABPRkeuSP05P/Mxk78zi4kU332uYNcRyimOmgvh3U8qZPuATc2u
         wotd5ayJVrV4m4JwUXMBQmzghcPyxWohRchMtcyMFfqsbrqG5W8oyNdqChZaKL74vaJ4
         R8Rq7IKtOJObQbMyc75nKQ7G8ifhQ7oRUW1+iDyp2F8m8XhDxejtXj7I4Ey8gwZNE2Zz
         8jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9BG2GS4zinb7Ow72+Oc/dISNMPxbcJYV6aq+uT4bdK0=;
        b=77cjDJNEEdlVogKHi1EOMv6cojVoMq8fGIIgKp2gooIOdPskKRMTMdDdYdwzI42b0/
         992uEKGlnLkv4XJZHRjiEgF1tRiiQaN21gZtznJFCdvhiTwdnfjuOiqiQxFXUy1r0Law
         pZ1clusueWgd0eOFGS49NJAan0R9bNDlkzz4SP5LQ78ZiLaAzstbLkpFvoeI6p393B9W
         ip/koMgpOpH9RHgJz19ggee7uh2kWz7cRu6Txy/lKb/rulrBhcHpMt6s0st+bQKLChBH
         QtTa4/qnWmpoK/gJBGy1EoeWIVOWARoVgyBMVXfLW6nNQYj4pZghiayMWfornrncgVya
         COgQ==
X-Gm-Message-State: AOAM530SsJHC5PniHhu/JFzwdtRW9fDONtxZKyNG3UWlLpskclGiKz4i
        vqUiv3qTpfyWKxFhkVH7liw=
X-Google-Smtp-Source: ABdhPJy/dzbGa69dT6Zgyw2xUBM0PDpzJjNBd9JiVGSa3Rrdvss02918Vl59SsYkbxguJc/zayyU1A==
X-Received: by 2002:a05:6512:39c1:: with SMTP id k1mr15660735lfu.207.1643106295329;
        Tue, 25 Jan 2022 02:24:55 -0800 (PST)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id k10sm451341lfv.258.2022.01.25.02.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 02:24:54 -0800 (PST)
Message-ID: <0d9a0ce5-ab34-cf05-158e-e25fc5595b4d@gmail.com>
Date:   Tue, 25 Jan 2022 11:24:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 5/8] net: add helper eth_addr_add()
To:     Michael Walle <michael@walle.cc>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-6-michael@walle.cc>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20211228142549.1275412-6-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.12.2021 15:25, Michael Walle wrote:
> Add a helper to add an offset to a ethernet address. This comes in handy
> if you have a base ethernet address for multiple interfaces.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   include/linux/etherdevice.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 2ad71cc90b37..9d621dc85290 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -486,6 +486,20 @@ static inline void eth_addr_inc(u8 *addr)
>   	u64_to_ether_addr(u, addr);
>   }
>   
> +/**
> + * eth_addr_add() - Add (or subtract) and offset to/from the given MAC address.
> + *
> + * @offset: Offset to add.
> + * @addr: Pointer to a six-byte array containing Ethernet address to increment.
> + */
> +static inline void eth_addr_add(u8 *addr, long offset)
> +{
> +	u64 u = ether_addr_to_u64(addr);
> +
> +	u += offset;
> +	u64_to_ether_addr(u, addr);
> +}

Please check eth_hw_addr_gen() which contains identical code +
eth_hw_addr_set().

You should probably make eth_hw_addr_gen() use your new function as a
helper.
