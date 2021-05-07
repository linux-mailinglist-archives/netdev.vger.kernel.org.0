Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19E375DE6
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhEGAbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhEGAbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:31:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D27F461104;
        Fri,  7 May 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620347409;
        bh=Rczj60qhi8PBK4AeImJVWrLgfqCoPLgSKPFiuo86thY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VkfQQtu4woROneHl4uG/9NKDV1+RfoicZBd+FvkrZDz+ecOIQwJlKy0UMzdpCii/S
         EWu3OsMaIlXxHn9yCgx4otI8D8O1lImsGt0p3h9LUWLGWTeaLZtuSKbWjedevNzgGN
         3FCSHmovOzsXoj3jpgwtkcWU72ChCn78Y6cUH9v0fbya0NPPQfBbnYq5XnM9V5prGS
         3+j8PnhQiaE+8saID1BzDykFSID15eG34AWuaiSZjP7E6uoQYWbkIdTpSZIMVgUvKs
         +GSkHG96g4NnHrlkHesTDEs25aRt8N46ETDD2+V/99PGh14hKJgbw2bRy/nwpksJoi
         MKZtneBH8iC3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5A8D60A0C;
        Fri,  7 May 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: spectrum_mr: Update egress RIF list before route's
 action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162034740980.8278.5268232333255705073.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 00:30:09 +0000
References: <20210506072308.3834303-1-idosch@idosch.org>
In-Reply-To: <20210506072308.3834303-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  6 May 2021 10:23:08 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Each multicast route that is forwarding packets (as opposed to trapping
> them) points to a list of egress router interfaces (RIFs) through which
> packets are replicated.
> 
> A route's action can transition from trap to forward when a RIF is
> created for one of the route's egress virtual interfaces (eVIF). When
> this happens, the route's action is first updated and only later the
> list of egress RIFs is committed to the device.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: spectrum_mr: Update egress RIF list before route's action
    https://git.kernel.org/netdev/net/c/cbaf3f6af9c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


