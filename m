Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B265280B4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbiEPJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiEPJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A8F25EAA;
        Mon, 16 May 2022 02:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 672BDB80F3B;
        Mon, 16 May 2022 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AA73C385B8;
        Mon, 16 May 2022 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652692818;
        bh=z6tNXPPGBlQ3qR5T9UkmcDDP/e0OldDPx7mPPk/JX5w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qqTNIGXdqjgTEkj6UeSG2+FB6ehAXeHE9QR9EPgl+J6UGzZME27TPSog5O+CUmZPd
         kM6baUmKIStnv1nWIHI6aSQIx8nzt22nEzMa4oIE3C84T/3cBK8pJY2IYQTzjiJFSE
         rvLaQbpU4AGVMxWTOCliwQdLHo/b5Ne6woG5aWA6xBUiE+sQZjWOsgd5WinsH1kUSp
         Wa9DqMk38Vd25S0v+yzQbWHN/eZaNkKNK0Ujqg6/3Qoh0o7N4jRQTKbpF6tKJPA4Qe
         zRR+yA49tvPNE+MgD5vrOCKW4q9umklrvxgOa3ntsBjxP9afXTqMPX6YjYVilfA18l
         Guj4ryiad36PQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C218E8DBDA;
        Mon, 16 May 2022 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/17] netfilter: ecache: use dedicated list for
 event redelivery
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269281804.1627.3114104321343166831.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:20:18 +0000
References: <20220513214329.1136459-2-pablo@netfilter.org>
In-Reply-To: <20220513214329.1136459-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 13 May 2022 23:43:13 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This disentangles event redelivery and the percpu dying list.
> 
> Because entries are now stored on a dedicated list, all
> entries are in NFCT_ECACHE_DESTROY_FAIL state and all entries
> still have confirmed bit set -- the reference count is at least 1.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] netfilter: ecache: use dedicated list for event redelivery
    https://git.kernel.org/netdev/net-next/c/2ed3bf188b33
  - [net-next,02/17] netfilter: conntrack: include ecache dying list in dumps
    https://git.kernel.org/netdev/net-next/c/0d3cc504ba9c
  - [net-next,03/17] netfilter: conntrack: remove the percpu dying list
    https://git.kernel.org/netdev/net-next/c/1397af5bfd7d
  - [net-next,04/17] netfilter: cttimeout: decouple unlink and free on netns destruction
    https://git.kernel.org/netdev/net-next/c/78222bacfca9
  - [net-next,05/17] netfilter: remove nf_ct_unconfirmed_destroy helper
    https://git.kernel.org/netdev/net-next/c/17438b42ce14
  - [net-next,06/17] netfilter: extensions: introduce extension genid count
    https://git.kernel.org/netdev/net-next/c/c56716c69ce1
  - [net-next,07/17] netfilter: cttimeout: decouple unlink and free on netns destruction
    https://git.kernel.org/netdev/net-next/c/42df4fb9b1be
  - [net-next,08/17] netfilter: conntrack: remove __nf_ct_unconfirmed_destroy
    https://git.kernel.org/netdev/net-next/c/ace53fdc262f
  - [net-next,09/17] netfilter: conntrack: remove unconfirmed list
    https://git.kernel.org/netdev/net-next/c/8a75a2c17410
  - [net-next,10/17] netfilter: conntrack: avoid unconditional local_bh_disable
    https://git.kernel.org/netdev/net-next/c/0bcfbafbcd34
  - [net-next,11/17] netfilter: conntrack: add nf_ct_iter_data object for nf_ct_iterate_cleanup*()
    https://git.kernel.org/netdev/net-next/c/8169ff584003
  - [net-next,12/17] netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
    https://git.kernel.org/netdev/net-next/c/2794cdb0b97b
  - [net-next,13/17] netfilter: conntrack: un-inline nf_ct_ecache_ext_add
    https://git.kernel.org/netdev/net-next/c/b0a7ab4a7765
  - [net-next,14/17] netfilter: conntrack: add nf_conntrack_events autodetect mode
    https://git.kernel.org/netdev/net-next/c/90d1daa45849
  - [net-next,15/17] netfilter: prefer extension check to pointer check
    https://git.kernel.org/netdev/net-next/c/8edc81311100
  - [net-next,16/17] netfilter: flowtable: nft_flow_route use more data for reverse route
    https://git.kernel.org/netdev/net-next/c/3412e1641828
  - [net-next,17/17] netfilter: conntrack: skip verification of zero UDP checksum
    https://git.kernel.org/netdev/net-next/c/4f9bd53084d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


