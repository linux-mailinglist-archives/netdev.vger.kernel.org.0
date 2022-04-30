Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53165159A4
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378874AbiD3BrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbiD3BrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:47:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5511BF32B;
        Fri, 29 Apr 2022 18:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9183BB83877;
        Sat, 30 Apr 2022 01:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FCAC385AC;
        Sat, 30 Apr 2022 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283041;
        bh=xw0l58DOPIz+7PGn4jskQGQVzd1XPiy9sknmCETqAkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HuzA6gtwLB2wcO71hqE/+3j9RqD1c2tOJiO4U0pQv17/Ee2cZvrw3G4RHVD9ptfXT
         8lVkAZD4He6HZcm0/GTa7nFYPPBcsOwe3y/TN1CESaporAWdr8LJFqecupqQvHRm9j
         ESUDSZURNiS5vyyF3qxr0dQ0F4RmqiZNsldWGgfwfeL35TW452+P6FySGU3firD6cN
         dMQ837K0gwctilhzFLWDH4eXMygHdTy9c2OqJEgRxXMWZvZSrMeUQ+SAHgpHe2gLZr
         K5+bjjRl0EUc85goyQVRZAbQltnLtnK/0qoszJ8xKtUQbXOkr1HIDJAnCq5ywZptu3
         fAe4XW/sm3s/Q==
Date:   Fri, 29 Apr 2022 18:43:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: dsa: sja1105: simplify the return expression of
 sja1105_cls_flower_stats()
Message-ID: <20220429184359.72b225e1@kernel.org>
In-Reply-To: <20220429055226.3852334-1-chi.minghao@zte.com.cn>
References: <20220429055226.3852334-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 05:52:26 +0000 cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Simplify the return expression.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>  drivers/net/dsa/sja1105/sja1105_flower.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
> index fad5afe3819c..16c93159e475 100644
> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
> @@ -501,7 +501,6 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
>  {
>  	struct sja1105_private *priv = ds->priv;
>  	struct sja1105_rule *rule = sja1105_rule_find(priv, cls->cookie);
> -	int rc;
>  
>  	if (!rule)
>  		return 0;
> @@ -509,12 +508,8 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
>  	if (rule->type != SJA1105_RULE_VL)
>  		return 0;
>  
> -	rc = sja1105_vl_stats(priv, port, rule, &cls->stats,
> +	return sja1105_vl_stats(priv, port, rule, &cls->stats,
>  			      cls->common.extack);

align continuation line

> -	if (rc)
> -		return rc;
> -
> -	return 0;
>  }
>  
>  void sja1105_flower_setup(struct dsa_switch *ds)

