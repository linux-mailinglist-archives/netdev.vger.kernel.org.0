Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9FC54F5A4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381860AbiFQKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381209AbiFQKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC5D62CD8;
        Fri, 17 Jun 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2C19B8299B;
        Fri, 17 Jun 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57AF1C3411D;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655462414;
        bh=SIXB8pddVz1MMGWlkLcLLpXBpuhXOlmh3rxuxpd7Tos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TXQHCHskqpRVv5nRKTmuoqzyjwrEo6ZkzURjP9bjvSBf8K3yiXflycBnoVVkdB4U6
         qupcAeExngDlpueR1MMYCAYShrJWOj3rqzkXd3Q3CdMQoNFo0coTWms9T7emAaOZDP
         5CjvDcOFElBzvyEoKLAreZLCtDXBuu2W54Bxd/drdRpkWIeFyoSc9NJOXgibt9Usuo
         uOErBxRg5bxhgVfAzVaojSlCnrZZZdrGJ6m8MXlT8RAqSMM/68+dTA/L0WLD8VGz6/
         Ofbjzg2DjuDdOPTsVOzjAPBiYELdPkTcOnomeCffeIZdWFhxK3QvFC1x5ZGOunLtKe
         C0gIoUgSiKH/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39273E7385E;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] hamradio: 6pack: fix array-index-out-of-bounds in
 decode_std_command()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546241422.18293.12311208765232374431.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:40:14 +0000
References: <1655458266-27879-1-git-send-email-xujia39@huawei.com>
In-Reply-To: <1655458266-27879-1-git-send-email-xujia39@huawei.com>
To:     Xu Jia <xujia39@huawei.com>
Cc:     linux-hams@vger.kernel.org, pabeni@redhat.com,
        ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 17 Jun 2022 17:31:06 +0800 you wrote:
> Hulk Robot reports incorrect sp->rx_count_cooked value in decode_std_command().
> This should be caused by the subtracting from sp->rx_count_cooked before.
> It seems that sp->rx_count_cooked value is changed to 0, which bypassed the
> previous judgment.
> 
> The situation is shown below:
> 
> [...]

Here is the summary with links:
  - [v2] hamradio: 6pack: fix array-index-out-of-bounds in decode_std_command()
    https://git.kernel.org/netdev/net/c/2b04495e21cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


