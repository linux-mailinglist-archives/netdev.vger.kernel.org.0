Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD650855F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377443AbiDTKDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352379AbiDTKDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EEF1ADAA;
        Wed, 20 Apr 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD1861731;
        Wed, 20 Apr 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5201C385A0;
        Wed, 20 Apr 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650448814;
        bh=gz5XYCnVpMEI1KvfPfqvKxfI/QYUIW9H/MW0rMMG75E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E4oOJ6GJSJM9Qg54Fm3JYgKZVKXOc6upQhZ6YolOt3bfSK5dv3cqBhWKuUT4xvLVw
         ITKPLqlD2sa4vHR6wyLIROUa0rPnlfu4xOO2Dw6sOufdp8/jyBVunDrc8UfcM1i9dK
         uopJLsWIWpgE5UBr7jyK0ESlGGfEF7cjhlkb8HEdBFMU0V7BDJfdq2D/7SLoJB392r
         k7v2WtOZUqCQ2w7bUzYqXaQp51ncDj1zduSCwKwV7wrQZThuxRbRvUffRZLK9GHwey
         8/ig6Sgv35RYQ6EpmYLeSTeavqXxyVYrieKTyGdKMJC/U5u8JjlDHsX+VnY2oAfnOs
         6T1cRHilbQ2gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 971CBE7399D;
        Wed, 20 Apr 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/3] net: atlantic: Add XDP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044881461.4054.10110464875115970804.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:00:14 +0000
References: <20220417101247.13544-1-ap420073@gmail.com>
In-Reply-To: <20220417101247.13544-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 17 Apr 2022 10:12:44 +0000 you wrote:
> This patchset is to make atlantic to support multi-buffer XDP.
> 
> The first patch implement control plane of xdp.
> The aq_xdp(), callback of .xdp_bpf is added.
> 
> The second patch implements data plane of xdp.
> XDP_TX, XDP_DROP, and XDP_PASS is supported.
> __aq_ring_xdp_clean() is added to receive and execute xdp program.
> aq_nic_xmit_xdpf() is added to send packet by XDP.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/3] net: atlantic: Implement xdp control plane
    https://git.kernel.org/netdev/net-next/c/0d14657f4083
  - [net-next,v5,2/3] net: atlantic: Implement xdp data plane
    https://git.kernel.org/netdev/net-next/c/26efaef759a1
  - [net-next,v5,3/3] net: atlantic: Implement .ndo_xdp_xmit handler
    https://git.kernel.org/netdev/net-next/c/45638f013a63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


