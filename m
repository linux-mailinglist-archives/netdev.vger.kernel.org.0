Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE664E8FC
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiLPKAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLPKAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC62A4A041
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 02:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7885FB81D3C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 282AAC433F0;
        Fri, 16 Dec 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671184816;
        bh=HGfihhTO6IgGwleikTMcs/NfpbHhHwe2p7Dy2YIM5O8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CKBEjGfu697BUISliBH2utEHQdpIKp2MnTW3gM7Ut0jVAhqlSs4dCfGVDKdV6zdWT
         UTd5sCaEBwqRJ8lSDLDwA2ug7CBmDdhKESxvTKAvVbotzwhTPgrWp3GtGsbYnAIx6Z
         6ZO6DLNZpBKBnoNThVxZEjLSH02WlX6/txJzmh463Jo0SxoaNOwaX0ehOQ5mqMZ9Sx
         yFbajsJzZp3sAaP3wdHII/WWPbjBCUYRGS0/QqwHjvwTn+VXA+c7btgS7gKPlC43ly
         IfQtdHE70Mg5+/lzzie+3Eq9hmKiLWTpVwRsBTBQcjO/OzMwjDnxryDwGntSSl6/PA
         sEPmgwnDkIlyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FC90E21EFC;
        Fri, 16 Dec 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] misc: header includes cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167118481606.3286.1711560402008951575.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Dec 2022 10:00:16 +0000
References: <20221208131348.7B7166045E@lion.mk-sys.cz>
In-Reply-To: <20221208131348.7B7166045E@lion.mk-sys.cz>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
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

On Thu,  8 Dec 2022 14:13:48 +0100 (CET) you wrote:
> An attempt to build with -std=c99 or -std=c11 revealed few problems with
> system header includes.
> 
> - strcasecmp() and strncasecmp() need <strings.h>
> - ioctl() needs <linux/ioctl.h>
> - struct ifreq needs <linux/if.h> (unless _USE_MISC is defined)
> - fileno() needs _POSIX_C_SOURCE
> - strdup() needs _POSIX_C_SOURCE >= _200809L
> - inet_aton() would require _DEFAULT_SOURCE
> 
> [...]

Here is the summary with links:
  - [ethtool] misc: header includes cleanup
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=1fa60003a8b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


