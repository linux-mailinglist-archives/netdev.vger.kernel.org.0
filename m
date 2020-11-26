Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8172C4D67
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 03:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgKZCUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 21:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732808AbgKZCUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 21:20:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606357206;
        bh=vUonO1JUYWnab4rWYaoIY71/ExjFENMep+MRQRgbJos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eOwnexQ5z67uT9nat+aklEmZSnv1xZRb2d05Vd6s12vIKMKzkwzZgy4XtQgKzB0bo
         gmGD4kvDwNVUq8pHU6DYAD0OMEh3SKbDU9R6l+RxUUZlE8gaOS6dYk2H0s7JC7D4vq
         sPGbvmAm58RqGD5JmGajyqE0cXR4VDZztohV4/78=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 0/3][pull request] 40GbE Intel Wired LAN Driver Updates
 2020-11-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635720619.6662.10189294280132606321.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 02:20:06 +0000
References: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Nov 2020 08:52:42 -0800 you wrote:
> This series contains updates to i40e and igbvf drivers.
> 
> Marek removes a redundant assignment for i40e.
> 
> Stefan Assmann corrects reporting of VF link speed for i40e.
> 
> Karen revises a couple of error messages to warnings for igbvf as they
> could be misinterpreted as issues when they are not.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] i40e: remove redundant assignment
    https://git.kernel.org/netdev/net-next/c/088d5360d05a
  - [net-next,v2,2/3] i40e: report correct VF link speed when link state is set to enable
    https://git.kernel.org/netdev/net-next/c/6ec12e1e9404
  - [net-next,v2,3/3] igbvf: Refactor traces
    https://git.kernel.org/netdev/net-next/c/24453a84285e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


