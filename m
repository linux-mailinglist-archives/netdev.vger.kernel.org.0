Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D847656514E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiGDJuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiGDJuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293712ADC
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD083B80E7F
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EE4BC341CF;
        Mon,  4 Jul 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656928214;
        bh=83zdl8WMEk2uujjtLz9uhLHK4V533Rr6S3HC4/P0DIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJ7yDURWMErPgclgku6z9i30oIa3EyIpGFz4e31vkbi8g04bnj1H4a8Dxi+RQ+qAC
         mQ110DQPsgVC01XKQ6ykhjcxq/HgrCZBFQ7G07mTc8+6+n8Qdv0dLLYvq/OZ9Xq6Lg
         sl+ItWPuxXrAx6PvbY8H74IPWfByB8KlNXOpzrSaHcdWhPMYBL2Z6PJbhzrhqSle+A
         AHzs54JOD+/G+MZYfjCHj2lc+VVjNLXTjKCeQP3T2OKMlBHRLe6xPEM7m11cQ7uXC+
         XtPQgoM0YaObQ/i6In5IkCqg3/mx9wYIXG6jOqjePzjY6p6592+/A4AAnLnhGbaonJ
         lmBj1r+/dRDiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60A79E45BDA;
        Mon,  4 Jul 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] nfp: support VLAN strip and insert
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692821439.21895.7548578566974182708.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:50:14 +0000
References: <20220702073551.610012-1-simon.horman@corigine.com>
In-Reply-To: <20220702073551.610012-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        na.wang@corigine.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  2 Jul 2022 09:35:49 +0200 you wrote:
> Hi,
> 
> this series adds support to the NFP driver for HW offload of both:
> 
> * RX VLAN ctag/stag strip
> * TX VLAN ctag insert
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] nfp: support RX VLAN ctag/stag strip
    https://git.kernel.org/netdev/net-next/c/67d2656b48f1
  - [net-next,2/2] nfp: support TX VLAN ctag insert
    https://git.kernel.org/netdev/net-next/c/d80702ff1257

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


