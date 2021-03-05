Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E5132EFBE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCEQKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 11:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhCEQKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 11:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AC5656508B;
        Fri,  5 Mar 2021 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614960607;
        bh=cya22JfrspAfOLhzVTAcXgkybIBj1zeKDgQ/diMlcPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=StylbA9vBFcMiT9UWo+VKbhNbI7boaUv+V1WRgFm/S/g82KCCtYg3MjqXPUL4SqZo
         tGqVPSwHsFvQ/Ju+aeBVxwdh4VobtFrn8ZOcvC7PqUXaT30lcqZ66Sn6Wq/qQMuHXk
         +RqbtVjgVTvaNZe514vMgtSjTtF2rb22AwlB/xkZ7NEasyrJvwcunoBG/rH9XzPOAS
         QpLg9qMZTqqSuUxiU9doX2MMH6n2b4qGbmVl3COdX0nRi/CW2HBY6BSc0R4LeUQBJw
         B0JcdJW94iT96whl6nJB93UuHgT0gmVRRQFnyLD2dviJWfRD85b/lpYCxfAWIc1ooa
         QBXhYwTGUNrpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A01E2609D4;
        Fri,  5 Mar 2021 16:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH/v5] bpf: add bpf_skb_adjust_room flag
 BPF_F_ADJ_ROOM_ENCAP_L2_ETH
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161496060765.19509.6156916149397117488.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 16:10:07 +0000
References: <20210304064046.6232-1-hxseverything@gmail.com>
In-Reply-To: <20210304064046.6232-1-hxseverything@gmail.com>
To:     Xuesen Huang <hxseverything@gmail.com>
Cc:     daniel@iogearbox.net, davem@davemloft.net, bpf@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        huangxuesen@kuaishou.com, willemb@google.com,
        chengzhiyong@kuaishou.com, wangli09@kuaishou.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu,  4 Mar 2021 14:40:46 +0800 you wrote:
> From: Xuesen Huang <huangxuesen@kuaishou.com>
> 
> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
> encapsulation. But that is not appropriate when pushing Ethernet header.
> 
> Add an option to further specify encap L2 type and set the inner_protocol
> as ETH_P_TEB.
> 
> [...]

Here is the summary with links:
  - [PATCH/v5] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
    https://git.kernel.org/bpf/bpf-next/c/d01b59c9ae94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


