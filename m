Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F2F55710F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377871AbiFWCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 22:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiFWCaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 22:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF78B4198E;
        Wed, 22 Jun 2022 19:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85EE2B8216E;
        Thu, 23 Jun 2022 02:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47AC6C3411B;
        Thu, 23 Jun 2022 02:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655951413;
        bh=Mr16VGghY3lS0mwcEOWhZcRgP3wH2puvK0LfnmJrP/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BihhnJa8mJtMr9AOMWvtHwhMZHBKVy+2R1on9sJ5iV0VW9yhqoDxfBe1uonerO4cX
         CjapOaopuEkrxuGvktrLkik5ml/N1HbwMgs+E1aVCDBEemGw83OG/fzmlBAUu07/7J
         rJla2UM7nD7mdb9MyzV8f6V8RftEuTnv6qbStbsjq5OIlZpI/rVJsn2nv8sJRcs7wS
         dtSckvfDBPg4yJebg91HtSP1Oyu7elsQ4iWjBiEh8oucYlN53b6elilUEkNZjAaffN
         6FRoLXRsHcAHR9ZkhIEMe598qPtBgH9ljti69HPkaXT7uN2lMDOc1EN/9/gYeqiAgz
         BcemioKlNFd9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C126E7386C;
        Thu, 23 Jun 2022 02:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] test_bpf: fix incorrect netdev features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165595141317.16984.12687463185092076632.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 02:30:13 +0000
References: <20220622135002.8263-1-shenjian15@huawei.com>
In-Reply-To: <20220622135002.8263-1-shenjian15@huawei.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     daniel@iogearbox.net, shmulik@metanetworks.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
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

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 22 Jun 2022 21:50:02 +0800 you wrote:
> The prototype of .features is netdev_features_t, it should use
> NETIF_F_LLTX and NETIF_F_HW_VLAN_STAG_TX, not NETIF_F_LLTX_BIT
> and NETIF_F_HW_VLAN_STAG_TX_BIT.
> 
> Fixes: cf204a718357 ("test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test")
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] test_bpf: fix incorrect netdev features
    https://git.kernel.org/bpf/bpf-next/c/9676feccacdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


