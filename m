Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5748483013
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiACKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiACKuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A7EC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 02:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16CD4B80EAA
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 10:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A01D5C36AF5;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641207009;
        bh=yI4ytjiTIxjurRrGSiGbFKMVgbN5+KsD2BvwGJjge+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PGq/8TiGM9b0MGlIRSWW3zd6VpvnmNr90NsxKOlRKgjdHdLfy9HNG8SI3b9qnANFP
         2HgsS8PQPqPoQCy5phlT4x1xU0u8O0eT+iwEU8LB41N9yuXkiITQM6rghL5jacrTIo
         L6XbI5V/RHGJz+t2cgSH1YB8OxNu6RKv6myHOWx339g26cVNQdBv7O+g/Tuq9BwuWY
         3yC5eiX1olcpANuidJdKYykIaUn8DG92h6sNwVDDZj9yFKISxNAcGOvJyanwojK+7u
         mrrTIEaJB1DP5AwRoLszDbBHDC0k9LWIEKwrPbLchWMBuAYhU7YEq1mjVQ+sA0zrfH
         qECVsX82lYskg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A2E9F79405;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: vertexcom: default to disabled on kbuild
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164120700956.2591.9697479878144142561.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Jan 2022 10:50:09 +0000
References: <20220102221126.354332-1-saeed@kernel.org>
In-Reply-To: <20220102221126.354332-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, stefan.wahren@i2se.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 14:11:26 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Sorry for being rude but new vendors/drivers are supposed to be disabled
> by default, otherwise we will have to manually keep track of all vendors
> we are not interested in building.
> 
> Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
> CC: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: vertexcom: default to disabled on kbuild
    https://git.kernel.org/netdev/net-next/c/6bf950a8ff72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


