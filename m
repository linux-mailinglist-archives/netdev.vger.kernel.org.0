Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBBF36626F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhDTXUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhDTXUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 19:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B58E561416;
        Tue, 20 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618960809;
        bh=MxzzZRVeGbKy7RYE+UNgZqk0Q3rKbo9tlZi/SXYIvXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WoXSJ4h57f8DVpYk39HipFmzp0e6dvEMlRe37pRHAPAPq9/zByrPw48kin37bP9PK
         POnVqsY/dU5nOgsfaFSRE48RxvpU35W03RCCXlqF/f+eNcQL3R6E9j2HS1oFBfVKnM
         2XQ2hp/HxmFNL+vQHXw2lTVTLCuYH3ezzAps0xTiK5tG80geKrr6f7RaryrviE6tFZ
         mgJ0GhZZ7cQFwrKC87Nl8WZ7fdzqVDLlISQZkjhDRVHazZQ+T+dOS7diwHkRpDnW0d
         HhlTYZLTKzQg34zEAhMfnuoCwwMRml75LvWrQzpReYN9OUePDJ0CrH5jXhVe/BDSk9
         pNWLCjVvEMJzg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A986F60A39;
        Tue, 20 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896080968.18371.17948876307960710370.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:20:09 +0000
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arvid.Brodin@xdin.com,
        m-karicheri2@ti.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        yuehaibing@huawei.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, colin.king@canonical.com,
        po.liu@nxp.com, mingkai.hu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 18:25:30 +0800 you wrote:
> ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
> this:
> 	0: Guard band is implemented for nonschedule queues to schedule
> 	   queues transition.
> 	1: Guard band is implemented for any queue to schedule queue
> 	   transition.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: felix: disable always guard band bit for TAS config
    https://git.kernel.org/netdev/net-next/c/316bcffe4479

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


