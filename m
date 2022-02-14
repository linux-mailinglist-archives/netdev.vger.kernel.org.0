Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F174B51EF
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354473AbiBNNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:40:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354466AbiBNNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5E5621C;
        Mon, 14 Feb 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC3F6150D;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BEDFC36AE5;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846011;
        bh=9CxyXNm9jzow7CDZeZG87Th1FFpepAvFYVmMUtyz9UM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d19A+rurHFizcFTosVhQwQ0m0XS3ozEiygbv/f0QKWhxRnPb4ogke4u8cZpPBE17z
         Kt0Y1n1YR6GhrIPB+Lo9dbBjQOVhFd8wSwrzRkeD6RvRNSLNVq+F7M46O+eVPZ9XOZ
         YUr4fQb6Rm53mLF1KrbLDohjRXfLyL25nCMqb4vdSJBs/8H4CKyElu6UXENNdWx98k
         Yzgji2BTMhB3RdSOA621WtzdEbirhrOrfGXMYH17jnKhlGybl2DX3nZCH1FE60iPH7
         QsG0ZDYhjGXkJkhIw3FDtFfM/sGgA4rWutYOk/j/ol/j5i4QE1gqA6Cq9xU8PRJ1D9
         ARggiqxzNeLdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3960CE5D09D;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next 1/1] ice: Simplify tracking status of RDMA
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484601122.23487.11961062389309355798.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:40:11 +0000
References: <20220211182603.745166-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220211182603.745166-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, david.m.ertman@intel.com,
        netdev@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org,
        leszek.kaliszczuk@intel.com, leonro@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Feb 2022 10:26:03 -0800 you wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The status of support for RDMA is currently being tracked with two
> separate status flags. This is unnecessary with the current state of
> the driver.
> 
> Simplify status tracking down to a single flag.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/1] ice: Simplify tracking status of RDMA support
    https://git.kernel.org/netdev/net-next/c/88f62aea1cff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


