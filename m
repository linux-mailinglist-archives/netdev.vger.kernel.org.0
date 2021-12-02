Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D94662F3
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357536AbhLBMDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346568AbhLBMDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:03:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35668C06174A;
        Thu,  2 Dec 2021 04:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E43EB822AF;
        Thu,  2 Dec 2021 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22219C00446;
        Thu,  2 Dec 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638446411;
        bh=iLoDEAtQmP8J0BXugJet7pBORB6PTD8CsPM3Mb+2OW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SQiKccmfya2TcmR0QL+J30CqEzyzU8Rycl9xqVHJy5M1ET62GX0Ge6xL8CTvNurHH
         A1AOuqsAjl6EKj0veyhEdlgpxirR2tX/HqOGgg0Y+v2ZDj/syWOrBMEN2aNkMaw8cH
         g/dUAZmXYi9IiqMfjbDYNBqNxp+Sx5ko9NqWBRYRAUNzt7fOHsCQzRPb029kqjMR9T
         7om0YW2bXfa73YKQDYFhLIwMPYL0xymw7S5/LmyhJuaGZdBVVJasFAgDQ1s20zemtE
         QPoxhhMoUg7EQ+9ExFbq2Wyyc0sWpaNv82V/57FzQNm6ZHHcIU5DG2iyPtofd+DyLz
         zKjAyhUfW9UMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B5B860A50;
        Thu,  2 Dec 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: hns3: some cleanups for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844641104.32543.10004765077657533350.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:00:11 +0000
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
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

On Thu, 2 Dec 2021 16:35:54 +0800 you wrote:
> To improve code readability and simplicity, this series add 9 cleanup
> patches for the HNS3 ethernet driver.
> 
> Jian Shen (3):
>   net: hns3: split function hclge_init_vlan_config()
>   net: hns3: split function hclge_get_fd_rule_info()
>   net: hns3: split function hclge_update_port_base_vlan_cfg()
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: hns3: extract macro to simplify ring stats update code
    https://git.kernel.org/netdev/net-next/c/e6d72f6ac2ad
  - [net-next,2/9] net: hns3: refactor function hns3_fill_skb_desc to simplify code
    https://git.kernel.org/netdev/net-next/c/a1cfb24d011a
  - [net-next,3/9] net: hns3: split function hclge_init_vlan_config()
    https://git.kernel.org/netdev/net-next/c/b60f9d2ec479
  - [net-next,4/9] net: hns3: split function hclge_get_fd_rule_info()
    https://git.kernel.org/netdev/net-next/c/a41fb3961d8d
  - [net-next,5/9] net: hns3: split function hns3_nic_net_xmit()
    https://git.kernel.org/netdev/net-next/c/8d4b409bac57
  - [net-next,6/9] net: hns3: split function hclge_update_port_base_vlan_cfg()
    https://git.kernel.org/netdev/net-next/c/d25f5eddbe1a
  - [net-next,7/9] net: hns3: refactor function hclge_configure()
    https://git.kernel.org/netdev/net-next/c/673b35b6a5bf
  - [net-next,8/9] net: hns3: refactor function hclge_set_channels()
    https://git.kernel.org/netdev/net-next/c/358e3edb31d5
  - [net-next,9/9] net: hns3: refactor function hns3_get_vector_ring_chain()
    https://git.kernel.org/netdev/net-next/c/1b33341e3dc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


