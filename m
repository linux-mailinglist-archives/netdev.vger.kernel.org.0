Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35A524C87
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353591AbiELMTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353588AbiELMTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:19:18 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D14D2469FB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:19:17 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 0484A100AFDA6;
        Thu, 12 May 2022 14:19:16 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D2A482E6CC9; Thu, 12 May 2022 14:19:15 +0200 (CEST)
Date:   Thu, 12 May 2022 14:19:15 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 7/7] net: phy: smsc: Cope with hot-removal in
 interrupt handler
Message-ID: <20220512121915.GE4703@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <4a90661372af73e056f7b243df9c039945715a3b.1652343655.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a90661372af73e056f7b243df9c039945715a3b.1652343655.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:42:07AM +0200, Lukas Wunner wrote:
> If reading the Interrupt Source Flag register fails with -ENODEV, then
> the PHY has been hot-removed and the correct response is to bail out
> instead of throwing a WARN splat and attempting to suspend the PHY.
> The PHY should be stopped in due course anyway as the kernel
> asynchronously tears down the device.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Andrew kindly provided this tag here:
https://lore.kernel.org/netdev/YnGsKQC1WxihasYs@lunn.ch/

Forgot to add it to the commit.
Sending it in separately so patchwork picks it up.
My apologies for the inconvenience.
