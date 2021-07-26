Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B323D589D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhGZK7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233320AbhGZK7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2063A60F37;
        Mon, 26 Jul 2021 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299605;
        bh=P0VWAHD/zyJMSYph8fmllrZeBljhmPMnD2WdyZQDzVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cj75vVVCgLbldOp17oK9up57uAVKIk1j9crcWtXxhtl1tNwqcI0H16GT6t9e0Msgs
         XA6g+PMKQnJCZuE58w+bheb486DXwmfLypFPBa6v41ACd6tArUOieOjxms42JoSPEQ
         7x/iiHN0wqGsAEhZkrof1Ft3If6tJEuBBM1a9aAMgkuBkleIHWxLalls+VDvsbxGfS
         DKHARlwwZq2byDji15qsvCWds5+GSZMTZBGVkTsFbWY90vJvovMBKPTl5JcF2dobD/
         okzyjDx9Pbd9oEtjBjiXalwYVWSPm59Pn621sguxRr1rmZ1qQccc85V4Up126TwBMT
         9UKIKjAbSKTCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1447F60A12;
        Mon, 26 Jul 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] sctp: delete addr based on sin6_scope_id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729960507.898.16793961146197522908.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:40:05 +0000
References: <20210726054733.75937-1-peterchenshen@gmail.com>
In-Reply-To: <20210726054733.75937-1-peterchenshen@gmail.com>
To:     Chen Shen <peterchenshen@gmail.com>
Cc:     marcelo.leitner@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 26 Jul 2021 13:47:34 +0800 you wrote:
> sctp_inet6addr_event deletes 'addr' from 'local_addr_list' when setting
> netdev down, but it is possible to delete the incorrect entry (match
> the first one with the same ipaddr, but the different 'ifindex'), if
> there are some netdevs with the same 'local-link' ipaddr added already.
> It should delete the entry depending on 'sin6_addr' and 'sin6_scope_id'
> both. otherwise, the endpoint will call 'sctp_sf_ootb' if it can't find
> the according association when receives 'heartbeat', and finally will
> reply 'abort'.
> 
> [...]

Here is the summary with links:
  - [v2] sctp: delete addr based on sin6_scope_id
    https://git.kernel.org/netdev/net/c/2ebda0271483

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


