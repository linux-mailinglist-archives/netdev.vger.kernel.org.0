Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA9574AE9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiGNKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiGNKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF36529CB1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F1BFB8248F
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 156B9C34115;
        Thu, 14 Jul 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657795214;
        bh=Ooz89c2I2B1VTAZ2/C/Wt525paEje7ftISA5Of5DqxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CJfxU8cIVWihxpp7021m42vgK2Ei/0zSEQole+TY1e8PG9PGGBXGl7Hcrq9Lzh4UF
         yBEuU+1Vuw2ixt2yr8vibBI8KKpOfZjcvYYpYbv4rse/SJvPbDev2FsVydHRJTcBYM
         quoke4L0MtCfQsQVjNSecZEFfTuffUEQw93vCVQeBl6J8N1DzsWS3rM1BXiWo3uXLh
         9FPJRj9f2lvKorZXb06gOHS3sXe9WAKSBW8VZKFHKutNDNPCJgxo+BmmWo5ua198DZ
         ATujL9ZgwnSa6aHmmp2kmPlNN73gMetSwua21imuZWyORO1J1rxiVri971b9EGPXE9
         G1dS7RhwStHVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7C31E45228;
        Thu, 14 Jul 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] xen-netfront: XSA-403 follow-on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165779521394.17700.1175257223306226603.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 10:40:13 +0000
References: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
In-Reply-To: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
To:     Jan Beulich <JBeulich@suse.com>
Cc:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        jgross@suse.com, stefano@stabellini.net,
        oleksandr_tyshchenko@epam.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 11:18:03 +0200 you wrote:
> While investigating the XSA, I did notice a few more things. The two
> patches aren't really dependent on one another.
> 
> 1: remove leftover call to xennet_tx_buf_gc()
> 2: re-order error checks in xennet_get_responses()
> 
> Jan

Here is the summary with links:
  - [net-next,1/2] xen-netfront: remove leftover call to xennet_tx_buf_gc()
    https://git.kernel.org/netdev/net-next/c/ad39bafda736
  - [net-next,2/2] xen-netfront: re-order error checks in xennet_get_responses()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


