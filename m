Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8008E557F78
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiFWQKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiFWQKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285A1369F7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B556361EDE
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEF0CC3411D;
        Thu, 23 Jun 2022 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656000613;
        bh=VggE9IoVo4Oj/l7TSwFFs7zKh7kv3dkN8LdGFeT3lSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B+CyA45cEgNqU+aTzkFrjY2YEDsZMCMMoiNHHxyEaGyMdG6Q9p5SHGurgjzMgqb8u
         idXiWkOM61z5rPTxqLGrYmX5LcnKSjfrG9fHv04wsEl+AifKy4rQ9oXw6m+ssfWJjr
         WGEv3gYMklruw/8Ja+guhJis0bkCie6mIWROy7lzR8/bw0m1KuTCrESh2sq1jvX67y
         cMUA9IsljQ1WS4HeT9rR5w/qwbLXoC08RpUs+9RUFQwp9gwrryIjLqnVWEFAkrmc1p
         aVfCRS+TROjsxtOjTX3IXIz10vMJrUdBXbuP+AvfhkVaRdJB9FMMNnbu1b7p/w7USw
         1syiAAiTBUe8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D83CCE73856;
        Thu, 23 Jun 2022 16:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool v3] sff-8079/8472: Fix missing sff-8472 output in
 netlink path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165600061288.19760.7637583841273572801.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 16:10:12 +0000
References: <20220616180526.3892055-1-ivecera@redhat.com>
In-Reply-To: <20220616180526.3892055-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, djuarezg@cern.ch,
        idosch@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Thu, 16 Jun 2022 20:05:26 +0200 you wrote:
> Commit 25b64c66f58d ("ethtool: Add netlink handler for
> getmodule (-m)") provided a netlink variant for getmodule
> but also introduced a regression as netlink output is different
> from ioctl output that provides information from A2h page
> via sff8472_show_all().
> 
> To fix this the netlink path should check a presence of A2h page
> by value of bit 6 in byte 92 of page A0h and if it is set then
> get A2h page and call sff8472_show_all().
> 
> [...]

Here is the summary with links:
  - [ethtool,v3] sff-8079/8472: Fix missing sff-8472 output in netlink path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=fb92de62eeb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


