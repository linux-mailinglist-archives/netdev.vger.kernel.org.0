Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D86194CE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKDKua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiKDKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1668B2BB12
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E74B82CE5
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B894C433D7;
        Fri,  4 Nov 2022 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559017;
        bh=OXBR5okQyIvIr+mc6X9cpo+XFjFmuCTxCj28E9x9tGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aNlt+lJF4CPeP3AGCBzgISgy9CMUKifR9EukNnkOdt/x7U4COocvf1qxXZYu1BX9x
         zqYa0Ea5VbaKVC5VL+yPIe8eJgw26/L9cMnw+Q9cHd+xRvP4D+ioJN7mu8wRNRujUn
         DtZo8R1eyfx4G3nJIzlsG045TpAI+0TaE475pnXnUYkxVUXCGAJqAtdfQx2XsE7KkI
         alEjAk+jbn+ePzF8lpOztM5doPnHbWSRjPNQrJl88Rm5DIq3ODHrNr2RL/J0UQXiH/
         UQaxX0sbt0Acs2IOf+jmD5fcL/UGjfPJhoCSIyxg/f3/jXiYN/bXbfmuoaDXyYLJhF
         rCrqfvHORtCnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B354E270F6;
        Fri,  4 Nov 2022 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/5] macsec: offload-related fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755901730.6249.17723300193454709704.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:50:17 +0000
References: <cover.1667204360.git.sd@queasysnail.net>
In-Reply-To: <cover.1667204360.git.sd@queasysnail.net>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, atenart@kernel.org,
        mstarovoitov@marvell.com, irusskikh@marvell.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Nov 2022 22:33:11 +0100 you wrote:
> I'm working on a dummy offload for macsec on netdevsim. It just has a
> small SecY and RXSC table so I can trigger failures easily on the
> ndo_* side. It has exposed a couple of issues.
> 
> The first patch is a revert of commit c850240b6c41 ("net: macsec:
> report real_dev features when HW offloading is enabled"). That commit
> tried to improve the performance of macsec offload by taking advantage
> of some of the NIC's features, but in doing so, broke macsec offload
> when the lower device supports both macsec and ipsec offload, as the
> ipsec offload feature flags were copied from the real device. Since
> the macsec device doesn't provide xdo_* ops, the XFRM core rejects the
> registration of the new macsec device in xfrm_api_check.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/5] Revert "net: macsec: report real_dev features when HW offloading is enabled"
    https://git.kernel.org/netdev/net/c/8bcd560ae878
  - [net,v3,2/5] macsec: delete new rxsc when offload fails
    https://git.kernel.org/netdev/net/c/93a30947821c
  - [net,v3,3/5] macsec: fix secy->n_rx_sc accounting
    https://git.kernel.org/netdev/net/c/73a4b31c9d11
  - [net,v3,4/5] macsec: fix detection of RXSCs when toggling offloading
    https://git.kernel.org/netdev/net/c/80df4706357a
  - [net,v3,5/5] macsec: clear encryption keys from the stack after setting up offload
    https://git.kernel.org/netdev/net/c/aaab73f8fba4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


