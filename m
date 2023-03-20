Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B386C0D07
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCTJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjCTJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCA2168A9;
        Mon, 20 Mar 2023 02:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3765D612D4;
        Mon, 20 Mar 2023 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94AA6C433D2;
        Mon, 20 Mar 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679304017;
        bh=S8HH+qBdaVGjjcJuyjt9fd3I+oThX2xyyWH+nsgaglI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jYaUeoE1pbQKpQo14r/8NoAAKS+c3zcvx3YJQLj41K7/qwXhkDvx21cApWaIMAzGv
         KDGte3S8Gs3RNgjJD9xDN/46HVBmNSF3UnSXHLairKFhScrUN9nVjh9ymf6RM9rRDK
         1tC5jAfWcJWHCyJcZwusJcjXsjQGYUuZR0h3N50K8oHTv61EjQiosFJUy5z5VB+w9B
         9AJLBQVIod68a3fiEjReJsvfhbpQHht3zMSDX5IQl/kDYITWDefB2rtCXYSqelVloD
         iwG7udPyynL1Z4kvogjIuHAgP8589NeFEWV4HzloKtyaPRsZc+o9cyjuUrqKEBl/nv
         YWe0wuoMVPplw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D018C395F4;
        Mon, 20 Mar 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: qcom/emac: Fix use after free bug in emac_remove
 due to  race condition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930401750.16850.14731742864962914143.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 09:20:17 +0000
References: <20230318080526.785457-1-zyytlz.wz@163.com>
In-Reply-To: <20230318080526.785457-1-zyytlz.wz@163.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     timur@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 16:05:26 +0800 you wrote:
> In emac_probe, &adpt->work_thread is bound with
> emac_work_thread. Then it will be started by timeout
> handler emac_tx_timeout or a IRQ handler emac_isr.
> 
> If we remove the driver which will call emac_remove
>   to make cleanup, there may be a unfinished work.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
    https://git.kernel.org/netdev/net/c/6b6bc5b8bd2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


