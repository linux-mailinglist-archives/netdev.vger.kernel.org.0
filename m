Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5F548550B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbiAEOuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:50:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50066 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiAEOuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:50:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E330B81BA0;
        Wed,  5 Jan 2022 14:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C61FEC36AE0;
        Wed,  5 Jan 2022 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641394213;
        bh=pN/RE0xVNa4aRKN3Ws0Rg16Vg3PQx2IyZ71Bm5kofus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RYX4yg9WfvxvtERDiRJ9BODuqXgW7vqcDDoAmMK9LW3y1ZHN1neNpJEC7q1jT1+aC
         KaGjnDSQ1J7Hnd+4nk0Hnopmqrir9VK4UygWRbjmxyo0sVqnaoMlMhNuQlhSg3VNNB
         pDP9nVqz9Y7PTGCA2z+hCgHL9lQyjZ4l3b3W/12t/TnySH/ZVlvLHrMs5EpeVOQR4g
         latsElYXi4UnPvZvrb+lYpGM2Ntd8UzEVilk5yCI2EyDEUhtAR5FWgbg5Qzwo4mpgN
         Duv1l+ROJDCXeqwZsCLdO81IUuMHh0R6ChhCJKgD7hYtUe/jSyV7fPsqtTa7e0H7Rc
         tO98KCAY+yUHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD7DBF79405;
        Wed,  5 Jan 2022 14:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: hns3: refactor rss/tqp stats functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164139421370.3088.17438905795107862686.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 14:50:13 +0000
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 5 Jan 2022 22:20:00 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently, hns3 PF and VF module have two sets of rss and tqp stats APIs
> to provide get and set functions. Most of these APIs are the same. There is
> no need to keep these two sets of same functions for double development and
> bugfix work.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net: hns3: create new rss common structure hclge_comm_rss_cfg
    https://git.kernel.org/netdev/net-next/c/9667b814387c
  - [net-next,02/15] net: hns3: refactor hclge_comm_send function in PF/VF drivers
    https://git.kernel.org/netdev/net-next/c/9970308fe6a5
  - [net-next,03/15] net: hns3: create new set of common rss get APIs for PF and VF rss module
    https://git.kernel.org/netdev/net-next/c/1bfd6682e9b5
  - [net-next,04/15] net: hns3: refactor PF rss get APIs with new common rss get APIs
    https://git.kernel.org/netdev/net-next/c/7347255ea389
  - [net-next,05/15] net: hns3: refactor VF rss get APIs with new common rss get APIs
    https://git.kernel.org/netdev/net-next/c/027733b12a10
  - [net-next,06/15] net: hns3: create new set of common rss set APIs for PF and VF module
    https://git.kernel.org/netdev/net-next/c/6de060042867
  - [net-next,07/15] net: hns3: refactor PF rss set APIs with new common rss set APIs
    https://git.kernel.org/netdev/net-next/c/1813ee524331
  - [net-next,08/15] net: hns3: refactor VF rss set APIs with new common rss set APIs
    https://git.kernel.org/netdev/net-next/c/7428d6c93665
  - [net-next,09/15] net: hns3: create new set of common rss init APIs for PF and VF reuse
    https://git.kernel.org/netdev/net-next/c/2c0d3f4cd25f
  - [net-next,10/15] net: hns3: refactor PF rss init APIs with new common rss init APIs
    https://git.kernel.org/netdev/net-next/c/07dce03cd5aa
  - [net-next,11/15] net: hns3: refactor VF rss init APIs with new common rss init APIs
    https://git.kernel.org/netdev/net-next/c/93969dc14fcd
  - [net-next,12/15] net: hns3: create new set of common tqp stats APIs for PF and VF reuse
    https://git.kernel.org/netdev/net-next/c/287db5c40d15
  - [net-next,13/15] net: hns3: refactor PF tqp stats APIs with new common tqp stats APIs
    https://git.kernel.org/netdev/net-next/c/add7645c841c
  - [net-next,14/15] net: hns3: refactor VF tqp stats APIs with new common tqp stats APIs
    https://git.kernel.org/netdev/net-next/c/4afc310cf9a8
  - [net-next,15/15] net: hns3: create new common cmd code for PF and VF modules
    https://git.kernel.org/netdev/net-next/c/43710bfebf23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


