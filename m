Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99E6BA9F8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjCOHvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjCOHus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD96C69A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2786461BD1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81A0BC433D2;
        Wed, 15 Mar 2023 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866617;
        bh=3c6utJhIKn5x4o2o2f7p+RLcxReuoK2Qm8x50XDZXaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nwXwYDjXQOdpRCNkbkcl1/oR0YOJPe8+5oEwWclxepA/QFZue2vhXnW9Bur0XB4Ne
         Gmq/CMya53nt6f+oDQSStkRqNmffYeVCKT+E8Qsy6hM0rvf2gMsKtGQgDeHwtd378H
         3T3mGJcD3h4RipreZXKB6b2OaiQ/XD6gRTryPAm+P/1p4ao8JmwDscS0b1QrSx0rci
         alU/WN+nESpl7G10qBMXY1IMHaMc0x/ivc/64R6H6ssouLEl28teuTdr1t+z9uaz6l
         lY2eCBXM6uJ93TrgBCUGakb1vX0LpIZgnEC38iKfTVMp7oldQ5VSFBCwghkd9Wcn9X
         5L6y9dhjPng1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6861EC43161;
        Wed, 15 Mar 2023 07:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] mlxsw: spectrum: Fix incorrect parsing depth after
 reload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886661742.11035.6913159500431646687.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:50:17 +0000
References: <9c35e1b3e6c1d8f319a2449d14e2b86373f3b3ba.1678727526.git.petrm@nvidia.com>
In-Reply-To: <9c35e1b3e6c1d8f319a2449d14e2b86373f3b3ba.1678727526.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, amcohen@nvidia.com,
        idosch@nvidia.com, mlxsw@nvidia.com, maksymy@nvidia.com
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

On Mon, 13 Mar 2023 18:21:24 +0100 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Spectrum ASICs have a configurable limit on how deep into the packet
> they parse. By default, the limit is 96 bytes.
> 
> There are several cases where this parsing depth is not enough and there
> is a need to increase it. For example, timestamping of PTP packets and a
> FIB multipath hash policy that requires hashing on inner fields. The
> driver therefore maintains a reference count that reflects the number of
> consumers that require an increased parsing depth.
> 
> [...]

Here is the summary with links:
  - [net,v2] mlxsw: spectrum: Fix incorrect parsing depth after reload
    https://git.kernel.org/netdev/net/c/35c356924fe3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


