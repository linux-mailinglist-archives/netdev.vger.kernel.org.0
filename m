Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F946D401F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjDCJUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCJUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CED35B3;
        Mon,  3 Apr 2023 02:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABEC6172C;
        Mon,  3 Apr 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60981C4339B;
        Mon,  3 Apr 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513619;
        bh=Qt8L7MjiwJQiXBTxow1ccQ1aDq6eJcp3DjM1wm2z2Ks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q3Hgzs/vDI1UKap+8cvCnsLPnBxyQ+Kl+kh9TPNyo03dA610jmlXeWzF2NZHg3Gjw
         fEp4Wv0GNBSotCEdHCPZTAjEmZZAkCRkHT+6GXk4fA0GavcW+zFSfrqRJFE1FbwIBF
         dR3oYOb2blqzfZVWnQMzAZgUYmxFJDJn9ODSuzFNnoHLOtTxT007YlYHocvc4eyflu
         R9TUIBcJCS9LYGoUITxT2Wtbeo54z2DlwN//FUUhZIcBoMyVhlpP7z1PLN9t9BR+SD
         tLp6ePHKkLJanJEJa2izU2z2Nw1J8CXPr4V5opW6fnBgJjDXn+uhh/LiEqR2B6Cf6f
         6VjJ6oPj6/4Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44DF7E5EA84;
        Mon,  3 Apr 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051361927.15794.7255447263665412994.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:20:19 +0000
References: <1680505131-11645-1-git-send-email-quic_srichara@quicinc.com>
In-Reply-To: <1680505131-11645-1-git-send-email-quic_srichara@quicinc.com>
To:     Sricharan Ramabadhran <quic_srichara@quicinc.com>
Cc:     mani@kernel.org, manivannan.sadhasivam@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 3 Apr 2023 12:28:51 +0530 you wrote:
> On the remote side, when QRTR socket is removed, af_qrtr will call
> qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
> including local NS. NS upon receiving the DEL_CLIENT packet, will remove
> the lookups associated with the node:port and broadcasts the DEL_SERVER
> packet.
> 
> But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
> would've already deleted the server belonging to that port. So when the
> remote's NS again broadcasts the DEL_SERVER for that port, it throws below
> error message on the host:
> 
> [...]

Here is the summary with links:
  - [V3] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
    https://git.kernel.org/netdev/net/c/839349d13905

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


