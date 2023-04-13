Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCC6E1335
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjDMRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDMRKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A057D8E
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1D886404A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED885C4339B;
        Thu, 13 Apr 2023 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405819;
        bh=tOly3m9JvnTDwIVrBY+/XyiSb8N0fUPa7E44KYGZCIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ReqY4L42PsPi5Mm29N7+aIEGVmGpUnVUPKtsRGtkEza8EtaW9U+nMns0dvT00nB8A
         unKzfrR8u7hFlKh9gpXSmRggLl+I1kx9FONNF8OCsq96JKpPUwrJrx4FuJ21VkrQqx
         g5hksyKQgrQlUDLVexo8MJxZZHqQaFdG9OQMWBxiVGon7q40s433qZSZtJlTHnr/sL
         v0iYGvSaP1zveR27OaaGTaFYkGN3CxzNHk9hBjZhE/o2iiz9Ge+265EmTURQ646DLF
         HAP/BJkLVQUFQxKJiv8mVMwY6e2KxBEphai+Sgbij2nM1fJRIiczk1ia+9xKtZY+ev
         APNoz6XL4jOVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA523E52443;
        Thu, 13 Apr 2023 17:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: openvswitch: adjust datapath NL message
 declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140581882.3344.15471310783050251972.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:10:18 +0000
References: <20230412115828.3991806-1-aconole@redhat.com>
In-Reply-To: <20230412115828.3991806-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, i.maximets@ovn.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 07:58:28 -0400 you wrote:
> The netlink message for creating a new datapath takes an array
> of ports for the PID creation.  This shouldn't cause much issue
> but correct it for future cases where we need to do decode of
> datapath information that could include the per-cpu PID map.
> 
> Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests: openvswitch: adjust datapath NL message declaration
    https://git.kernel.org/netdev/net/c/306dc2136199

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


