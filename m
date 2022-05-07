Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3522951E3E2
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 05:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbiEGEBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 00:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiEGEBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 00:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5498758E49
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 20:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3F4B8399F
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 03:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E9C385A5;
        Sat,  7 May 2022 03:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651895871;
        bh=yBcYF2B4vAuY+lPmaAvwfuJUvcJf9C4J1Dir3tjmuFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hn0ZETlw8cuV63sF20c+23YmgzG6bjtFDt6w/FDIt/DgwpDQnBde8PxsPWkj0c1NH
         3ncjC5uxqw3Dck/Hq3+hTrkvn5DJAInFkPoaRRG4wL1qSTeY2zfMr7x07KLZKoK4zg
         mziQSsJ/FH33Iy7hAv48hMRONF5jKDrf2+53xitv6UKc9oZv4NnlIRPoWfDi5YiK6W
         TAPy9Z6eqy61ZFN/5ozCPipkI/aIAqISybymu614ecO6GnNv/ATRTcnpJM0B1PLfQ3
         ylbyQfp71v9hRx1QI3Go0B8l7IAObpLk30LhEqO4igROAVfFL6/3MXb0FkCXWRC7dN
         HEfBEA5RUphaQ==
Date:   Fri, 6 May 2022 20:57:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, lasse@timebeat.app,
        clk@fb.com
Subject: Re: [PATCH net-next v4 1/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220506205749.2b89ee57@kernel.org>
In-Reply-To: <20220506224210.1425817-2-jonathan.lemon@gmail.com>
References: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
        <20220506224210.1425817-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 15:42:09 -0700 Jonathan Lemon wrote:
> +struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)

The prototype for probe and init needs to get added in patch 1:

drivers/net/phy/bcm-phy-ptp.c:803:6: warning: no previous prototype for function 'bcm_ptp_config_init' [-Wmissing-prototypes]
void bcm_ptp_config_init(struct phy_device *phydev)
     ^
drivers/net/phy/bcm-phy-ptp.c:839:25: warning: no previous prototype for function 'bcm_ptp_probe' [-Wmissing-prototypes]
struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
                        ^
