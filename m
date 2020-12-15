Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1B2DA5EE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgLOCB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgLOCAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607997608;
        bh=fXFFllEAKOMgoTnpJVYTId/ziDzVTmSoFEQXhGG3OBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WV27/sOI1gUggbGXSmDn1fEdNeRXoeKE1cFR2k9tp2of1YpuLL93fyP8KyCglmFWl
         dsfWW3yEklYEjZM0BO/TTKUx4l0JHAEE8xrGicWzaRAymHfMd2qVcbXEBBuvZ1ATZh
         Rgtojp3mX0mii0tjNsTv1z95EHJxEdhWO4Qn9mgiPpT8bKB23fYT623y+ROquFlkVC
         fjS7GUbgBL3cogv//TzgMl7+NaZCfUV0pRp51SgQW987SvJrjJiX5jiqi5o0CVQfRd
         SevPnU7nrtTkryj3J7V0O1Hi0SGUCLkRocJqp4q3W5owW58THC4bWW94Ilwz8+KjFC
         KhyEMfb7pDVYQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ice, xsk: Move Rx allocation out of while-loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799760821.15807.11906942397903153665.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 02:00:08 +0000
References: <20201211085410.59350-1-bjorn.topel@gmail.com>
In-Reply-To: <20201211085410.59350-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     intel-wired-lan@lists.osuosl.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 09:54:10 +0100 you wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Instead doing the check for allocation in each loop, move it outside
> the while loop and do it every NAPI loop.
> 
> This change boosts the xdpsock rxdrop scenario with 15% more
> packets-per-second.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ice, xsk: Move Rx allocation out of while-loop
    https://git.kernel.org/netdev/net-next/c/5bb0c4b5eb61

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


