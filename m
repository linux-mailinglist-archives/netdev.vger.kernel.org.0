Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124713B376B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhFXTw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhFXTw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B118E613EC;
        Thu, 24 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624564206;
        bh=PUnVxsCWU483KwCvP+CL1Z89OwyRYa5wUjo9iogzGyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4if1z9H106JuT+ODA61CYlXKfLF/9UU4t15TZv3khBUWndjS9Qmt+Zo9aFiI44F5
         Q5e9+RePvQVYjAsV8NcJ4T3zEzxvi3VW8kyCDSwIrKobYpyeyxyDl7tf72GB2MIfuA
         c1+9b8WoCjI8S3g+XpBGGXCyYZPGZx31DHoPIA33DfWX88V7cx8bm4KTcLZGjW1miU
         0yI2fnGfujOGkmfItr+bk6qftVHtPZCJXMQzDfLw/FJnoXQUFs2tGxtZ03bXAV1x6y
         FdSU4JvgRmCyzHeyA/D1Pi/xhJZ0qg5f48XL7+wNh0eFvbftCQ8nwVjSMES2o/qWmU
         zM/C9ToTIvptw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC35360978;
        Thu, 24 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/16] gve: Introduce DQO descriptor format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456420669.10881.9881078911405519833.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 19:50:06 +0000
References: <20210624180632.3659809-1-bcf@google.com>
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
To:     Bailey Forrest <bcf@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 11:06:16 -0700 you wrote:
> DQO is the descriptor format for our next generation virtual NIC. The existing
> descriptor format will be referred to as "GQI" in the patch set.
> 
> One major change with DQO is it uses dual descriptor rings for both TX and RX
> queues.
> 
> The TX path uses a TX queue to send descriptors to HW, and receives packet
> completion events on a TX completion queue.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] gve: Update GVE documentation to describe DQO
    https://git.kernel.org/netdev/net-next/c/c6a7ed77ee63
  - [net-next,02/16] gve: Move some static functions to a common file
    https://git.kernel.org/netdev/net-next/c/dbdaa6754051
  - [net-next,03/16] gve: gve_rx_copy: Move padding to an argument
    https://git.kernel.org/netdev/net-next/c/35f9b2f43f8e
  - [net-next,04/16] gve: Make gve_rx_slot_page_info.page_offset an absolute offset
    https://git.kernel.org/netdev/net-next/c/920fb4519355
  - [net-next,05/16] gve: Introduce a new model for device options
    https://git.kernel.org/netdev/net-next/c/8a39d3e0dadf
  - [net-next,06/16] gve: Introduce per netdev `enum gve_queue_format`
    https://git.kernel.org/netdev/net-next/c/a5886ef4f4bf
  - [net-next,07/16] gve: adminq: DQO specific device descriptor logic
    https://git.kernel.org/netdev/net-next/c/5ca2265eefc0
  - [net-next,08/16] gve: Add support for DQO RX PTYPE map
    https://git.kernel.org/netdev/net-next/c/c4b87ac87635
  - [net-next,09/16] gve: Add dqo descriptors
    https://git.kernel.org/netdev/net-next/c/223198183ff1
  - [net-next,10/16] gve: Add DQO fields for core data structures
    https://git.kernel.org/netdev/net-next/c/a4aa1f1e69df
  - [net-next,11/16] gve: Update adminq commands to support DQO queues
    https://git.kernel.org/netdev/net-next/c/1f6228e459f8
  - [net-next,12/16] gve: DQO: Add core netdev features
    https://git.kernel.org/netdev/net-next/c/5e8c5adf95f8
  - [net-next,13/16] gve: DQO: Add ring allocation and initialization
    https://git.kernel.org/netdev/net-next/c/9c1a59a2f4bc
  - [net-next,14/16] gve: DQO: Configure interrupts on device up
    https://git.kernel.org/netdev/net-next/c/0dcc144a7994
  - [net-next,15/16] gve: DQO: Add TX path
    https://git.kernel.org/netdev/net-next/c/a57e5de476be
  - [net-next,16/16] gve: DQO: Add RX path
    https://git.kernel.org/netdev/net-next/c/9b8dd5e5ea48

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


