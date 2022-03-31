Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5634ED773
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiCaKCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbiCaKB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:01:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A24B40D;
        Thu, 31 Mar 2022 03:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCE260C00;
        Thu, 31 Mar 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CDC8C340F0;
        Thu, 31 Mar 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648720812;
        bh=7kivzHxJk+qKjtFYXZJ8B+or+rJ8QAVywzC1Iby4eGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WrfME0wPF93aWuh8JdbMyI887S83j92nsTgG24LX+ghOb/oWI7ZatNo1KCBlSy3mD
         UqHQhqNa9aNKeMN2pYQ/LIfxKoZKHJBqI2pJ3sfBpYBU12bCGecC16UT73CkYvmcwJ
         LkdIb//Xu6CUOY1HvsTeP7x3eiNxhBytG+JAr5O+4KVBMGcOA7WPhXUjSWUrQVDq2M
         mh9lt5pE5X6nz4iWj8lS6LuREeMgFTVsLi0VRNwHS7PWDu07Osfqhaf+q8VghItY7J
         72gijBct9wc3rPiaAMzZTEUfsbr48b0/YenvpNytx3aUlDKsffHFQjz8GUF4uhu0y8
         RhXs8uPj/vdpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A214E7BB0B;
        Thu, 31 Mar 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: hns3: add two fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164872081203.6232.16343309944190309712.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 10:00:12 +0000
References: <20220330134506.36635-1-huangguangbin2@huawei.com>
In-Reply-To: <20220330134506.36635-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
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

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 30 Mar 2022 21:45:04 +0800 you wrote:
> This series adds two fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (1):
>   net: hns3: fix software vlan talbe of vlan 0 inconsistent with
>     hardware
> 
> Yufeng Mo (1):
>   net: hns3: fix the concurrency between functions reading debugfs
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: hns3: fix the concurrency between functions reading debugfs
    https://git.kernel.org/netdev/net/c/9c9a04212fa3
  - [net,2/2] net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware
    https://git.kernel.org/netdev/net/c/7ed258f12ec5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


