Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7855A7695
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiHaGaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiHaGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18825A2C2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50768B81F40
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB023C43140;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927418;
        bh=EfyNU297SEYcKquFxL1ff/bUGMkXBpmYdJEqG/aEY10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vQfyL//OocsRUAo7Nl39oOyS/qXAo/1xRJjUrGQx6vSM86y85MUIl6DmS1cG0PSMH
         cPtWmzvr+JklmV0NyvF0MLeWTn9d0L5ecjAn760rqDbOQGOXdRii2bWar65IPt0BoX
         tfFYsi1oXtEQxgFUE6Q8vtiHo3HJms3GavzwG1bpHipRv31zGQD+q/c01IK4ET6QM2
         kho+eJb3McLKFwqbEnM5D6/x1Amzu58UEE+ijGjRONOJuXXpi7XVLxmvklpgV+1JRG
         5u96sUi30k63pcIWrc5nFZPdsTx0ZvSuWbqordDm+GB+/8hzMRw6nPIdKfzGxAxnsz
         ZH+xTbLiHSBDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D19F8E924DD;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mlxsw: Configure max LAG ID for Spectrum-4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741785.4297.16962887795011276082.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:17 +0000
References: <cover.1661527928.git.petrm@nvidia.com>
In-Reply-To: <cover.1661527928.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

On Fri, 26 Aug 2022 18:06:48 +0200 you wrote:
> Amit Cohen writes:
> 
> In the device, LAG identifiers are stored in the port group table (PGT).
> During initialization, firmware reserves a certain amount of entries at
> the beginning of this table for LAG identifiers.
> 
> In Spectrum-4, the size of the PGT table did not increase, but the
> maximum number of LAG identifiers was doubled, leaving less room for
> others entries (e.g., flood entries) that also reside in the PGT.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mlxsw: cmd: Edit the comment of 'max_lag' field in CONFIG_PROFILE
    https://git.kernel.org/netdev/net-next/c/95484760f03d
  - [net-next,2/4] mlxsw: Support configuring 'max_lag' via CONFIG_PROFILE
    https://git.kernel.org/netdev/net-next/c/eb907e9779ca
  - [net-next,3/4] mlxsw: Add a helper function for getting maximum LAG ID
    https://git.kernel.org/netdev/net-next/c/cf735d4c9bab
  - [net-next,4/4] mlxsw: spectrum: Add a copy of 'struct mlxsw_config_profile' for Spectrum-4
    https://git.kernel.org/netdev/net-next/c/c503d8ae48f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


