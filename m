Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F34589633
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiHDCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiHDCkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628021A3BA
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 19:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 161DDB823B4
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C028DC433B5;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659580814;
        bh=Gn/UFA2c9poi8BuxmFfYh/qQ94nSbp1MbRMBI9le80o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OZtzELPWHHRuao/vtVf9fAnT7JfPvOhnxFPDpsVyNVQAkOwCKE6aKUF/qBaX68FSZ
         QafLhwuOeUaD72WTRNxcvS4iLCe9NbgtbHfeKSnDBuLNYmfS9WrqWky0yI9rTUA2Yw
         eVBSe2OaY48za+302M1ejm9Om19SAW4dskV3pozkEViOQ0cMN2KJ7hHIqQ0AL+HO2A
         e2n6Qh5THbreYrCiReDk7uEeJttRsRlmRDrO+3P8OzcsyvzLjyzDdMvACU5O9yzWLS
         QyNqENv4oLp+P1v0gJyU900fijZj76qWVPFejVJs1OXsHooiG0i/2w8Bj5EFCGW32/
         KEhnjIjd0rpuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A18F2C43143;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] nfp: ethtool: fix the display error of `ethtool -m
 DEVNAME`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165958081465.15999.7525913027521660058.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Aug 2022 02:40:14 +0000
References: <20220802093355.69065-1-simon.horman@corigine.com>
In-Reply-To: <20220802093355.69065-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  2 Aug 2022 10:33:55 +0100 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> The port flag isn't set to `NFP_PORT_CHANGED` when using
> `ethtool -m DEVNAME` before, so the port state (e.g. interface)
> cannot be updated. Therefore, it caused that `ethtool -m DEVNAME`
> sometimes cannot read the correct information.
> 
> [...]

Here is the summary with links:
  - [v2,net] nfp: ethtool: fix the display error of `ethtool -m DEVNAME`
    https://git.kernel.org/netdev/net/c/4ae97cae07e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


