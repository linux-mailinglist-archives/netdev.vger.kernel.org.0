Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714594B2DF0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352977AbiBKToy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:44:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBKTox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:44:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2E813A
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s/jHQ2g/cXmj2a9q1rCQGBe/wruS5wxXGhUaNHMlyRM=; b=kF7OmOBEz4ZCRSs6pSgWc/KiqZ
        7jyTd6qOIF3ghySVPuGbnxAnWBDJ+kcMQFP//yVMZNb2dtAbzBlGJtAjUPhwvynvFSmPTlWO8nd0/
        SMhn40MOZugpvwQNhH85uPi8fYWLI9X3UbP/RFzPOx753iDnohGjz1resUuD7DOpZukg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIbqa-005VwB-Vm; Fri, 11 Feb 2022 20:44:48 +0100
Date:   Fri, 11 Feb 2022 20:44:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before
 setup
Message-ID: <Yga8sFBosiRpfofp@lunn.ch>
References: <20220211051403.3952-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211051403.3952-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
> index ed5abf6cb3d6..e7d3e1bcf8b8 100644
> --- a/drivers/net/dsa/realtek/realtek.h
> +++ b/drivers/net/dsa/realtek/realtek.h
> @@ -5,14 +5,17 @@
>   * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt.org>
>   */
>  
> -#ifndef _REALTEK_SMI_H
> -#define _REALTEK_SMI_H
> +#ifndef _REALTEK_H
> +#define _REALTEK_H
  
 
> -#endif /*  _REALTEK_SMI_H */
> +#endif /*  _REALTEK_H */

These two hunks should probably be in a separate patch.  At minimum,
please mention it is in the commit message.

       Andrew
