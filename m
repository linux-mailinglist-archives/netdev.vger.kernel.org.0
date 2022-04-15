Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00DC5027D3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350335AbiDOKDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352079AbiDOKCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD6AAB56
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861ACB82DD9
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28CC0C385AF;
        Fri, 15 Apr 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650016812;
        bh=X1VxryorkYVlYpCBp7BDPAz7h6LYdTTo6ITbXPoXmTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WNndiuEHQo+5KD8mdDYaJK1l3ymFToDeHTLWIFNPvwGnS9+k52L5QTlhwSq4Whca/
         NdZmY4Dx+6vF4dxolk2mhUgy3nJpwOo+fy7rRjXuAld3cWre6nlGKQQ/CqKBIR1V30
         kDv0sElpz84Gyyc1cJY/IHwdTWgh+vn+Mja3RK/naeplh0VBkZgmdmEBpcY7DdXYfB
         LsnCPc8PkSO45mh9vmdSDkHoUCm68inx5sl9IXKIkj9FccHrzwFFajuM5HU+Mmxxg5
         63pMmv0DIPptLv5Wk5G30uoG8MVRq3tBjPJ45w98DNA3saVy8I8hebFHOD4DyXR/XG
         99U/2Fg+xmmLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13C01E8DBD4;
        Fri, 15 Apr 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] geneve: avoid indirect calls in GRO path,
 when possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001681207.2816.1778533529225108783.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:00:12 +0000
References: <72bc10247a7f5fee36a3ce7da51dfd4c66a52b68.1649839351.git.pabeni@redhat.com>
In-Reply-To: <72bc10247a7f5fee36a3ce7da51dfd4c66a52b68.1649839351.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 10:44:40 +0200 you wrote:
> In the most common setups, the geneve tunnels use an inner
> ethernet encapsulation. In the GRO path, when such condition is
> true, we can call directly the relevant GRO helper and avoid
> a few indirect calls.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] geneve: avoid indirect calls in GRO path, when possible
    https://git.kernel.org/netdev/net-next/c/f623f83ae773

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


