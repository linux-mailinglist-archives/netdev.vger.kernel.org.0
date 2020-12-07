Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB172D1A50
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgLGUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbgLGUKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:10:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607371806;
        bh=nJTP6EQsueA3f7YM+95b/pAFQEHo1paIa0ajVRqKlbY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mkyHc3o/hhE2Git8OEsSwaNTIWqhQk/MKE+EZdneAdLPSsdjgxkxh8HsE8wUcyPip
         uDj/BOVQEDVYalvS023D4zH6cwP8VaydnhlSXueCZCySBo0C7ioDP01imKjz0JdU6X
         cXsVUJDmZl6stgP6AoRsuFcOgila/Yod6d2tCV8js/2m/i9dC1tiktNjWbbuygpr0J
         VIG5SOhrWx5u8qnVjyM1HXU5JPtEMfU6ubZ0VbII2FBLaj4art2/de/Qe3WGaDogQ6
         pz0LslBsDWR4xGGYdqxX7rzdkUprvVZCKSvMcQmonPV1je5jCJbCv6lbRcQduxaM+i
         JmOaUerDkdLUQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2 1/2] lwt: disable BH too in run_lwt_bpf()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160737180679.4672.12480079818853490607.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Dec 2020 20:10:06 +0000
References: <20201205075946.497763-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201205075946.497763-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        wangdongdong.6@bytedance.com, tgraf@suug.ch,
        alexei.starovoitov@gmail.com, cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Fri,  4 Dec 2020 23:59:45 -0800 you wrote:
> From: Dongdong Wang <wangdongdong.6@bytedance.com>
> 
> The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> and BPF redirect helpers. Callers on RX path are all in BH context,
> disabling preemption is not sufficient to prevent BH interruption.
> 
> In production, we observed strange packet drops because of the race
> condition between LWT xmit and TC ingress, and we verified this issue
> is fixed after we disable BH.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] lwt: disable BH too in run_lwt_bpf()
    https://git.kernel.org/bpf/bpf/c/d9054a1ff585
  - [net,v2,2/2] lwt_bpf: replace preempt_disable() with migrate_disable()
    https://git.kernel.org/bpf/bpf/c/e3366884b383

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


