Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094024CD269
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiCDKbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiCDKbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:31:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC6316BCE6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7C88B8275C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67CCFC340EE;
        Fri,  4 Mar 2022 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646389814;
        bh=8EG4P8GQaLbNz514fbI2BgX5HgpT7Wq6BiP4gOlB18E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SMjdJrnc1jr0+EwlxPYgKEgu8NYJSbDH89z0cKFyBTBfcnLQN/Xd3UsF+pOxmZA0Q
         ru6fBRrOSfK3C1KRpUYddzdS1TbNPggjp/RKaLN1vMjW8/gKVpUmhTw9Wu3C6XDqbB
         9uoUgTGHeZW9uMODRINzQp2xXLX0F7k3NU7cyBcTH5hsM4flHwpUmC+qDopliVP4Ng
         AOTfOldBtQOqoCk6n1ldb/8Y0XmrRC2ys9C1wu2fQlnXdNnAvgUHQz+qvXcqsXMcLN
         DnrvP2MSnGVGc5deZOjLgSZ746HhIbzM1sTZVa26YGTxdSL/uXk+y0lgRnKfGTtsLQ
         8rwsFDKYcFstA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FFA8EAC099;
        Fri,  4 Mar 2022 10:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-03-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164638981432.20580.15439256824854720198.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 10:30:14 +0000
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Mar 2022 13:14:38 -0800 you wrote:
> Jacob Keller says:
> 
> This series refactors the ice networking driver VF storage from a simple
> static array to a hash table. It also introduces krefs and proper locking
> and protection to prevent common use-after-free and concurrency issues.
> 
> There are two motivations for this work. First is to make the ice driver
> more resilient by preventing a whole class of use-after-free bugs that can
> occur around concurrent access to VF structures while removing VFs.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] ice: refactor unwind cleanup in eswitch mode
    https://git.kernel.org/netdev/net-next/c/df830543d63c
  - [net-next,02/11] ice: store VF pointer instead of VF ID
    https://git.kernel.org/netdev/net-next/c/b03d519d3460
  - [net-next,03/11] ice: pass num_vfs to ice_set_per_vf_res()
    https://git.kernel.org/netdev/net-next/c/cd0f4f3b2c04
  - [net-next,04/11] ice: move clear_malvf call in ice_free_vfs
    https://git.kernel.org/netdev/net-next/c/294627a67e96
  - [net-next,05/11] ice: move VFLR acknowledge during ice_free_vfs
    https://git.kernel.org/netdev/net-next/c/44efe75f736f
  - [net-next,06/11] ice: remove checks in ice_vc_send_msg_to_vf
    https://git.kernel.org/netdev/net-next/c/59e1f857e377
  - [net-next,07/11] ice: use ice_for_each_vf for iteration during removal
    https://git.kernel.org/netdev/net-next/c/19281e866808
  - [net-next,08/11] ice: convert ice_for_each_vf to include VF entry iterator
    https://git.kernel.org/netdev/net-next/c/c4c2c7db64e1
  - [net-next,09/11] ice: factor VF variables to separate structure
    https://git.kernel.org/netdev/net-next/c/000773c00f52
  - [net-next,10/11] ice: introduce VF accessor functions
    https://git.kernel.org/netdev/net-next/c/fb916db1f04f
  - [net-next,11/11] ice: convert VF storage to hash table with krefs and RCU
    https://git.kernel.org/netdev/net-next/c/3d5985a185e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


