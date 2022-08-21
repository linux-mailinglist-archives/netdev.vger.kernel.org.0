Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E58459B14F
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 04:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiHUCcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 22:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiHUCck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 22:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4092D1FCE7;
        Sat, 20 Aug 2022 19:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA57B60BFE;
        Sun, 21 Aug 2022 02:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6018C433D6;
        Sun, 21 Aug 2022 02:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661049159;
        bh=rgCNTbbC5mtg1yWshzaw6YA+HDwf0e5bR61wdwD0DEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JCUPb0RnEN4rtkypc7jUKJhSchiLx2bB/2xTNJ+MShOJIG8dHRwFTY8GC6WTcMy29
         dtgQ4hQbPc3OQhrWq8DlXjKApewcvI71ZDCZYRhiT5APP9B/kaqktRO+U40FxW4QpZ
         EsvdDK11TARVxZJovb5zvfZKUkZdt6M/g4j5jBtISYR33spGA7KjESpPozlbElpMm3
         vhbqmw+3cwP5UUkgUsDh//iTVfxNEthKFABvxR1qzBrg/cahDuQ6yqANdnjyqz/atL
         FPBS21jZg8DZpK0Xod7HVtV95OIrDGk4sAbNoqGe4fYBBErvOi3DZqQlXMRV+/tPoI
         R1tN4KaKF9t4g==
Date:   Sun, 21 Aug 2022 10:32:30 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V4 2/3] arm64: dts: imx8ulp: Add the fec support
Message-ID: <20220821023230.GH149610@dragon>
References: <20220726143853.23709-1-wei.fang@nxp.com>
 <20220726143853.23709-3-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726143853.23709-3-wei.fang@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 12:38:52AM +1000, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add the fec support on i.MX8ULP platforms.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Applied, thanks!
