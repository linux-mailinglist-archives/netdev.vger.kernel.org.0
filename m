Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A05622E23
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 15:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKIOmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 09:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiKIOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 09:41:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F08A30A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 06:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FTcfHuyYoh551JGIrA5f2XuAs3eq8/LlB4a/Ckk2dEE=; b=UsmMY/bK7gHm8vFKoNqQFBkLR7
        o/LjHPoHqpuhunFWBrqWS7aI+X2cCVs9CoBQwL99VLzwadvTuGnn7TNvzasW4ZxlckbNTzLeFCszy
        1rUD48NV3w5K1OCE6kzkD+o+GGo2hk38qgW69vP5B4I3BDwEnmg7Hjre2gp8mPF6ULVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osmH0-001vFU-73; Wed, 09 Nov 2022 15:41:50 +0100
Date:   Wed, 9 Nov 2022 15:41:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo.dureghello@timesys.com>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: enable set_policy
Message-ID: <Y2u8LijNoA1BuXLw@lunn.ch>
References: <20221109113521.240054-1-angelo.dureghello@timesys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109113521.240054-1-angelo.dureghello@timesys.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 12:35:21PM +0100, Angelo Dureghello wrote:
> Enabling set_policy capability for mv88e6321.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 2479be3a1e35..78648c80dbc3 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -5075,6 +5075,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
>  	.port_sync_link = mv88e6xxx_port_sync_link,
>  	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
>  	.port_tag_remap = mv88e6095_port_tag_remap,
> +	.port_set_policy = mv88e6352_port_set_policy,
>  	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
>  	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
>  	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,

The mv88e6321 is part of the MV88E6XXX_FAMILY_6320. If this is valid
for the mv88e6321, it should also be valid for mv88e6320. Please add
it there as well.

   Thanks
	Andrew
