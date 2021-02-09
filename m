Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C11C315AB1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhBJAIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:08:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234578AbhBIXuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:50:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D404D64E3F;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612914611;
        bh=ZogekR3sXxcI7rBdn29vOHqSQf9fCp9xjF6CmtxoaDc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gzC6MyUn9P6uyGycUiG8hX2+t7jtP8EyRZyk0x+DcjJfK4LohbjQS1lEICqVXJxIl
         DRCTVpMMOLs+DneJ+Hyws7ksrRnXWFKQMArc4CMLjug2BJqnGW/JgHxisEY41rL8E0
         Zch1yut7vgX8LCF+h1KM++Jc4cvh1aGHLI459d1BOBQTXpmtA77XFNt75bvKPoCpP7
         W7EZTttPfffWoHLzSecTUjbGqN35aTNlBDqPw7reU9SXZBL9KnxkONrTM4ZoeCZP1Q
         woZeZluT9osV7O8DBdHF/KrVARWH9EfceBVqhAhE1qCeH123KcrTo77lbN3AGIW8l2
         1KzMX1U7L0BmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2693609E9;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 00/11] net: hns3: some cleanups for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291461179.1297.16553644669935139476.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:50:11 +0000
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 9 Feb 2021 10:41:50 +0800 you wrote:
> There are some cleanups for the HNS3 ethernet driver.
> 
> change log:
> V2: remove previous #3 which should target net.
> 
> previous version:
> V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612784382-27262-1-git-send-email-tanhuazhong@huawei.com/
> 
> [...]

Here is the summary with links:
  - [V2,net-next,01/11] net: hns3: clean up some incorrect variable types in hclge_dbg_dump_tm_map()
    https://git.kernel.org/netdev/net-next/c/0256844d0f32
  - [V2,net-next,02/11] net: hns3: remove redundant client_setup_tc handle
    https://git.kernel.org/netdev/net-next/c/ae9e492a3664
  - [V2,net-next,03/11] net: hns3: remove the shaper param magic number
    https://git.kernel.org/netdev/net-next/c/9d2a1cea6997
  - [V2,net-next,04/11] net: hns3: clean up unnecessary parentheses in macro definitions
    https://git.kernel.org/netdev/net-next/c/9393eb5034a0
  - [V2,net-next,05/11] net: hns3: modify some unmacthed types print parameter
    https://git.kernel.org/netdev/net-next/c/c5aaf1761883
  - [V2,net-next,06/11] net: hns3: change hclge_parse_speed() param type
    https://git.kernel.org/netdev/net-next/c/6e7f109ee9d8
  - [V2,net-next,07/11] net: hns3: change hclge_query_bd_num() param type
    https://git.kernel.org/netdev/net-next/c/cad8dfe82a9e
  - [V2,net-next,08/11] net: hns3: remove redundant return value of hns3_uninit_all_ring()
    https://git.kernel.org/netdev/net-next/c/64749c9c38a9
  - [V2,net-next,09/11] net: hns3: remove an unused parameter in hclge_vf_rate_param_check()
    https://git.kernel.org/netdev/net-next/c/11ef971f5a6a
  - [V2,net-next,10/11] net: hns3: remove unused macro definition
    https://git.kernel.org/netdev/net-next/c/7ceb40b8207e
  - [V2,net-next,11/11] net: hns3: cleanup for endian issue for VF RSS
    https://git.kernel.org/netdev/net-next/c/55ff3ed57b50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


