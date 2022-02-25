Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7726D4C3E25
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiBYGAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiBYGAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:00:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73FC1FE54A
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D0A3618FE
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C58CFC340F0;
        Fri, 25 Feb 2022 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645768812;
        bh=9D358hSOkU2u5ujTs4L7LZFUfrD5iw+aWcMdw2+3j9U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WtOjFMZ4wG+Y37qJiLYoPBYDnf/H+75koSSvVFNWZaOcl3LxIIMFJyK6OPOK6Rf9A
         iAmWjXikis6J7FvGI4CLun9Y732KhyMe1k6YhDCSaA3i/8midpp3HGj9AukATGIOjD
         +VqRikg/kX5bFBHoMgPVyDhNYsK5QAK5WNlU4sf7DQIqfC9i/KqQtmc9m8Yi5bD/w2
         0u6vovGTqpDNpe5lE0XemWD7YkH4AwTNNrMC7rbSNGYuvhJV2dGf3zdxDEu769TVHv
         r+HzEVawb8azbnmnR+hL1ZUR8a9cq5R2sbOZusTxRI8zCm4fpCtJKsMA1dsXOD30eX
         HTlnzxtx8akOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8775E6D453;
        Fri, 25 Feb 2022 06:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] nfp: flow-independent tc action hardware
 offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576881268.21574.10432407891464572702.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 06:00:12 +0000
References: <20220223162302.97609-1-simon.horman@corigine.com>
In-Reply-To: <20220223162302.97609-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, baowen.zheng@corigine.com,
        louis.peens@corigine.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 17:22:56 +0100 you wrote:
> Baowen Zheng says:
> 
> Allow nfp NIC to offload tc actions independent of flows.
> 
> The motivation for this work is to offload tc actions independent of flows
> for nfp NIC. We allow nfp driver to provide hardware offload of OVS
> metering feature - which calls for policers that may be used by multiple
> flows and whose lifecycle is independent of any flows that use them.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] nfp: refactor policer config to support ingress/egress meter
    https://git.kernel.org/netdev/net-next/c/bbab5f9332ee
  - [net-next,v2,2/6] nfp: add support to offload tc action to hardware
    https://git.kernel.org/netdev/net-next/c/59080da09038
  - [net-next,v2,3/6] nfp: add hash table to store meter table
    https://git.kernel.org/netdev/net-next/c/26ff98d7dd20
  - [net-next,v2,4/6] nfp: add process to get action stats from hardware
    https://git.kernel.org/netdev/net-next/c/776178a5cc67
  - [net-next,v2,5/6] nfp: add support to offload police action from flower table
    https://git.kernel.org/netdev/net-next/c/147747ec664e
  - [net-next,v2,6/6] nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter offload
    https://git.kernel.org/netdev/net-next/c/5e98743cfad0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


