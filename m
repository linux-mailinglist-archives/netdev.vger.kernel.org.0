Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1943957AB9E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbiGTBPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbiGTBO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1467D66AC7;
        Tue, 19 Jul 2022 18:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4F0B61769;
        Wed, 20 Jul 2022 01:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBDBC341CF;
        Wed, 20 Jul 2022 01:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279584;
        bh=vqXj7XcdFd9Log8wvaLARZBQdPJgW9zLErQWSV79MdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K3pSe4msWE2Awk/GAmbgus7yuRnAsXc9l2XCHhoy1nCqgYCa4vukN2Y86rG66baSP
         6vm6+5zguf+tG4L776e+Lb8rpB4/vzd3HgdrcV/8mts5mg+UxMC1tiyVtamBWk/q06
         rsFWmQQLZMoV3FOSaTIY+fzYDU4tNPK2wBy22alnE977cmESn7R1mlboYF2OTCW7yA
         KAjeW3AaKHrbo4E6PcbZM7niAoMit9aOwSm7YL11Qbt4dENe4PZ1eDKaYhjQsQc/wn
         uw/oPI/PbgXUr2aAD0KvBSxdedWioQ6ToAk35vg33KgEXPxqj6TxQgjqGLu6TLHakc
         Yq6I8euJ/dS3w==
Date:   Tue, 19 Jul 2022 18:13:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/5] Add MTU change with stmmac interface
 running
Message-ID: <20220719181302.292961f6@kernel.org>
In-Reply-To: <20220719013219.11843-1-ansuelsmth@gmail.com>
References: <20220719013219.11843-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 03:32:14 +0200 Christian Marangi wrote:
> This series is to permit MTU change while the interface is running.
> Major rework are needed to permit to allocate a new dma conf based on
> the new MTU before applying it. This is to make sure there is enough
> space to allocate all the DMA queue before releasing the stmmac driver.

Other than the kdoc nit, LGTM!
