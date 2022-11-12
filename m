Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0860562671E
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiKLFMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLFMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:12:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61803C6D2;
        Fri, 11 Nov 2022 21:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41899609FE;
        Sat, 12 Nov 2022 05:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522D5C433D6;
        Sat, 12 Nov 2022 05:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229956;
        bh=azx5NLTy1CkkCnDF2S211KHgQ2kIoSnZnC4XVyLlpeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LGhDUR4pTgiWl/sYID9eDpQlo8GwIbY2TA3tWL7cxLw4Aon2IqIxPjWnfPpaYIT7u
         BA4EfDoGlmrv/V1E9WKKSzK6UVQbL4AMq9lOWtHwPjMr0cdG181vXkNhxcg/ak4/Gf
         m5dnsabw6eppQao3X80UUbMLrGCbksRPbVaD3z458sN43zZ8rvZjoAF7kIfSK8Sc76
         SFIPauiLCBA/6W50uQt4nF4OYQX4+ztj3XimNl0tsIHmdj1/ZbsJTJFTtqRO+NAk2o
         hF2KD2glglA4cT6HV/UAvqSI22GMsLQqdAcJlp42CsqwkLfJNMmUs5iAZssJIVwAkX
         dJ3OpLdF2bIjg==
Date:   Fri, 11 Nov 2022 21:12:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/9] CN10KB MAC block support
Message-ID: <20221111211235.2e8f03c0@kernel.org>
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
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

On Sat, 12 Nov 2022 10:01:32 +0530 Hariprasad Kelam wrote:
> The nextgen silicon CN10KB supports new MAC block RPM2
> and has a variable number of LMACS. This series of patches
> defines new mac_ops and configures csrs specific to new
> MAC.
> 
> Defines new mailbox support to Reset LMAC stats, read
> FEC stats and set Physical state such that PF netdev
> can use mailbox support to use the features.
> 
> Extends debugfs support for MAC block to show dropped
> packets by DMAC filters and show FEC stats

I personally see no reason for us to keep merging your AF patches.
Upstream is for working together and there is no synergy between
your code, other drivers and the user APIs we build. Why not just 
keep it out of tree?
