Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C8033C40E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhCORYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbhCORY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:24:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8D4C06174A;
        Mon, 15 Mar 2021 10:24:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z5so15657326plg.3;
        Mon, 15 Mar 2021 10:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VGVO96aCMAokqb+CmQUJx88bFFEwmRrdQpRPy2MC9U8=;
        b=KlFMF1DxBYZB/cgWm095jTbHO2rcjptuQhC1+ZswbgDTjt0tIro4KUM8M7Pf5oUN6b
         W03X120QqhC1jP6t6bvE69dhNB5IipFzFh074VnZv4mlYfb+AKXv1/qY7HQKYrLaf+N0
         BmvLU9492wcL0q10FELZXfgBTVVcPm6TkKeT5NwEqFXKwqWBGvYAIxDODwSHeO5o1xXj
         jKPtPaURsxIPmF/fZNNTQ07nxVzZ7DNblBbjlF/TjSsA6CJ7+8SqJPG+hvleds1obHRB
         g5wKMxPfR/eU9wsqEuASh0p/PhZ2fdyawuTwKuQbhbJOB9Xo6IsMmnxJ9k+F71gfg7EX
         enpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VGVO96aCMAokqb+CmQUJx88bFFEwmRrdQpRPy2MC9U8=;
        b=kknjjV/nSxZQAHmn+4ItfQVuviM/q87YRjI7YgTDNFijsWsPzf07Lanop3twZeLR0T
         lk3MxKWrdRKLhE0bl1td7t2OHMOGfZx7rj5L3Konqnl3d2zRYL8pqjhgIN6AWuC2BIP5
         z7HFn3NHF6HLxA458D3tynUrSat7ORvgU9iIM0EREocxrpa4rqXy0PX+/dLj23SSg/oe
         spkuewkvPstFx/krDZjDxEi77oaw8vbgqRBQ5ttpeGltN8s4cS4GXDFdKw853afvXerv
         VL6Y37VFvw1cuslAdIUhhNLgf5/4lHJIwv1vXK0+2ZU1CKhiHoPpmDnnewnlcGJ2z5Pq
         lBCg==
X-Gm-Message-State: AOAM530I4ucNWA2cPWkaY+uCg1vShtgpeBVoFjXdw8eXyMBO5NCW+dyY
        dflfUnCb4oBkwRxjIu0mhTrKTeGwGhA=
X-Google-Smtp-Source: ABdhPJy5RGsyyfHffKlPkBh6yINJ3NBac7uYUYyT1tCb1H8Z13lqftGw9o2FZ6oP36gUIjN8AnhhGA==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr165984pjt.30.1615829067794;
        Mon, 15 Mar 2021 10:24:27 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14sm245711pji.22.2021.03.15.10.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:24:27 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: dsa: b53: support legacy tags
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210315142736.7232-1-noltari@gmail.com>
 <20210315142736.7232-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5cf40558-eee8-d92d-4740-d0a88eb64fd7@gmail.com>
Date:   Mon, 15 Mar 2021 10:24:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315142736.7232-3-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 7:27 AM, Álvaro Fernández Rojas wrote:
> These tags are used on BCM5325, BCM5365 and BCM63xx switches.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/Kconfig      | 1 +
>  drivers/net/dsa/b53/b53_common.c | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
> index f9891a81c808..90b525160b71 100644
> --- a/drivers/net/dsa/b53/Kconfig
> +++ b/drivers/net/dsa/b53/Kconfig
> @@ -3,6 +3,7 @@ menuconfig B53
>  	tristate "Broadcom BCM53xx managed switch support"
>  	depends on NET_DSA
>  	select NET_DSA_TAG_BRCM
> +	select NET_DSA_TAG_BRCM_LEGACY
>  	select NET_DSA_TAG_BRCM_PREPEND
>  	help
>  	  This driver adds support for Broadcom managed switch chips. It supports
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index a162499bcafc..a583948cdf4f 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -2034,6 +2034,7 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
>  
>  	switch (tag_protocol) {
>  	case DSA_TAG_PROTO_BRCM:
> +	case DSA_TAG_PROTO_BRCM_LEGACY:
>  	case DSA_TAG_PROTO_BRCM_PREPEND:

I am not sure about that one, so for now we can probably be
conservative. You can definitively not "stack" two or more switches that
are configured with DSA_TAG_PROTO_BRCM because the first switch
receiving the Broadcom tag will terminate it locally and not pass it up.
The legacy Broadcom tag however is different and has a "Scr Dev ID"
field which is intended to support cascading. Whether that works with
only DSA_TAG_PROTO_BRCM_LEGACY or across DSA_PROTO_BRCM_LEGACY +
DSA_TAG_PROTO_BRCM may be something you will have to determine.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
