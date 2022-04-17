Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AFB5047BE
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiDQMmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiDQMmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A013222529;
        Sun, 17 Apr 2022 05:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 266A2611DA;
        Sun, 17 Apr 2022 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 855E7C385A8;
        Sun, 17 Apr 2022 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650199214;
        bh=8aesVbcwycKDFh52PyLuSVq0ROPJJkJWbNquk46DqO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X/t+pF7h9sGAh5J94WA2K0Pd5E+qAmLmwVv/xJgVi0fNwLwjkm/t9IaRUuXb6lSbY
         xg5iqFZ4OGlrC7lE5ikB8qpSjbAfB+zxc077r3P4nRfSPK6VmxQHdWV+bU3t+W7r36
         R0y8xKiJFufUdWZcMA7tyP4n/+J5LCpeWGhUV5DQGDnhazI1MSp4R0eE2axT7HZbmu
         I+0cJNpC7w1UDxtksKO6Pm2RFlSZNBOlvh6tmVlayN1UWNXOenWrET+06dszlGZwIz
         uNxHckzfJ40FF/im79Tat2PPUKaZaEW2MioeHjBKw1l+UKWlXgNWnB1xLmG0dP3kIV
         yM1Z5PYAH2BJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D96FE7399D;
        Sun, 17 Apr 2022 12:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/6] Reduce qca8k_priv space usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165019921444.7317.254288819022934334.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Apr 2022 12:40:14 +0000
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Apr 2022 01:30:11 +0200 you wrote:
> These 6 patch is a first attempt at reducting qca8k_priv space.
> The code changed a lot during times and we have many old logic
> that can be replaced with new implementation
> 
> The first patch drop the tracking of MTU. We mimic what was done
> for mtk and we change MTU only when CPU port is changed.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] net: dsa: qca8k: drop MTU tracking from qca8k_priv
    https://git.kernel.org/netdev/net-next/c/69fd055957a0
  - [net-next,v3,2/6] net: dsa: qca8k: drop port_sts from qca8k_priv
    https://git.kernel.org/netdev/net-next/c/2b8fd87af7f1
  - [net-next,v3,3/6] net: dsa: qca8k: rework and simplify mdiobus logic
    https://git.kernel.org/netdev/net-next/c/8255212e4130
  - [net-next,v3,4/6] net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
    https://git.kernel.org/netdev/net-next/c/2349b83a2486
  - [net-next,v3,5/6] net: dsa: qca8k: correctly handle mdio read error
    https://git.kernel.org/netdev/net-next/c/6cfc03b60220
  - [net-next,v3,6/6] net: dsa: qca8k: unify bus id naming with legacy and OF mdio bus
    https://git.kernel.org/netdev/net-next/c/8d1af50842bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


