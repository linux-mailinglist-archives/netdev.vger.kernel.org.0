Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE931C44B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBOXVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhBOXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 96F3B64DE8;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431207;
        bh=SD75V/y9voJ5CNxkuaYTVt35uLCsovOwDRWQQpBYjME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P1PP2/legcpa8CeIjYBk30fTITlgXknYfVU2ocsUHyc8CFjqA/mx3Upr8NvgJxVW3
         J+uFF5MEaFQ4dUHqRCqqZFawTDsVC2yBoqQYXutSSSXBPkWj3V2J/oe+Dhyh0HKO5r
         +LynVhwnH/gsvUF/hnmY7vZmhbOQcK/CeMu93wPBmqitWdvkR6uSZBvZ89Sr2VL+Pi
         vxKc6L+3CPfNVp56pKBlk3BOR9bt3ATKQpl+slX89/BDacM9zWnxI4bOJEP/sF7PdP
         hWwJlgAj2PxSPDh5yaI+0tV1LR/vQUCehINIMq0/vyC9YWO6yMgaIAFQrHh8iMIBgr
         9BSILkGt1FafQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8321160977;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ibmvnic: serialize access to work queue on remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120753.10830.9122936757880903731.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:07 +0000
References: <20210213044250.960317-1-sukadev@linux.ibm.com>
In-Reply-To: <20210213044250.960317-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com, uwe@kleine-koenig.org, saeed@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Feb 2021 20:42:50 -0800 you wrote:
> The work queue is used to queue reset requests like CHANGE-PARAM or
> FAILOVER resets for the worker thread. When the adapter is being removed
> the adapter state is set to VNIC_REMOVING and the work queue is flushed
> so no new work is added. However the check for adapter being removed is
> racy in that the adapter can go into REMOVING state just after we check
> and we might end up adding work just as it is being flushed (or after).
> 
> [...]

Here is the summary with links:
  - [net,1/1] ibmvnic: serialize access to work queue on remove
    https://git.kernel.org/netdev/net/c/4a41c421f367

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


