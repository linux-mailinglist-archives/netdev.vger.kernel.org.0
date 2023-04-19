Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEB6E726D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDSEuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjDSEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3606F5FCB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C61F363B02
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20AF8C4339C;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681879818;
        bh=3vODOfvgBN2oDXiK8ngoThtsDygGFFlVrTLMiAFXwZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aODpWp2sj5wsDvvpM9BwhhpMvhFlm84SxVkwcBWUm2djPo/JHvBTHpuPdhTawEW/g
         xsfLu+yt1iIZuBkTMrn873YRRcwjqY5F276VgZC3stM1TReCfQDkQs+7xAgYIi1Az/
         RujHY4RIHvRmY1uj6IBj8S6TPyVDEXU93blxq6WGLTjXniIFgutup20vMC5o9BJ+Zp
         weeTTqoN4zRH2u7GIu6k72eJZQujMsXBNQrkudUHIiLEVrw79QJvwRd4acPtl8zSTV
         huGUOoqbpKK3KobeJgAYhlJfJGccnlBJyf9uORSI5yITqNI+PXekd7vo7MVaOYBnwh
         gHaKm8Vne9m9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0807EE3309C;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: stmmac: propagate feature flags to vlan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168187981802.31004.10264768603245180857.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 04:50:18 +0000
References: <20230417192845.590034-1-vinschen@redhat.com>
In-Reply-To: <20230417192845.590034-1-vinschen@redhat.com>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com, kuba@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 21:28:45 +0200 you wrote:
> stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> like offloading don't correspond with the general features and it's not
> possible to manipulate features via ethtool -K to affect VLANs.
> 
> Propagate feature flags to vlan features.  Drop TSO feature because
> it does not work on VLANs yet.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: stmmac: propagate feature flags to vlan
    https://git.kernel.org/netdev/net-next/c/6b2c6e4a938f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


