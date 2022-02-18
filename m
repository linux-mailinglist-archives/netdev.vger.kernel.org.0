Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698714BB8A8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiBRLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:50:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiBRLu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:50:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85151AF6E2;
        Fri, 18 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AF161F58;
        Fri, 18 Feb 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2CD4C340F4;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645185011;
        bh=uT0a9HHWU3CmmVpUMs8x8cfAZ+FhPOK3gjiwhKHX5+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bS6gjKVs9jxVtDJ8i4bDpaoyWW3uXdBj5rta2AM/QxONcTcbFFSV8IUYuiOlMiyaY
         dJOVvD8rKJFaNmDMr/3W5EAxC9pJn/DnjJFD3gmV2AHdCjmgS8JMHDN5ikTvxCjwox
         T/K2+uMplyYR3Sd6qPMDAPoAoRIw2YgD1iM6P2Vk2mcSZgxylHQ0FkleRANoGQyOvs
         O+zQRcPbgbDl1nvrxYytxsevV4DPCerx5ZJNkUOVE8TNdyUwsfLlYllbHsJ0XJ37P+
         ulNW5yokgIMZx7VrETCC2Ag2qtoBeWoBntQ2dTSeMGdOaXtio4uaidFEFcPRXH1ZSV
         4J6+if9HlzUHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA050E7BB18;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: xilinx: cleanup comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518501168.13243.15064451451122227183.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:50:11 +0000
References: <20220217160518.3255003-1-trix@redhat.com>
In-Reply-To: <20220217160518.3255003-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, rdunlap@infradead.org,
        esben@geanix.com, arnd@arndb.de, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moyufeng@huawei.com, michael@walle.cc,
        yuehaibing@huawei.com, prabhakar.mahadev-lad.rj@bp.renesas.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 08:05:18 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'the'.
> Replacements:
> endiannes to endianness
> areconnected to are connected
> Mamagement to Management
> undoccumented to undocumented
> Xilink to Xilinx
> strucutre to structure
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: xilinx: cleanup comments
    https://git.kernel.org/netdev/net-next/c/8aba73ef44eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


