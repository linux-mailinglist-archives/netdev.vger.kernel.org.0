Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2C648CF6
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLJDu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLJDuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:50:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F23B9D8
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B2E262352
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 03:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68D0AC433F0;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670644221;
        bh=kC7lselYHmUTSvpxusDD510XN2F1Em6OLmg1AzaXicI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Of+La4u1jqmM1KVuZbuWfhPsGJq9O5VejBuT0VtyJ5zvcBL5kV05m1so8fyVhb0db
         ZttGhW2IkWnyvlvrxQ0Wey9BQXM5Fg15KTD8KtwVWjWFjvlb35ZV/tPTJhWjpa5PZO
         byMhyNAzNDq8nmMvzzEpG5Z4XpwxXDXu0dhY4sNmGYo3z0/GymFtLxwD1t4cuPRlDV
         aH/nUceFziu5+HYlQItrHxAlHQEGIyMsCiR7u5nHyX+f/VyuLubYq21xWzZOtz2YDF
         CTVNvEcRIby4DtB6BQ5H+oBETs66sDfngF2WTCzkrk9DLDYzE7qKAw0/OjH8PMhnUN
         YuduFzUpnFIMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F4A6E1B4D9;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/14][pull request] Intel Wired LAN Driver
 Updates 2022-12-08 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064422125.8448.14722355097534322892.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 03:50:21 +0000
References: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  8 Dec 2022 13:39:18 -0800 you wrote:
> Jacob Keller says:
> 
> This series of patches primarily consists of changes to fix some corner
> cases that can cause Tx timestamp failures. The issues were discovered and
> reported by Siddaraju DH and primarily affect E822 hardware, though this
> series also includes some improvements that affect E810 hardware as well.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/14] ice: Use more generic names for ice_ptp_tx fields
    https://git.kernel.org/netdev/net-next/c/6b5cbc8c4ec7
  - [net-next,v3,02/14] ice: Remove the E822 vernier "bypass" logic
    https://git.kernel.org/netdev/net-next/c/0357d5cab8e4
  - [net-next,v3,03/14] ice: Reset TS memory for all quads
    https://git.kernel.org/netdev/net-next/c/407b66c07e98
  - [net-next,v3,04/14] ice: fix misuse of "link err" with "link status"
    https://git.kernel.org/netdev/net-next/c/11722c39c8d9
  - [net-next,v3,05/14] ice: always call ice_ptp_link_change and make it void
    https://git.kernel.org/netdev/net-next/c/6b1ff5d39228
  - [net-next,v3,06/14] ice: handle discarding old Tx requests in ice_ptp_tx_tstamp
    https://git.kernel.org/netdev/net-next/c/0dd928626392
  - [net-next,v3,07/14] ice: check Tx timestamp memory register for ready timestamps
    https://git.kernel.org/netdev/net-next/c/10e4b4a3a3e1
  - [net-next,v3,08/14] ice: synchronize the misc IRQ when tearing down Tx tracker
    https://git.kernel.org/netdev/net-next/c/f0ae124019fa
  - [net-next,v3,09/14] ice: protect init and calibrating check in ice_ptp_request_ts
    https://git.kernel.org/netdev/net-next/c/3ad5c10bf21d
  - [net-next,v3,10/14] ice: cleanup allocations in ice_ptp_alloc_tx_tracker
    https://git.kernel.org/netdev/net-next/c/c1f3414df2e8
  - [net-next,v3,11/14] ice: handle flushing stale Tx timestamps in ice_ptp_tx_tstamp
    https://git.kernel.org/netdev/net-next/c/d40fd6009332
  - [net-next,v3,12/14] ice: only check set bits in ice_ptp_flush_tx_tracker
    https://git.kernel.org/netdev/net-next/c/e3ba52486693
  - [net-next,v3,13/14] ice: make Tx and Rx vernier offset calibration independent
    https://git.kernel.org/netdev/net-next/c/f029a34394e7
  - [net-next,v3,14/14] ice: reschedule ice_ptp_wait_for_offset_valid during reset
    https://git.kernel.org/netdev/net-next/c/95af1f1c4c9f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


