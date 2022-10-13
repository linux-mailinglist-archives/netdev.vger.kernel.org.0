Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11275FD1D0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 02:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiJMAvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 20:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiJMAvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 20:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D89912006B
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 17:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50324616B5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 00:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217F6C43470;
        Thu, 13 Oct 2022 00:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665621908;
        bh=BY6NSNTsGspisONHzJBR5FbCDR3j3NmpXA4EUtKNq7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h39oegE9/yYg4mdGObUEHdbBB1VHfmT4ffOkxp0632dgmwqJ6djgYrneUd2A3PXGz
         26g2y6oXX14aMeuxRKHQ8e4CMl25pwTPXxw5NDPzcSUKgFqxtclUjhH7mLuLGnQNzx
         6HujuDZYXjMKZ/MPfCjW3jowQmo48A6shj66kg0UTCIcKnCc22L9DxNVhHp6pbDCev
         tlhB+KHLLzQe8ldacaT0cqYzx9rx1vzrBfPJ0SoU7v8Uh4CULMYfNwHe7xtZhV0Pbv
         xNeAvgJvmaelU9ZT4hqsqIqloJ/zJ8WhoMKrqwEhwHNt5yZ7OkyZpsnvCz38w/6tC6
         KOnqddIhMD15A==
Date:   Wed, 12 Oct 2022 17:45:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: Re: [PATCH v4 2/2] net: stmmac: Enable mac_managed_pm phylink
 config
Message-ID: <20221012174507.1938d533@kernel.org>
In-Reply-To: <20221010204827.153296-3-shenwei.wang@nxp.com>
References: <20221010204827.153296-1-shenwei.wang@nxp.com>
        <20221010204827.153296-3-shenwei.wang@nxp.com>
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

On Mon, 10 Oct 2022 15:48:27 -0500 Shenwei Wang wrote:
> Enable the mac_managed_pm configuration in the phylink_config
> structure to avoid the kernel warning during system resume.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Could you add a Fixes tag pointing to where the warning first appeared?
