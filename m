Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2C2B6E21
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgKQTKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgKQTKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605640205;
        bh=acmAXNzdehpZ/k966AnlavEHpEjzwTOg2MNMiir8XgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q1VFJIWG8t+jpjeINuVaGFexcYrqkSq4Ye83sdzbEgUwJ0/haQSvM6NX2JrfujGcw
         VZUb55sceWCB+aHl3H5IeyeDaP+JUZrS+okKnNoUV4kXrMTemMx+C4PLZ2/L/qAHj6
         LPQ7o5GQ2afmvc7MDOapKyqfN6vzaNh0FTb/CsZI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: only postpone PROBE_RTT if RTT is < current min_rtt
 estimate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160564020504.18685.6007226279853595659.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 19:10:05 +0000
References: <20201116174412.1433277-1-sharpelletti.kdev@gmail.com>
In-Reply-To: <20201116174412.1433277-1-sharpelletti.kdev@gmail.com>
To:     Ryan Sharpelletti <sharpelletti.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        sharpelletti@google.com, ncardwell@google.com, soheil@google.com,
        ycheng@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 17:44:13 +0000 you wrote:
> From: Ryan Sharpelletti <sharpelletti@google.com>
> 
> During loss recovery, retransmitted packets are forced to use TCP
> timestamps to calculate the RTT samples, which have a millisecond
> granularity. BBR is designed using a microsecond granularity. As a
> result, multiple RTT samples could be truncated to the same RTT value
> during loss recovery. This is problematic, as BBR will not enter
> PROBE_RTT if the RTT sample is <= the current min_rtt sample, meaning
> that if there are persistent losses, PROBE_RTT will constantly be
> pushed off and potentially never re-entered. This patch makes sure
> that BBR enters PROBE_RTT by checking if RTT sample is < the current
> min_rtt sample, rather than <=.
> 
> [...]

Here is the summary with links:
  - [net] tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate
    https://git.kernel.org/netdev/net/c/1b9e2a8c99a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


