Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6558A578139
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiGRLu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiGRLuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:50:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C762B1DA42
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 04:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18484B81164
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDDE5C341C0;
        Mon, 18 Jul 2022 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145018;
        bh=GPlQN62Me7ctgRo4nsOBGKmgLYOLBMMtgHBL7/NnwQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kM4luf1TOdvQT+AuOrMoM+Qc235leMSzPwHms9OeL/RZ22VAqJHGcw+eLdGhD6AO+
         ZGZKRCYyQIKfew89BfTuCd45PYDRu16uqlUrADA6neP0rhmr0vieMClAgejxGp+OFU
         tnnaGZSJjmbwOvfeAZuh6dJhlcNhdfKPzBuZkhBbPHjcFRNeL1Uf/8Os4fiWxmWtEc
         4V4voVE7qLCQx2W8SXHByP+PQKtcyZVqO+H8VHz1TUTRDM+oa2zgSoiU6bRy/9/p9W
         LSrAGnk6du9J+djt8FlqH0nfCTzszK7CXMypbjv1pJQb/crNGMcp+reyWfAURqB2H4
         Oy5iQvhSz6vPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAE6FE451B0;
        Mon, 18 Jul 2022 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 00/15] Update DSA documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814501869.27406.3239925265484328864.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 11:50:18 +0000
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Jul 2022 21:53:29 +0300 you wrote:
> These are some updates of dsa.rst, since it hasn't kept up with
> development (in some cases, even since 2017). I've added Fixes: tags as
> I thought was appropriate.
> 
> Vladimir Oltean (15):
>   docs: net: dsa: update probing documentation
>   docs: net: dsa: document the shutdown behavior
>   docs: net: dsa: rename tag_protocol to get_tag_protocol
>   docs: net: dsa: add more info about the other arguments to
>     get_tag_protocol
>   docs: net: dsa: document change_tag_protocol
>   docs: net: dsa: document the teardown method
>   docs: net: dsa: document port_setup and port_teardown
>   docs: net: dsa: document port_fast_age
>   docs: net: dsa: remove port_bridge_tx_fwd_offload
>   docs: net: dsa: remove port_vlan_dump
>   docs: net: dsa: delete port_mdb_dump
>   docs: net: dsa: add a section for address databases
>   docs: net: dsa: re-explain what port_fdb_dump actually does
>   docs: net: dsa: delete misinformation about -EOPNOTSUPP for
>     FDB/MDB/VLAN
>   docs: net: dsa: mention that VLANs are now refcounted on shared ports
> 
> [...]

Here is the summary with links:
  - [net,01/15] docs: net: dsa: update probing documentation
    https://git.kernel.org/netdev/net/c/19b3b13c932f
  - [net,02/15] docs: net: dsa: document the shutdown behavior
    https://git.kernel.org/netdev/net/c/54367831c5d0
  - [net,03/15] docs: net: dsa: rename tag_protocol to get_tag_protocol
    https://git.kernel.org/netdev/net/c/c3f0e84d1086
  - [net,04/15] docs: net: dsa: add more info about the other arguments to get_tag_protocol
    https://git.kernel.org/netdev/net/c/c56313a42aaa
  - [net,05/15] docs: net: dsa: document change_tag_protocol
    https://git.kernel.org/netdev/net/c/d6a0336addd4
  - [net,06/15] docs: net: dsa: document the teardown method
    https://git.kernel.org/netdev/net/c/b763f50dc157
  - [net,07/15] docs: net: dsa: document port_setup and port_teardown
    https://git.kernel.org/netdev/net/c/3c87237ecd27
  - [net,08/15] docs: net: dsa: document port_fast_age
    https://git.kernel.org/netdev/net/c/0cb8682ebf5e
  - [net,09/15] docs: net: dsa: remove port_bridge_tx_fwd_offload
    https://git.kernel.org/netdev/net/c/308362394850
  - [net,10/15] docs: net: dsa: remove port_vlan_dump
    https://git.kernel.org/netdev/net/c/e465d507c76c
  - [net,11/15] docs: net: dsa: delete port_mdb_dump
    https://git.kernel.org/netdev/net/c/7f75d3dd4f5b
  - [net,12/15] docs: net: dsa: add a section for address databases
    https://git.kernel.org/netdev/net/c/4e9d9bb6df6b
  - [net,13/15] docs: net: dsa: re-explain what port_fdb_dump actually does
    https://git.kernel.org/netdev/net/c/ea7006a7aaee
  - [net,14/15] docs: net: dsa: delete misinformation about -EOPNOTSUPP for FDB/MDB/VLAN
    https://git.kernel.org/netdev/net/c/6ba1a4aa5974
  - [net,15/15] docs: net: dsa: mention that VLANs are now refcounted on shared ports
    https://git.kernel.org/netdev/net/c/7b02f40350f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


