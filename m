Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2541E24FF04
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHXNfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgHXNfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:35:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54449C061573;
        Mon, 24 Aug 2020 06:35:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id d11so11729408ejt.13;
        Mon, 24 Aug 2020 06:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qBlPQKIK+Sf7xnyBmBOxFqnfqkDGJ7ZbBkjJFcCppis=;
        b=myGAulX+pUpcUtuzXi8/ExHy7RBGxysvvhPJAYGx1lH5EEqh9Cnme9j3kPo5dMV6h2
         /bwQ7L37JAHRCg5FrBZ1t1bJICI7yIpgMcUO1QcPtYSZitZjpbTS3McvwiD4IuX8YhGn
         OweCm0GoVCaAQKXr25YzIi9fmNAHU9tJRGivXBDxXAg6VYiMRpAS+MVDTH1/9DgAyfSO
         5UcyeaVNjlPc4GlTR4FIQqb6SV69PN+kMACyCYLf7iE8wtWkwWe4eSaBcVoMtamqbQ/7
         533jc/8Cn+gkrWqb/C4B3oZtt6M57HKQKhc+YiZyUT/4vAX/XWFqH/GOvy9YW6Uo+20Y
         sMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qBlPQKIK+Sf7xnyBmBOxFqnfqkDGJ7ZbBkjJFcCppis=;
        b=TaEVN8zDfn0Jp2e48XX3egAoT+C6X8nB3RUqYLpnS6BqmYvMeot0sznftmZ4+VgsWG
         ysjYg7MqghIA/ixWCIBYzfeEtnxx15NneJlY3HPAMt03F2vAG1kYjMLL3rDhM3orTlDF
         wr5lPwq5PA3tQhUgyQMhT9F20lp+mh05UtZBYaicWXbIHt2+StT5l4mGwE4WkKXgAWqb
         rOSEzNPqbZTeFPcxPeBZn0JASbPvU/sM6a7i/jeagUzaeRBBOUfk+szx33WsWKp6QS6J
         kxmKhs6v6goQl56kianjZyRid3R8r8bORrQmKpdiNVNS0b6Ry3b0na/7enIsYiDlJjQC
         I2gQ==
X-Gm-Message-State: AOAM532OJFoznYsnOcvEFy5OvNNO6PHq+Fa95aZitxlJbfnE9vcBgkks
        Otb0gaonumGgzNY81pE3JHE=
X-Google-Smtp-Source: ABdhPJy65pU8bdTG9sbTEPvCuA2gIvTWDt31MWk9H33q/YltEelKWAmDpJ8s5mvLZNd5HPHZsDgBzw==
X-Received: by 2002:a17:906:359b:: with SMTP id o27mr5890797ejb.103.1598276117958;
        Mon, 24 Aug 2020 06:35:17 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id ay5sm9590726edb.2.2020.08.24.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 06:35:17 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:35:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sumera Priyadarsini <sylphrenadin@gmail.com>
Cc:     davem@davemloft.net, Julia.Lawall@lip6.fr, andrew@lunn.ch,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: dsa: Add of_node_put() before break and return
 statements
Message-ID: <20200824133515.j6ujfm2tl2hqjo5u@skbuf>
References: <20200823193054.29336-1-sylphrenadin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823193054.29336-1-sylphrenadin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 01:00:54AM +0530, Sumera Priyadarsini wrote:
> Every iteration of for_each_child_of_node() decrements
> the reference count of the previous node, however when control
> is transferred from the middle of the loop, as in the case of
> a return or break or goto, there is no decrement thus ultimately
> resulting in a memory leak.
> 
> Fix a potential memory leak in mt7530.c by inserting of_node_put()
> before the break and return statements.
> 
> Issue found with Coccinelle.
> 
> ---
> Changes in v2:
> 	Add another of_node_put() in for_each_child_of_node() as pointed
> out by Andrew.
> 
> Changes in v3:
> 	- Correct syntax errors
> 	- Modify commit message
> 
> ---
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
> ---

If you need to resend anyway, can we please have a proper commit prefix?
A patch on mt7530.c shouldn't be "net: dsa: " but "net: dsa: mt7530: "
as "git log" will tell you. The difference is relevant because "net:
dsa: " typically refers to the generic code in net/dsa/.

>  drivers/net/dsa/mt7530.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 8dcb8a49ab67..4b4701c69fe1 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1326,14 +1326,17 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  			if (phy_node->parent == priv->dev->of_node->parent) {
>  				ret = of_get_phy_mode(mac_np, &interface);
> -				if (ret && ret != -ENODEV)
> +				if (ret && ret != -ENODEV) {
> +					of_node_put(mac_np);
>  					return ret;
> +				}
>  				id = of_mdio_parse_addr(ds->dev, phy_node);
>  				if (id == 0)
>  					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
>  				if (id == 4)
>  					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
>  			}
> +			of_node_put(mac_np);
>  			of_node_put(phy_node);
>  			break;
>  		}
> -- 
> 2.17.1
> 

Thanks,
-Vladimir
