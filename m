Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E52560FCF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiF3EAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiF3EAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BFD275C9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB0B620B0
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 700D1C341D5;
        Thu, 30 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561614;
        bh=zjOUpzXya5RmeBNXOLVseabBAgk6bwvhB5b9jksSWyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c4ma77HlrTRcf69jo4Enf9SCdzid+ePK4dolv3VIhUqioKldEs6NdTGfk9/PNl8oC
         viEK+TsKqHnVpV+UOKiFKSuo9tz5gBVgsQwcZdFjnqaeXjp4jpCa7Frjh7wL8T8RRL
         lg5v53XHDkq9yPGGB/WyVLh/Ny1HZiQipLpQ/KoVbZWhH8fFB40aY85IaujB2vLp6z
         3fxcAMizdsDtPeAqEbut3XbHZUzZkht5gpeW0aJ/7XBRcl7/OcLbTSjAjUzx+8iJB8
         A1zBac+dzQnBB04F8eCHluxpbeDVH+YCOKq+I+4skTgaCxYvGiPvCBUjLh4u4GFHvk
         DifJajxucge6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57972E49F65;
        Thu, 30 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: switchdev: add reminder near struct
 switchdev_notifier_fdb_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161435.1686.5116778553235504680.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:14 +0000
References: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jiri@resnulli.us,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        idosch@nvidia.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 13:08:31 +0300 you wrote:
> br_switchdev_fdb_notify() creates an on-stack FDB info variable, and
> initializes it member by member. As such, newly added fields which are
> not initialized by br_switchdev_fdb_notify() will contain junk bytes
> from the stack.
> 
> Other uses of struct switchdev_notifier_fdb_info have a struct
> initializer which should put zeroes in the uninitialized fields.
> 
> [...]

Here is the summary with links:
  - [net-next] net: switchdev: add reminder near struct switchdev_notifier_fdb_info
    https://git.kernel.org/netdev/net-next/c/3eb4a4c3442c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


