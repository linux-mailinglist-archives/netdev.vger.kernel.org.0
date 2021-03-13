Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9E339AFA
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhCMCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhCMCAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 21:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 218E864F21;
        Sat, 13 Mar 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615600808;
        bh=mRv6GpTo0U08/ZOaexLh4Vow3+bwIght+t81PFlFIRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dejatdrckqmQH1DlfwrGqxo2SK3JWn/THEMeddVDKnLV6jvf2aYL2lD5jf0oI02pX
         sO/RWrdVzgvKkDKRzAXtqmEQbC3+ymzHA90VC7kJP+6eJ8CsK3+iG8Z/TjEeVer4+a
         YA+CDSRUW0FdiTpjBDpMwpwB+HRGn51U/3Eg2JIZ5J7jqd/Fxpp31WiVFh06JRak2Q
         Tr0hb75xlXymLN/aQChwTnGGisIyZZ2l6/uQMIb+b0NLGL/9p9Wlb7Z8YzWDchHF0V
         bn4p6/SGBGO25ausKZRjfNRyQXbYT9h0wcB6U6clD31+dnE+Isx5/fNPljwg67uWne
         g1ZEVQ+Ikgqng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12FC960A2D;
        Sat, 13 Mar 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: update MAINTAINERS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161560080807.26528.9084118472724058535.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 02:00:08 +0000
References: <20210312184530.14962-1-ljp@linux.ibm.com>
In-Reply-To: <20210312184530.14962-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 12:45:30 -0600 you wrote:
> Tom wrote most of the driver code and his experience is valuable to us.
> Add him as a Reviewer so that patches will be Cc'ed and reviewed by him.
> 
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] ibmvnic: update MAINTAINERS
    https://git.kernel.org/netdev/net/c/6afa455e6153

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


