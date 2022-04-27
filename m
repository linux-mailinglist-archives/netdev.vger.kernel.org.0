Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12760512065
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiD0Pdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbiD0Pdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:33:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDF7464523
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QmJgTfR2/ZryGpdnmk0bR2zbK1HXkZOrwQt0gV0mwVI=; b=XEpz3EXYL8zKrjuekWOKmEKO80
        mYXvUnvt+PH6yKj/6Iq9zfwRBNX3i+FSNnqf0ehmqsGbr+c/rCjEHeu77fAE0cQzA90+g14IIrOBA
        UckJjSD5NJHRnhNFgHBL7uldCfu5KoRAyRaAke2z9uWbW5Z/Kkjtk07k9LdwLc1t5hfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njjcP-0008RU-CL; Wed, 27 Apr 2022 17:30:17 +0200
Date:   Wed, 27 Apr 2022 17:30:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [REVIEW REQUEST3 PATCH net-next 1/2] net: phy: microchip: update
 LAN88xx phy ID and phy ID mask.
Message-ID: <YmlhiQpjUMh+awJ2@lunn.ch>
References: <20220427115142.12642-1-yuiko.oshino@microchip.com>
 <20220427115142.12642-2-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427115142.12642-2-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 04:51:41AM -0700, Yuiko Oshino wrote:
> update LAN88xx phy ID and phy ID mask because the existing code conflicts with the LAN8742 phy.
> 
> The current phy IDs on the available hardware.
>         LAN8742 0x0007C130, 0x0007C131
>         LAN88xx 0x0007C132
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/phy/microchip.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
> index 9f1f2b6c97d4..131caf659ed2 100644
> --- a/drivers/net/phy/microchip.c
> +++ b/drivers/net/phy/microchip.c
> @@ -344,8 +344,8 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
>  
>  static struct phy_driver microchip_phy_driver[] = {
>  {
> -	.phy_id		= 0x0007c130,
> -	.phy_id_mask	= 0xfffffff0,
> +	.phy_id		= 0x0007c132,
> +	.phy_id_mask	= 0xfffffff2,

That is a very odd mask. Is that really correct?

Please also look at the patch subject line, it is not correct.

     Andrew
