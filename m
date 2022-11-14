Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724BB627C7B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiKNLkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbiKNLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:40:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089AFB1F3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992076105A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8661C433B5;
        Mon, 14 Nov 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668426015;
        bh=aLOGfpyvHxq3pX1IhNYNc8g51IGUhvud+aIgBaW6pFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BnUwkle9O69ZJsqyQlK/z52ngO52RZYSN0zBvndfdcxXpP7cZRigCr+aVusYzRpbR
         UqIsidu2l3xfhButtCDSVdVh1qzbuVmFIpDjPpn3YpcUPZkv9dO7YcZBYly5NUdjgh
         85iM8vMoYPnL6nRjWfV1NAHhvlAQ6ldmHveMuyRP0q0NSCB3fXjHjsr5Zxf6rFprC7
         lrLPB2bb07/narBqvMXZygJS9FHHHmk7K8r3bC7KOVfDpP0D7YFYnAj0B0RFfVUqcx
         VeJdbnrjf8QuRz3slg1M8SwPYMTxiAuZ51AGUyw23exRvpaf1atgeoYM1+cP+WhuW7
         jjdGDreyE7UGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8492C395FE;
        Mon, 14 Nov 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: make dsa_master_ioctl() see through
 port_hwtstamp_get() shims
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842601481.5995.3824589653645673368.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:40:14 +0000
References: <20221111211020.543540-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221111211020.543540-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, festevam@gmail.com,
        steffen@innosonix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Nov 2022 23:10:20 +0200 you wrote:
> There are multi-generational drivers like mv88e6xxx which have code like
> this:
> 
> int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
> 				struct ifreq *ifr)
> {
> 	if (!chip->info->ptp_support)
> 		return -EOPNOTSUPP;
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
    https://git.kernel.org/netdev/net/c/ed1fe1bebe18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


