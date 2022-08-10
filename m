Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4507258EC41
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiHJMuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJMuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105BB642D8
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA2C61387
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F3CAC4314F;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660135815;
        bh=Gu5fA9REZewuf950WUzI0Ph77+bYtPLjEfX1hqCTgBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OEJyPas5XLI12IClyteHBB2RovGzDWaAmqP7wsM4pjKYQgoqKDIz3lwqnvFnIFEjz
         b87KsiTFI4NNuGHygSpA9gfROiQ4nOpkN83KpwlsBlu2NLRLSFSND0WkJOH5BU9nGi
         yXx+GpPmbKHn0NMc2EnAwfWGS+MZlPq5Qe5JIIhvpPVkhFYdZxIPABoj78KKZTs472
         Nrq2nFwHxFoyXbm8vERhGcM4QQmWweg7jH47HJG0SMGb2VsIUcVDIOz7esQO6xbOvu
         HdbAqOKqAqAj9z1zQZv4KAVKpfbCxBnj7oyaoJzK8wixs9A6JxymDo7inuDJTdePzr
         FVuOCKefhLfVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7680DC43145;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: Fix use-after-free after a failed reload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166013581548.3703.13885430900913328520.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 12:50:15 +0000
References: <20220809113506.751730-1-idosch@nvidia.com>
In-Reply-To: <20220809113506.751730-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jiri@nvidia.com,
        mlxsw@nvidia.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 Aug 2022 14:35:06 +0300 you wrote:
> After a failed devlink reload, devlink parameters are still registered,
> which means user space can set and get their values. In the case of the
> mlxsw "acl_region_rehash_interval" parameter, these operations will
> trigger a use-after-free [1].
> 
> Fix this by rejecting set and get operations while in the failed state.
> Return the "-EOPNOTSUPP" error code which does not abort the parameters
> dump, but instead causes it to skip over the problematic parameter.
> 
> [...]

Here is the summary with links:
  - [net] devlink: Fix use-after-free after a failed reload
    https://git.kernel.org/netdev/net/c/6b4db2e528f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


