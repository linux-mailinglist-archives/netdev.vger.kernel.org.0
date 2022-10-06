Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C945F657E
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiJFMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJFMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93F2F00C
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F81618DB
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F340C433D7;
        Thu,  6 Oct 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665057615;
        bh=OxG+cjkmfP/U+gY6e+RrGNnZUfnPDuNsElYjUe5HnG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YP3LlEG+W25ImzqKZApamO/44KD1PP2rleookXSzRQXiAGgrsUnVOuZaI9HK5rSmA
         h9vr6xCP60Sp7+vq0uMMhRTpOIaFaRE8k/f5LvDr46n2hMF5dyBX+EfWruTFvLDwdo
         yN8Vd2/e9LWZbaUvCEArchZkHy4xNlHKAM3a+sp6upa1OXTxS3fwr2Y7J01SiLqmxo
         O5F/2cJjEoP8bDeKGP0YpA49MA3A+UZmE/1fboCScGeG+OCXzIGBJiusM/cWVjS5yK
         mr6+bsZN41dNbIjSEND95YjDz+vOwb2HpyaRWs0xlLzw5NujLKHU7zaPuHueXggQpN
         qaRWrFnxM0BVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FDC7E2A05E;
        Thu,  6 Oct 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next] netlink: settings: Enable link modes
 advertisement according to lanes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166505761506.29403.2888535388205745221.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 12:00:15 +0000
References: <20220914072547.4070658-1-idosch@nvidia.com>
In-Reply-To: <20220914072547.4070658-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed, 14 Sep 2022 10:25:47 +0300 you wrote:
> When user space does not pass link modes to advertise (via
> 'ETHTOOL_A_LINKMODES_OURS'), but enables auto-negotiation (via
> 'ETHTOOL_A_LINKMODES_AUTONEG'), the kernel will instruct the underlying
> device driver to advertise link modes according to passed speed (via
> 'ETHTOOL_A_LINKMODES_SPEED'), duplex (via 'ETHTOOL_A_LINKMODES_DUPLEX')
> or lanes (via 'ETHTOOL_A_LINKMODES_LANES').
> 
> [...]

Here is the summary with links:
  - [ethtool-next] netlink: settings: Enable link modes advertisement according to lanes
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=174e2b8fc95f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


