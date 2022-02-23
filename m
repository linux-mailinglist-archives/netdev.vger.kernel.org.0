Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD34C133B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240624AbiBWMum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBWMuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:50:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54665A88A4;
        Wed, 23 Feb 2022 04:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A10A5CE1A57;
        Wed, 23 Feb 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12CF8C340F0;
        Wed, 23 Feb 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620610;
        bh=ymOIlTGDjkTOZDyBJkQjihRToWgHYWwBNMJu5Ly87UI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cK9o35tRiNcA8NcCNkhumTifgvGx5OMJBKMLPl4lniiE8rgLTPRzuGP7yR02xPvF4
         OEsXZ8KLRgd6hnhYZh5MGpUTrcUnvX3RwZzhTDJhvGm/cmOEvUzEogT+xiMyB2WvVl
         udDi/uYEIogGS19FLwx2lnk0FNfuyZ+nJlDiS3M+oB1Zdo/ZsMVHqmW2B64XaaevmL
         v/k8rPfwWx4GY0Ens/jDe8Eia33ZBdt1hWZZXN2o+UijzUAHosWc0JsDK0XVgeZnWy
         KFhmSmHdkTEdi+BCuW43LHCeH5c4/xoPA9wfaGq+MooO7Tgdr9rz2u5oPmWzo9Mlyg
         ZQt8UDrUkwHaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF5B4E6D528;
        Wed, 23 Feb 2022 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: avoid newline at end of message in
 NL_SET_ERR_MSG_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562060997.32023.7940152483015525319.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:50:09 +0000
References: <20220223023419.396365-1-wanjiabing@vivo.com>
In-Reply-To: <20220223023419.396365-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiabing.wan@qq.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Feb 2022 10:34:19 +0800 you wrote:
> Fix following coccicheck warning:
> ./net/sched/act_api.c:277:7-49: WARNING avoid newline at end of message
> in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  net/sched/act_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: sched: avoid newline at end of message in NL_SET_ERR_MSG_MOD
    https://git.kernel.org/netdev/net/c/ecf4a24cf978

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


