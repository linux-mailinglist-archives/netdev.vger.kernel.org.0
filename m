Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E91598A52
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbiHRRWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343766AbiHRRVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE586570;
        Thu, 18 Aug 2022 10:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C6FAB82305;
        Thu, 18 Aug 2022 17:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F875C433D6;
        Thu, 18 Aug 2022 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660843232;
        bh=EXNuPGYk5JyIPmHakPo7fo+5V311YmG09WDtES+EREg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jTXuot/kf+sZsttKzZZJ5b71mGqt3hh6B+SlVMAtpPxmGld0u3bYrMvfjqDWwOhNC
         XVuBSXA5tMCbYeXx7v16OWB9kuU4IWn0H5rDodcULaVGCRR2z2bRIGP2d/gY8I+V6i
         ABXIyh9vYJUCkk3zEU5eEcL+3soiNNYXJrpTbWmteyyJaQzYQrRsJyZg+vcgJ1HeYn
         nP9qL8ZheensvzT0pLmAcYHuEQWRAQ7aON/vHoI5x4Bo9eld3lq4QbHG+YkQHStkeS
         YX3QswabGngKZNuEM+/Cj9Dl+2VlG5MemBsKWmXGM7YQP1f8/nw55gUWw+xCV5VJgZ
         vgRUot5GgoriQ==
Date:   Thu, 18 Aug 2022 10:20:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] stmmac: intel: Add a missing
 clk_disable_unprepare() call in intel_eth_pci_remove()
Message-ID: <20220818102031.5be300f5@kernel.org>
In-Reply-To: <d7c8c1dadf40df3a7c9e643f76ffadd0ccc1ad1b.1660659689.git.christophe.jaillet@wanadoo.fr>
References: <d7c8c1dadf40df3a7c9e643f76ffadd0ccc1ad1b.1660659689.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 16:23:57 +0200 Christophe JAILLET wrote:
> Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
> paths") removed this clk_disable_unprepare()
> 
> This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
> handling on remove path") which removed this clk_disable_unprepare()
> because:

I'll take patch 1 in now, please repost patch two in a few hours
after Linus pull net (or just tomorrow if you don't wanna try 
to track it down).

Please avoid posting fixes and cleanups in a single series.
They go via different trees.
