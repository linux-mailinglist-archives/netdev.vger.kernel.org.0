Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC05F2900
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJCHKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJCHK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:10:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611429808
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D39AFB80E64
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89743C433C1;
        Mon,  3 Oct 2022 07:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664781024;
        bh=8IbQUWlOjgrRgQaqf/L1Z0No822EtKVrlSh+LhbprAw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U0+ZTHd5loch8ZPJ+F/Djm3fVTcmITqbVP/BvcOjDL1ML39s+1Dc4mOFd9PTgZlkg
         Q5Bp8WGlAJDPaB2WxCImigxf/dPjIr0/9pRrL30bS3TCBEnS5OWWsR8aWpIoH9KwRi
         ayyiaeOuK9h8LcqUvvoU79SE9OzPZwA+UYJOM+a94Ye6GlL/RF64VdOZBM1UdvGocC
         KUiOE5Xv6DB7S9090zSP7zGeQXH3gn/GSdBGh94m3QhALPdVkjBbF0uhT3HLumFGP3
         FqzT++Nqudr5Kdc7WOogKewxOzU0zQd7mXcp/x2vAY6IeP2Q0gWDza92UgsNjFmYmB
         lo2WoUPMV5pwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75E09E4D03B;
        Mon,  3 Oct 2022 07:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/24] selftests/net: Refactor xfrm_fill_key() to use array of
 structs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166478102447.21968.3239077651352259753.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 07:10:24 +0000
References: <20221002081712.757515-2-steffen.klassert@secunet.com>
In-Reply-To: <20221002081712.757515-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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
by Steffen Klassert <steffen.klassert@secunet.com>:

On Sun, 2 Oct 2022 10:16:49 +0200 you wrote:
> From: Gautam Menghani <gautammenghani201@gmail.com>
> 
> A TODO in net/ipsec.c asks to refactor the code in xfrm_fill_key() to
> use set/map to avoid manually comparing each algorithm with the "name"
> parameter passed to the function as an argument. This patch refactors
> the code to create an array of structs where each struct contains the
> algorithm name and its corresponding key length.
> 
> [...]

Here is the summary with links:
  - [01/24] selftests/net: Refactor xfrm_fill_key() to use array of structs
    https://git.kernel.org/netdev/net-next/c/93d7c52a6eb9
  - [02/24] xfrm: Drop unused argument
    https://git.kernel.org/netdev/net-next/c/0de1978852df
  - [03/24] net: allow storing xfrm interface metadata in metadata_dst
    https://git.kernel.org/netdev/net-next/c/5182a5d48c3d
  - [04/24] xfrm: interface: support collect metadata mode
    https://git.kernel.org/netdev/net-next/c/abc340b38ba2
  - [05/24] xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode
    https://git.kernel.org/netdev/net-next/c/2c2493b9da91
  - [06/24] xfrm: propagate extack to all netlink doit handlers
    https://git.kernel.org/netdev/net-next/c/3bec6c3e83b5
  - [07/24] xfrm: add extack support to verify_newpolicy_info
    https://git.kernel.org/netdev/net-next/c/ec2b4f01536d
  - [08/24] xfrm: add extack to verify_policy_dir
    https://git.kernel.org/netdev/net-next/c/24fc544fb525
  - [09/24] xfrm: add extack to verify_policy_type
    https://git.kernel.org/netdev/net-next/c/fb7deaba40cf
  - [10/24] xfrm: add extack to validate_tmpl
    https://git.kernel.org/netdev/net-next/c/d37bed89f082
  - [11/24] xfrm: add extack to verify_sec_ctx_len
    https://git.kernel.org/netdev/net-next/c/08a717e48037
  - [12/24] xfrm: add extack support to verify_newsa_info
    https://git.kernel.org/netdev/net-next/c/6999aae17a7b
  - [13/24] xfrm: add extack to verify_replay
    https://git.kernel.org/netdev/net-next/c/785b87b22085
  - [14/24] xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
    https://git.kernel.org/netdev/net-next/c/1fc8fde55391
  - [15/24] xfrm: add extack support to xfrm_dev_state_add
    https://git.kernel.org/netdev/net-next/c/adb5c33e4d4c
  - [16/24] xfrm: add extack to attach_*
    https://git.kernel.org/netdev/net-next/c/2b9168266d15
  - [17/24] xfrm: add extack to __xfrm_init_state
    https://git.kernel.org/netdev/net-next/c/741f9a106498
  - [18/24] xfrm: add extack support to xfrm_init_replay
    https://git.kernel.org/netdev/net-next/c/1cf9a3ae3e2d
  - [19/24] xfrm: pass extack down to xfrm_type ->init_state
    https://git.kernel.org/netdev/net-next/c/e1e10b44cf28
  - [20/24] xfrm: ah: add extack to ah_init_state, ah6_init_state
    https://git.kernel.org/netdev/net-next/c/ef87a4f84b10
  - [21/24] xfrm: esp: add extack to esp_init_state, esp6_init_state
    https://git.kernel.org/netdev/net-next/c/67c44f93c951
  - [22/24] xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
    https://git.kernel.org/netdev/net-next/c/25ec92cd042a
  - [23/24] xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
    https://git.kernel.org/netdev/net-next/c/6ee55320520e
  - [24/24] xfrm: mip6: add extack to mip6_destopt_init_state, mip6_rthdr_init_state
    https://git.kernel.org/netdev/net-next/c/28b5dbd5dcf7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


