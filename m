Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55C029656E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370374AbgJVTkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370370AbgJVTkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:40:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603395603;
        bh=iqYBo5+IkxRNKRfqptMyNyOn0C51/Lu9nWmEqioFS/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8n882qYXtefUZqj4N1sMb2vjkQUNf6tzNZtkVLhphtcXvU+8oVBIYKjxcIdmWL3P
         3BlCWz8g5t9So9lBuW+f3L39QuGxbGeoJcwHGPFLWRDY24TjSghfZFBTy0qi4hO6tN
         q503t7WhlPfL2lptWoGdTnLY9W0Vg2FZaF6XBnBo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160339560383.3111.12245820773951059255.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Oct 2020 19:40:03 +0000
References: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
In-Reply-To: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ncardwell@google.com,
        apoikos@dmesg.gr, soheil@google.com, ycheng@google.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Oct 2020 10:33:31 -0400 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> In the header prediction fast path for a bulk data receiver, if no
> data is newly acknowledged then we do not call tcp_ack() and do not
> call tcp_ack_update_window(). This means that a bulk receiver that
> receives large amounts of data can have the incoming sequence numbers
> wrap, so that the check in tcp_may_update_window fails:
>    after(ack_seq, tp->snd_wl1)
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix to update snd_wl1 in bulk receiver fast path
    https://git.kernel.org/netdev/net/c/18ded910b589

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


