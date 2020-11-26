Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FFE2C4CE9
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgKZBuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKZBuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:50:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606355405;
        bh=iYhxrss7MhMiYqNNS9B2cjjil5+XFkJFPsQg4U9/vXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n4mtTV62O+xtX6YkHUjmqXCtmnKJaQB5cCf9WZtUG+VadpHcvehgTlUCO03k3fRlp
         dQEmnjtimWR8IYfP0Dbap9tQ9I/sPjd3w94jifUbeswHfb1mhmsvcNwwXez9xmared
         3Fh6OeGZ+RnQN6/KYrCVpdLfAqcZA4wjPEjesBuA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2] ch_ktls: lock is not freed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635540561.25105.4046390358781889028.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 01:50:05 +0000
References: <20201125072626.10861-1-rohitm@chelsio.com>
In-Reply-To: <20201125072626.10861-1-rohitm@chelsio.com>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        secdev@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Nov 2020 12:56:26 +0530 you wrote:
> Currently lock gets freed only if timeout expires, but missed a
> case when HW returns failure and goes for cleanup.
> 
> Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net,v2] ch_ktls: lock is not freed
    https://git.kernel.org/netdev/net/c/cbf3d60329c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


