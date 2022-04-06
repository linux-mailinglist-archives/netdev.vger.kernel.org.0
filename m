Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770E64F63B1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiDFPo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiDFPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4124DFA8B;
        Wed,  6 Apr 2022 06:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C62260B90;
        Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4ADBC385A9;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250613;
        bh=gj3LnrzDBuaBA3oZSCTUUn9xPtQQhfhC2uOBuoJ25XA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LuhfRRhRfrFWQ0/fNsOfFJuB3enFBIVG+V18wgMH1txyXomZs3ixmBEy2dPw8S3vW
         i99J0sC/t9h1HBWsZ/RazKLguyNUK9XOgSi6nFGfqQdr7BJgYcyig+2VixvCjoeiY8
         Y0K6pG1NlB72DSlmVKstA4lTv5ZPjixgnpNCo3O2XDeCebFTE0JdxHrlF+9e55yhKH
         nnykBZZPrxO7ANzBsltPvD1N1RQPrfjvU+MC+gUykp3GVBlLSQkjAVCM16NofsWfkS
         N/hb7tBPIcZKPu7DXPK/1EBzakb576kfl4/hoOpJfDwh1T1TdKDVoNsh1OrVvnaJsr
         VTCtcSp18Ux1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89A90E85DB6;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: fix leak of nested actions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061356.5679.9687443822548515643.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:13 +0000
References: <20220404154345.2980792-1-i.maximets@ovn.org>
In-Reply-To: <20220404154345.2980792-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, tgraf@suug.ch,
        stgraber@ubuntu.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  4 Apr 2022 17:43:45 +0200 you wrote:
> While parsing user-provided actions, openvswitch module may dynamically
> allocate memory and store pointers in the internal copy of the actions.
> So this memory has to be freed while destroying the actions.
> 
> Currently there are only two such actions: ct() and set().  However,
> there are many actions that can hold nested lists of actions and
> ovs_nla_free_flow_actions() just jumps over them leaking the memory.
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: fix leak of nested actions
    https://git.kernel.org/netdev/net/c/1f30fb9166d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


