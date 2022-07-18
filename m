Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464EC577F86
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiGRKUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiGRKUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B3E1CB0E;
        Mon, 18 Jul 2022 03:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A767B8109E;
        Mon, 18 Jul 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CD87C341CE;
        Mon, 18 Jul 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658139613;
        bh=E6qUE/0FVI0925eqyIBrCUBMqK+zwWphena0m6VhbnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OXZHYC+qEMDbyEcHGefefVFx5QQEh19SO3NL1NUvgctLhdghYRDVb9FY035wu/N+O
         6u6vYyd+HGT+B4XfoPk0KftlyAiu7yvGfNYsGoaFFVUJoi0UujqsNPMXSgy8cv1l63
         8uxlKTvqrjlgx5v5I4amneLgPlkvK2rrxgqG/cUulwCxCDZVjfYTx5FevIm7bprTs4
         w4LjLt3jiGqRXAjK1pwEfSQcC/gjsiqFNtHl2bIAIK3avwbb7PnS0TMyX6f2oIKXEX
         dpT2g+hYqJAD6zl+WgvR/xX42fSQGIstkL2sNApHO04H1X9iO36z2WzNTqiQHk7rYL
         +yvHBh5D2/5Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01866E451AD;
        Mon, 18 Jul 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: stmmac: switch to use interrupt for hw
 crosstimestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165813961300.9736.8038169452034701746.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:20:13 +0000
References: <20220714075428.1060984-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20220714075428.1060984-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Jul 2022 15:54:27 +0800 you wrote:
> Using current implementation of polling mode, there is high chances we
> will hit into timeout error when running phc2sys. Hence, update the
> implementation of hardware crosstimestamping to use the MAC interrupt
> service routine instead of polling for TSIS bit in the MAC Timestamp
> Interrupt Status register to be set.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [1/1] net: stmmac: switch to use interrupt for hw crosstimestamping
    https://git.kernel.org/netdev/net/c/76c16d3e1944

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


