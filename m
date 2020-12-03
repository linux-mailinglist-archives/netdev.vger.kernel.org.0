Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D750C2CDEAF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgLCTUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgLCTUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607023206;
        bh=sWFFODPd40zBnNhZr/NzmUgo3XAp3HPfNsDpEkPKUs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jKvfwRKoGTjgsKdJbEPHbuyAe0oPu2IaQ01SZTqPPFOS+755bsnrWAzqs9T6kdIYT
         xqvjp8S0wMtNzpxn0tmHeRN+zNYNJrZP8kIQ40fovCntKM6SEo065BkH+PH24Fe9Pr
         eqC9tEmlT9EN0vp0H8cdqAXvco9E9p1cyBAjrJ5A+jffvjdKO/zE93QcsQYivkEakU
         D++VgyMnhABlvCxFE8PNhFxeYXloH8WUaxzgUixcuZjXlhed8MVcJE6aYwSBql11CC
         AtWJ/ICocX9+DZRgHErZ2hu1Kh70F5lxDtXsTdmEfkQ2kovWHD8ySV2WwAvGPGw/m2
         Wou6lmXV9KtrA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: act_mpls: ensure LSE is pullable before
 reading it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160702320644.13599.7452057402463120880.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 19:20:06 +0000
References: <3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com>
In-Reply-To: <3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, gnault@redhat.com,
        marcelo.leitner@gmail.com, john.hurley@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Dec 2020 10:37:52 +0100 you wrote:
> when 'act_mpls' is used to mangle the LSE, the current value is read from
> the packet dereferencing 4 bytes at mpls_hdr(): ensure that the label is
> contained in the skb "linear" area.
> 
> Found by code inspection.
> 
> v2:
>  - use MPLS_HLEN instead of sizeof(new_lse), thanks to Jakub Kicinski
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: act_mpls: ensure LSE is pullable before reading it
    https://git.kernel.org/netdev/net/c/9608fa653059

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


