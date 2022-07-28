Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE85837B8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiG1DuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiG1DuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12112636
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3969161A0C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 902F8C433B5;
        Thu, 28 Jul 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658980213;
        bh=5QP06Twei7lrnf8GLQeB0ya1AbCwsTfmI0p/MYvEIMk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cL9VqTi8Hft4weeup+9JyKH65MWMTLh6n84D9TAiKy5aSY/mIx//HlKGX2AFvOsxw
         Bc34WrqKlsR0PD5uHwyqkJCoNL64dyJpEexRCYGKZg/qdhhrZIX6DJKxS+weCGxOVw
         MKQ+CD481pnhNhe7Yho6zztcrzPQ8rstr+Cg59zaADFQ2KyN9PMJdaPecB7tnUiMxz
         2lKDuc2S5/cl34bfERq8qyHKoU0eqiZRuLswL/GhGImmTEBE+NbqIMIGx2oc3EZQjw
         KWgf2C2H9+3YYyWrxp1dF7teZW0dmvH4BU7W+SgXaS8Je8nMrViBu0GRtfnC49XtZU
         Z9pC6k3sop5xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78DC1C43142;
        Thu, 28 Jul 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2022-07-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165898021349.7628.11142880271067915675.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 03:50:13 +0000
References: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 26 Jul 2022 13:46:41 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Przemyslaw corrects accounting for VF VLANs to allow for correct number
> of VLANs for untrusted VF. He also correct issue with checksum offload
> on VXLAN tunnels.
> 
> Ani allows for two VSIs to share the same MAC address.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ice: Fix max VLANs available for VF
    https://git.kernel.org/netdev/net/c/1e308c6fb712
  - [net,2/5] ice: Fix tunnel checksum offload with fragmented traffic
    https://git.kernel.org/netdev/net/c/01658aeeada6
  - [net,3/5] ice: Fix VSIs unable to share unicast MAC
    https://git.kernel.org/netdev/net/c/5c8e3c7ff3e7
  - [net,4/5] ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
    https://git.kernel.org/netdev/net/c/283d736ff7c7
  - [net,5/5] ice: do not setup vlan for loopback VSI
    https://git.kernel.org/netdev/net/c/cc019545a238

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


