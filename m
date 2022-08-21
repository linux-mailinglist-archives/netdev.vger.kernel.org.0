Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A483559B3EC
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 15:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiHUNcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 09:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiHUNcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 09:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08B20F4D;
        Sun, 21 Aug 2022 06:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F2760EA6;
        Sun, 21 Aug 2022 13:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186A2C433D6;
        Sun, 21 Aug 2022 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661088734;
        bh=H0GmdNmk20EtsSNGnGy+HXstPHaIpbBQGxnEVXHoYg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f9oA1njr8ZF8nTuglN/TLg6w8cg091iR2P/6F2eX8HVDRPfDWE7zIiZj1jvxriQfl
         5CN3qOQRqVh2TxUymWOhqpHzjp6E1z+ji/8t7FkLk47OtSJt4NluhK4Mug57bKND2q
         oK24nXwMQK/AR+TLyI+MVL5+wMeYb/EzpIyYcD0Nc8FU1AombwleXSC1WD/iC/qL76
         x5zts1dVCvk34XxiZPZklap0ADV4bs7a4mUTbVVWJkKCzWD04q7tXXi7MVt3+H5uC0
         yM2eGoEDcyA2K/mAP+bZe7mPHdd7b/agSV2hp0wIp/9fEDeIfGdi3tBBwB1j/PR/5N
         uPQbuqgT1MTmg==
Date:   Sun, 21 Aug 2022 21:32:08 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: ls1028a-qds-65bb: don't use in-band autoneg
 for 2500base-x
Message-ID: <20220821133208.GA149610@dragon>
References: <20220802135006.4184820-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802135006.4184820-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 04:50:06PM +0300, Vladimir Oltean wrote:
> The Lynx PCS integrated with ENETC port 0 does not support in-band
> autoneg for the 2500base-x SERDES protocol, and prints errors from its
> phylink methods. Furthermore, the AQR112 card used for these boards does
> not expect in-band autoneg either. So delete the extraneous property.
> 
> Fixes: e426d63e752b ("arm64: dts: ls1028a-qds: add overlays for various serdes protocols")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
