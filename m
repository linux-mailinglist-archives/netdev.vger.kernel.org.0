Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDF059CF85
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbiHWDbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239797AbiHWDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B16F5C9D7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F37FBB81A96
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A2FFC433B5;
        Tue, 23 Aug 2022 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661225416;
        bh=/7TBM2Ow78NEqA5/XAm5iQam6BA9UfZF6N8zr2Z24D8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ebUw3iC5T31wL71Fy2HpzjToLI8iqaUmIQVhcmZjNY0MYmhexFQ2f/uRm+6/KQ6vj
         78KoZu2GrHCVl1Yk8JeHdq8pKOlxF+bijGH2wHnlae++zQvHffIIYGhlrv8WKNRRp9
         J+6KuwdmgLijcvwvlYnmDqsOc5qa6+ZNOkqAioS0bIUMtpz+GeqhoCcGDMsNqWYw3J
         onzIfoVnd05dztp7/HLVcsZfU1468APGQejoqtWd1dLAmpk8HuaSpVvAPdJSlnRjNF
         2ARlRS4C6w5fnhEw7OGsLW+HkuwVuvKXTVXcKY2rzY3wtGVxyZ+ET8teJqV+YRoFZl
         t88/BYmHs/7tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EEEDC04E59;
        Tue, 23 Aug 2022 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver Updates
 2022-08-18 (ixgbe)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166122541651.23241.4907877931835123588.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 03:30:16 +0000
References: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 18 Aug 2022 15:34:00 -0700 you wrote:
> This series contains updates to ixgbe driver only.
> 
> Fabio M. De Francesco replaces kmap() call to page_address() for
> rx_buffer->page().
> 
> Jeff Daly adds a manual AN-37 restart to help resolve issues with some link
> partners.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC
    https://git.kernel.org/netdev/net-next/c/03f51719df03
  - [net-next,2/2] ixgbe: Manual AN-37 for troublesome link partners for X550 SFI
    https://git.kernel.org/netdev/net-next/c/565736048bd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


