Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185B4FDE82
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiDLLuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbiDLLss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384F7583AC
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F5F6193C
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAD2DC385A6;
        Tue, 12 Apr 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649759412;
        bh=YzsOlzg3xm5yC3RVLIZCNVBO3KBzHONbQ72Xbh02o68=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rpl1no6StqmG/a07P359EA+xorK0NN0YnSw93942rB9Kd2CQ7EDzIsykbA5KCoS3t
         VW7bmsS6Gga+ownG60kwXX45zJYnRZ/GnIBsdklbuKXX3a8XBVid5JnQngi6pj4wLo
         BIggOZ5L0ToFy/bcvnlL+WxGvGPi5j3NJyoekGPpiZYzP3LD0hLOG1vlMbsafci+vw
         Dk4UvtdYXezJ5XNY/EslPFeUeDyFkIMFJ0fQLM9Z7CaycjdG4MMiDl+MPrrJ+35Hjg
         bASrlxg+fKTjr7QQL9g4gcDQ4hnjGdLyXpo5WLa+NB/4Nz6q71gZvtsg4byOO7SMry
         CEa4kbwAsRaig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0F82E85D15;
        Tue, 12 Apr 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] sfc: Remove some global definitions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164975941278.32245.3364236734690562950.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 10:30:12 +0000
References: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
In-Reply-To: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 12:27:04 +0100 you wrote:
> These are some small cleanups to remove definitions that need not
> be defined in .h files.
> ---
> 
> Martin Habets (3):
>       sfc: efx_default_channel_type APIs can be static
>       sfc: Remove duplicate definition of efx_xmit_done
>       sfc: Remove global definition of efx_reset_type_names
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] sfc: efx_default_channel_type APIs can be static
    https://git.kernel.org/netdev/net-next/c/54fccfdd7c66
  - [net-next,2/3] sfc: Remove duplicate definition of efx_xmit_done
    https://git.kernel.org/netdev/net-next/c/cc42e4e3f101
  - [net-next,3/3] sfc: Remove global definition of efx_reset_type_names
    https://git.kernel.org/netdev/net-next/c/d78eaf06b5d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


