Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B472D4B62C3
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiBOFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:30:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiBOFaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9A812858D
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 21:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4407961456
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A13DAC340FC;
        Tue, 15 Feb 2022 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644903009;
        bh=2z7QZ9VMuwP8dAmZTri9tb0gCoWquryOI3mEJomEzBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vdb0W1Z+590LvqeTeE6yz5g/NkmZ9yeUYMLR3rd061FeXJ4Mgq6Nq+sso6zIHaXBo
         eKUEulGUvV85yOyBcH9zpBJQownU0ABJZMFxEbdlebYdm+WJJebHlmwFkYKNIaloGn
         iYxRWwNYNDw7yvfj99YrgL6BmvinvefGq1hKPw0zc7ei2uAq2BNPxI/uyVdCNi6XpI
         PU2IkDR0ShjFrLRnRM49HkBMOskwF1c1Zu6FGvDmEy1pg6CmZ7gaxpQCegBVE7spgI
         V5yu4rdWc/K7aV0/EyETe63L0SJQeSmvgHYQ/eKujxygDbIAit9lmI+ogaO9jUnshL
         1roEy95YgaSzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AF6CE6D447;
        Tue, 15 Feb 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: fix wrong publisher node address in link publications
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164490300956.28678.14688275132424958290.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 05:30:09 +0000
References: <20220214013852.2803940-1-jmaloy@redhat.com>
In-Reply-To: <20220214013852.2803940-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 13 Feb 2022 20:38:52 -0500 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> When a link comes up we add its presence to the name table to make it
> possible for users to subscribe for link up/down events. However, after
> a previous call signature change the binding is wrongly published with
> the peer node as publishing node, instead of the own node as it should
> be. This has the effect that the command 'tipc name table show' will
> list the link binding (service type 2) with node scope and a peer node
> as originator, something that obviously is impossible.
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix wrong publisher node address in link publications
    https://git.kernel.org/netdev/net/c/032062f363b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


