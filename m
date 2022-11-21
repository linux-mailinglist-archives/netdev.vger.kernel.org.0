Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB07631DD1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiKUKKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiKUKKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98260647B;
        Mon, 21 Nov 2022 02:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DE860F8F;
        Mon, 21 Nov 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 876B2C433D7;
        Mon, 21 Nov 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669025415;
        bh=T4K8ig7bmaI7VH4mNBFahKssSIE07VnyMOdXWGkqoJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YHivCHWmBtz7L8JX518XdlcGYjCJe3KqHcJbJ7rZgHcZ3mHW/nxc7HRysUE/MrYOT
         MV6QO2d18w3p47H55aOK8nzIg3VXKd+n9p2hywFR9SztJEu+AUaIEuEZM2o4y8Gm+C
         mL5pKCFwmRYXEePKMeGs27Oc1Mxasiz2lG2NSd+hzxSkFzD41TYbGe70P2qGwRpXEm
         D4NCYOO9moeqHyVHOFVtoGiXh165UzJp9s74go3y7+PZziOHmeV05JnziuAzcRWfeM
         0pwGe/zDcF92DAtAb5UCqFFQxMhUNJMSTbcEGvbByPr85KpinqQDJfLibaYmvxsuDC
         YXZCpdkHowz3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CF66E29F3F;
        Mon, 21 Nov 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: microchip: sparx5: prevent uninitialized
 variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902541544.20190.2250651542469852719.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 10:10:15 +0000
References: <Y3ZTQZYz5zz5nMg2@kadam>
In-Reply-To: <Y3ZTQZYz5zz5nMg2@kadam>
To:     Dan Carpenter <error27@gmail.com>
Cc:     davem@davemloft.net, daniel.machon@microchip.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 18:29:05 +0300 you wrote:
> Smatch complains that:
> 
>     drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c:112
>     sparx5_dcb_apptrust_validate() error: uninitialized symbol 'match'.
> 
> This would only happen if the:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: microchip: sparx5: prevent uninitialized variable
    https://git.kernel.org/netdev/net-next/c/62a45b384a28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


