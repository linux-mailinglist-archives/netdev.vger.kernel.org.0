Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2824C8716
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiCAIvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiCAIu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:50:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB5C89315
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 00:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D70361542
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9BF4C340F1;
        Tue,  1 Mar 2022 08:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646124613;
        bh=zXCvhIhxgRpQlm9xAVyErTcvhbxy4mZIXd87c5rCj9U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TBLGhYNA/FI5CvpmQrMDib0hOnjxOfk7+xyoSfqzi5204Gi5kt90uAV92UpG3K/+f
         sHjqMIAqpEgd2RJXjjBD2tK8OZF1Yt9BaPBWkDEXYkCEMx6l0QH8wrHu200WCsphvU
         TDV4aG/KnfXdgBeV6MDWfQeJRFz4WR84Wb1AgbQVZM4J1gJxU5SCtCacwyZB6gpj1K
         kkCsrm8Q9q2fEfkHeRlxPT8lng2uG3TLgFUTBQTp7iWCShg0sF29SqD1sO8HwNO2Ok
         rdQ8Szs8HW5nAr4kS32h/jBYJZBcmuofkJlMQhRS8MkX/SnsTTJlZZ+Y6AGvWt8J0b
         S0Svk3FNap2kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE519EAC095;
        Tue,  1 Mar 2022 08:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/12] vxlan metadata device vnifiltering support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164612461276.12731.12133825618202154636.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Mar 2022 08:50:12 +0000
References: <20220301050439.31785-1-roopa@nvidia.com>
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com, bpoirier@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 1 Mar 2022 05:04:27 +0000 you wrote:
> This series adds vnifiltering support to vxlan collect metadata device.
> 
> Motivation:
> You can only use a single vxlan collect metadata device for a given
> vxlan udp port in the system today. The vxlan collect metadata device
> terminates all received vxlan packets. As shown in the below diagram,
> there are use-cases where you need to support multiple such vxlan devices in
> independent bridge domains. Each vxlan device must terminate the vni's
> it is configured for.
> Example usecase: In a service provider network a service provider
> typically supports multiple bridge domains with overlapping vlans.
> One bridge domain per customer. Vlans in each bridge domain are
> mapped to globally unique vxlan ranges assigned to each customer.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/12] vxlan: move to its own directory
    https://git.kernel.org/netdev/net-next/c/6765393614ea
  - [net-next,v3,02/12] vxlan_core: fix build warnings in vxlan_xmit_one
    https://git.kernel.org/netdev/net-next/c/fba55a66e8ec
  - [net-next,v3,03/12] vxlan_core: move common declarations to private header file
    https://git.kernel.org/netdev/net-next/c/76fc217d7fb1
  - [net-next,v3,04/12] vxlan_core: move some fdb helpers to non-static
    https://git.kernel.org/netdev/net-next/c/c63053e0cb5a
  - [net-next,v3,05/12] vxlan_core: make multicast helper take rip and ifindex explicitly
    https://git.kernel.org/netdev/net-next/c/a9508d121a0e
  - [net-next,v3,06/12] vxlan_core: add helper vxlan_vni_in_use
    https://git.kernel.org/netdev/net-next/c/efe0f94b333b
  - [net-next,v3,07/12] rtnetlink: add new rtm tunnel api for tunnel id filtering
    https://git.kernel.org/netdev/net-next/c/7b8135f4df98
  - [net-next,v3,08/12] vxlan_multicast: Move multicast helpers to a separate file
    https://git.kernel.org/netdev/net-next/c/a498c5953a9c
  - [net-next,v3,09/12] vxlan: vni filtering support on collect metadata device
    https://git.kernel.org/netdev/net-next/c/f9c4bb0b245c
  - [net-next,v3,10/12] selftests: add new tests for vxlan vnifiltering
    https://git.kernel.org/netdev/net-next/c/3edf5f66c12a
  - [net-next,v3,11/12] drivers: vxlan: vnifilter: per vni stats
    https://git.kernel.org/netdev/net-next/c/4095e0e1328a
  - [net-next,v3,12/12] drivers: vxlan: vnifilter: add support for stats dumping
    https://git.kernel.org/netdev/net-next/c/445b2f36bb4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


