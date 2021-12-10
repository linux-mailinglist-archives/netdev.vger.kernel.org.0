Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0B846F98E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhLJDXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhLJDXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:23:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AB2C061746;
        Thu,  9 Dec 2021 19:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0BEACE25F6;
        Fri, 10 Dec 2021 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9CB0C341C6;
        Fri, 10 Dec 2021 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639106409;
        bh=iGl8XK1yTEhG4RHv2PkVIe3CNljYOpP9wCo92+Di1Nw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UIlmZa5VY/vSbg9RZtXZoQkwvDJRlkNbobyfVC8Mi2LuQlXOBqb1e0/rep299ThVn
         EtijZ5+/QvF/tScx0XRW3oALv7MknpIFKbgf1yFY7nM5bZhTY00ch/TLG67ugsLUVR
         sdXqBgPCTmbP0ZloAMBS7ZldjrG0aqay6Jfrim9BEeoRqVhuwClOzZ1/ao1k9es73o
         m30C1pfRdFmWuNNaZEpzWSp6Lufye4JJspESX90ucDT9AzJXoPkCcZxWkTqyjb3SUY
         yFMOzvwskvQTG7bkTsC7nKv/FgWXUkzMinh8gADEHi4ZsQP3UajZrSK0ZjQWneFs2X
         4kH32kQMsyrEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C07DC60A2F;
        Fri, 10 Dec 2021 03:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests: net: Correct ping6 expected rc from 2 to 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163910640878.13476.2519511898599945642.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 03:20:08 +0000
References: <20211209020230.37270-1-jie2x.zhou@intel.com>
In-Reply-To: <20211209020230.37270-1-jie2x.zhou@intel.com>
To:     Jie2x Zhou <jie2x.zhou@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkp@intel.com, xinjianx.ma@intel.com, zhijianx.li@intel.com,
        philip.li@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 10:02:30 +0800 you wrote:
> ./fcnal-test.sh -v -t ipv6_ping
> TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
> TEST: ping out, VRF bind - multicast IP                                       [FAIL]
> 
> ping6 is failing as it should.
> COMMAND: ip netns exec ns-A /bin/ping6 -c1 -w1 fe80::7c4c:bcff:fe66:a63a%red
> strace of ping6 shows it is failing with '1',
> so change the expected rc from 2 to 1.
> 
> [...]

Here is the summary with links:
  - [v3] selftests: net: Correct ping6 expected rc from 2 to 1
    https://git.kernel.org/netdev/net/c/92816e262980

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


