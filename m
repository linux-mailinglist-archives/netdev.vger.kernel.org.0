Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F139B686F9B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBAUSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjBAUSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:18:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995931E1C;
        Wed,  1 Feb 2023 12:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AB5A61941;
        Wed,  1 Feb 2023 20:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBE2C433EF;
        Wed,  1 Feb 2023 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675282714;
        bh=k5hlpssnceOv6leu+3BSWwGAdnOuEHqHMa1y3/y/MXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FmzwLCpMnaiwKKNwG8zhL8SDfAurVnET+cLa9u5xlI5tFai72TsYIB1Wr2zleWBLD
         8Ik3mlpfOyRETWPaZXVlboV6w9Q8durlRSPE7kMClFiAdJPCl19YxXu3aCGodkBm81
         HPAspzVdwDfkeT7mOf4GuMmgH9IHM1r2y1PZFwWtszxXpgjYGLHjkFBYvOuGRDO4DD
         cvpcq4lUU4SN/0AKWgdDlGkNwT3/A9ZAii+iQw53CYlucQQb6pDY0flnCoLbpJUvwm
         W0ZB5yGn5uJhvf/kRpHQz4UoH3JlN3BXiTdZZ22gVBqEBNcm0DFZBLV7GvqhL741WX
         EGYLQ16etS74A==
Date:   Wed, 1 Feb 2023 12:18:32 -0800
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
Subject: Re: [PATCH net-next v4 05/23] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <20230201121832.109f751b@kernel.org>
In-Reply-To: <20230201145845.2312060-6-o.rempel@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
        <20230201145845.2312060-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Feb 2023 15:58:27 +0100 Oleksij Rempel wrote:
> +/**
> + * genphy_c45_write_eee_adv - write advertised EEE link modes
> + * @phydev: target phy_device struct
> + */
> +int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)

nit: most functions added by this patch are missing kdoc for second
argument
