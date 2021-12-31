Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE1482454
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 15:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhLaOaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 09:30:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55318 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhLaOaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 09:30:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98EC3B81D84;
        Fri, 31 Dec 2021 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43DB1C36AED;
        Fri, 31 Dec 2021 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640961012;
        bh=Sr+gt3sQxx3oExzGj87a4PFUs+c9GT64LeKEKXlOQJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GCs4Z0vu6emLWLdZnmeud5TM+KZ6H0jWME1lyooM7PU+xquToRJYzA7uUrYomVFAN
         0AgB5k0H40cg+lhiZHoRAgMEeQ3DgQocNkwEAL5IODLBINraVmDRLtODrVSxHXbyqd
         GlZGUtXGs6BONby2Q9lTQS5YtasbeuwZgHxfuptfVqwhoMIhdpJwEr5KfrCWr+s203
         WZHL9FGbaFeYdHaDgpBJy/Xsdzro5YlgmjF980NVsUQ3jUyNpkEUloz9yQIrwjttfc
         U6YP4NkymbuYsdobTFQ/KNAAXFrTW5hxdhTxKGBnWFRE6nWKY/vfG9pY/zmP+TQ+m3
         em1hMIJQm458w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C182C395E5;
        Fri, 31 Dec 2021 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] net: hns3: refactor cmdq functions in PF/VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164096101217.30758.5735155346916783577.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 14:30:12 +0000
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
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

On Fri, 31 Dec 2021 18:22:30 +0800 you wrote:
> Currently, hns3 PF and VF module have two sets of cmdq APIs to provide
> cmdq message interaction functions. Most of these APIs are the same. The
> only differences are the function variables and names with pf and vf
> suffixes. These two sets of cmdq APIs are redundent and add extra bug fix
> work.
> 
> This series refactor the cmdq APIs in hns3 PF and VF by implementing one
> set of common cmdq APIs for PF and VF reuse and deleting the old APIs.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net: hns3: refactor hns3 makefile to support hns3_common module
    https://git.kernel.org/netdev/net-next/c/5f20be4e90e6
  - [net-next,02/13] net: hns3: create new cmdq hardware description structure hclge_comm_hw
    https://git.kernel.org/netdev/net-next/c/0a7b6d221868
  - [net-next,03/13] net: hns3: use struct hclge_desc to replace hclgevf_desc in VF cmdq module
    https://git.kernel.org/netdev/net-next/c/6befad603d79
  - [net-next,04/13] net: hns3: create new set of unified hclge_comm_cmd_send APIs
    https://git.kernel.org/netdev/net-next/c/8d307f8e8cf1
  - [net-next,05/13] net: hns3: refactor hclge_cmd_send with new hclge_comm_cmd_send API
    https://git.kernel.org/netdev/net-next/c/eaa5607db377
  - [net-next,06/13] net: hns3: refactor hclgevf_cmd_send with new hclge_comm_cmd_send API
    https://git.kernel.org/netdev/net-next/c/076bb537577f
  - [net-next,07/13] net: hns3: create common cmdq resource allocate/free/query APIs
    https://git.kernel.org/netdev/net-next/c/da77aef9cc58
  - [net-next,08/13] net: hns3: refactor PF cmdq resource APIs with new common APIs
    https://git.kernel.org/netdev/net-next/c/d3c69a8812c2
  - [net-next,09/13] net: hns3: refactor VF cmdq resource APIs with new common APIs
    https://git.kernel.org/netdev/net-next/c/745f0a19ee9a
  - [net-next,10/13] net: hns3: create common cmdq init and uninit APIs
    https://git.kernel.org/netdev/net-next/c/0b04224c1312
  - [net-next,11/13] net: hns3: refactor PF cmdq init and uninit APIs with new common APIs
    https://git.kernel.org/netdev/net-next/c/8e2288cad6cb
  - [net-next,12/13] net: hns3: refactor VF cmdq init and uninit APIs with new common APIs
    https://git.kernel.org/netdev/net-next/c/cb413bfa6e8b
  - [net-next,13/13] net: hns3: delete the hclge_cmd.c and hclgevf_cmd.c
    https://git.kernel.org/netdev/net-next/c/aab8d1c6a5e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


