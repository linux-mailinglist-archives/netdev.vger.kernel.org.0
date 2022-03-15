Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801364DA333
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343728AbiCOTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCOTV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:21:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C4839BA6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B887B81898
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 19:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FC6BC340F4;
        Tue, 15 Mar 2022 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647372011;
        bh=lvnIeUvVZe+n2DYrTtkZETBaCVBBayuTGdorU39gO38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQgqZFGQqbc++l7jWexaGi6/C5obA8zKI5otQT/q3Mh766B5jh5hJaDn1rFHr2Ij1
         fWA05RvEHWBAPTPUN9+TsvQV8ZjK6ymaWzLzZ9u/GKG1gdD75JyGDbl3RzQn+ez378
         zdvrlkz50YE64eUfamKdx+pTq0eVyL8sTfLLBuUzkdfgjzGViYqa1l9FewQbjw51uL
         oZLPST3wl8XGN9vDsDC+zcbswRs2EH+w8V3Ib+3CniLv9mbd+hs5GGbakgZdQBn15J
         Hc+OldFtEXki/yboePDdB4GWQMHHbag2jZX7qxBXT3yOW88fbXt/NDIs9wx/XSovOs
         0iaZdyNppcR8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F363E6D44B;
        Tue, 15 Mar 2022 19:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Add Paolo Abeni to networking maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164737201112.25309.5783001055134034064.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 19:20:11 +0000
References: <20220314222819.958428-1-kuba@kernel.org>
In-Reply-To: <20220314222819.958428-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Mar 2022 15:28:19 -0700 you wrote:
> Growing the network maintainers team from 2 to 3.
> Welcome Paolo! :)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] Add Paolo Abeni to networking maintainers
    https://git.kernel.org/netdev/net/c/e9c14b59ea2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


