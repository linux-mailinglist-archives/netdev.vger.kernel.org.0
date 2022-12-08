Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909BA647451
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiLHQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiLHQaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4028655A7
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B1C61F90
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BB39C43392;
        Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670517016;
        bh=4JCkIQt15P7S2BPtUMyZgeu29Zr8iz0I1Jqi7OMtsKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IBzoUoVnsTqQvnbwXCCm0saP62JxX4jYBdXvZtWjNFUDYdUdG68P3a2bn4kMYY3aL
         nTb+SlFVcM1sxjd5+BZBifnsU/WVKbGsmHq1QXj5AMHHxt/ICSYthvSW+bNj9bzEzl
         6NuNVuf0fa89wqsPJuv/daEPzHgOIXm17khlS1dytRF5rR7mA/klUnLm+vhZgM78NZ
         5Op4UTpqfnqqsT1wBNaLrqXiSkRLa2bLhUIa2xsQOEIe7WOtuJ6GncK+a/B2OcqLiA
         0yO7lJjBEs2DUzjLGcEFNLsAQnSZJfFaf5zYv7y2V6UOJi3tVRsWQy/dLy7UGx+ZxD
         VGEMdqsMWI7lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B9EFC00442;
        Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] libnetlink: Fix wrong netlink header placement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167051701610.25268.1005231482471591679.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 16:30:16 +0000
References: <20221208143816.936498-1-idosch@nvidia.com>
In-Reply-To: <20221208143816.936498-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  8 Dec 2022 16:38:16 +0200 you wrote:
> The netlink header must be first in the netlink message, so move it
> there.
> 
> Fixes: fee4a56f0191 ("Update kernel headers")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/libnetlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [iproute2-next] libnetlink: Fix wrong netlink header placement
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=fa94a9792155

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


