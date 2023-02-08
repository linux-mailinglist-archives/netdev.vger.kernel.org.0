Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB068E76D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBHFUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBHFUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:20:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB9D29E17;
        Tue,  7 Feb 2023 21:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 059E1B81B3B;
        Wed,  8 Feb 2023 05:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE06C433D2;
        Wed,  8 Feb 2023 05:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675833648;
        bh=EjnIKJiLB9mu2nodQDuvohBF0YXCOxy1sDEVidpNDPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gGFB2n0Dc+uqzmaKwRfjLJM0GwsFqRL8S+cjFX5SQvk+t1sXeFIzDONAXecwcV3QJ
         0yKenRlIE4wgaeEt15dQZQub6apRu3LEPPmPt4HCo5EoZvpPwqb+AvFjgvd/ytvqlb
         +dzS4Sey+//wrl6YiAsIOxfr7YWUvcO5nI5W5xDDSeCHQqF8aYTi/Od+Qn6+LknR5p
         pSf8oHDeQuJzv4wlY4Bh1QbQSQ7MAQ2IZDoqK2ouxk5LYbOVO8LG87RXIjW0lpsa8U
         gSn3YO5yKLWLoo2uItqvU9VgGtquhGES1gC+MFSt3imDQ+hEQCyzAGrDMQN+saWXsw
         EKjJuH2lRH+yw==
Date:   Tue, 7 Feb 2023 21:20:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 15/23] net: phy: add phy_has_smarteee()
 helper
Message-ID: <20230207212047.6080c16c@kernel.org>
In-Reply-To: <20230206135050.3237952-16-o.rempel@pengutronix.de>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
        <20230206135050.3237952-16-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Feb 2023 14:50:42 +0100 Oleksij Rempel wrote:
> +/**
> + * phy_has_rxtstamp - Tests whether a PHY supports SmartEEE.

Function name needs to be updated

> + * @phydev: the phy_device struct
> + */
> +static inline bool phy_has_smarteee(struct phy_device *phydev)
> +{
> +	return phydev && phydev->drv && !!(phydev->drv->flags & PHY_SMART_EEE);
> +}
