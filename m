Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77B063AAC1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiK1OUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiK1OUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:20:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31255220D1;
        Mon, 28 Nov 2022 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e71ZAFHMl2XIYLbnaTyuUQR1myYIA6aRQJsAdadr1PM=; b=ewAQHuoGyQV3d0BVbYIWAXlt5M
        076M0VCLRgLJ2wK9gNT1Ejr2tANBtOSp00+P4xskmT4D2ck3tQ263TdBD7QPaWxmE1M3X5aXXVBpL
        nuoLj1Hob+xcgJcIJX7j27PuqH8pPie0BhvggEMov1NZTwbtF9WZjJ2dMBrA/UOLP7SM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozezT-003f6v-8x; Mon, 28 Nov 2022 15:20:11 +0100
Date:   Mon, 28 Nov 2022 15:20:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Message-ID: <Y4TDmwWKI1H5kNmV@lunn.ch>
References: <20221128090542.1628896-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128090542.1628896-1-vadym.kochan@plvision.eu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 11:05:42AM +0200, Vadym Kochan wrote:
> From: Taras Chornyi <tchornyi@marvell.com>
> 
> Put Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.
> 
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61fe86968111..3da743bb5072 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12366,7 +12366,7 @@ F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
>  F:	drivers/net/ethernet/marvell/octeontx2/af/
>  
>  MARVELL PRESTERA ETHERNET SWITCH DRIVER
> -M:	Taras Chornyi <tchornyi@marvell.com>
> +M:	Elad Nachman <enachman@marvell.com>

Looking at the git history, i find one patch:

commit ab188e8f4aad9845589ed050bde9514550a23ea5
Author: Elad Nachman <eladv6@gmail.com>
Date:   Fri Jun 15 09:57:39 2018 +0300

    stmmac: added support for 802.1ad vlan stripping

So i would suggest you just removing Taras Chornyi. Once Elad Nachman
has built up a reputation of being a Maintainer, submitted patches,
making comments on other patches, we can add the entry.

       Andrew
