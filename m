Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729946E7989
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjDSMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjDSMUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D708F7EC3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5826A63E73
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD50EC433A1;
        Wed, 19 Apr 2023 12:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906819;
        bh=/lC+BJZGtH+4ue31e7C2oYaqqgbyIQ4VEJIKYDQKBXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=byab/Yue8s4j/8+5q2PiH2D0iUmOYpArrr+U2fqRxpnodgnFcjo7+d5ksCRYUSsos
         gyQQXOuyWb7q1EKrbPY5yZholO0S4Tc3Brvtm0AxcE6FhB5hTuNWYkOnbL68Eb+8vU
         HX7gMVcgP2g4owYRQwVtj6crLBAqAI3d3JXFQQjn4rUZ5eyTGgFfRqfJrP/mypBiDF
         qgk0bFWeJAMtDr4M8a7O12UUTqh6flgsLdl9ygR08Jr31ryMlXprq5RiG99ho4ZEn/
         DrxR13Oo/jXsK/fziPZ5ia4xhC+Jo1ZMt1PhqpzaoARNEwfMEPtDiBYYHvQrxVtBY4
         xSpsvnqnG39FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98AA7E270E5;
        Wed, 19 Apr 2023 12:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: fix changing mac address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168190681962.14108.4570041852711196628.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 12:20:19 +0000
References: <20230417192903.590077-1-vinschen@redhat.com>
In-Reply-To: <20230417192903.590077-1-vinschen@redhat.com>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 21:29:03 +0200 you wrote:
> Without the IFF_LIVE_ADDR_CHANGE flag being set, the network code
> disallows changing the mac address while the interface is UP.
> 
> Consequences are, for instance, that the interface can't be used
> in a failover bond.
> 
> Add the missing flag to net_device priv_flags.
> 
> [...]

Here is the summary with links:
  - [net-next] stmmac: fix changing mac address
    https://git.kernel.org/netdev/net-next/c/4e1951666248

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


