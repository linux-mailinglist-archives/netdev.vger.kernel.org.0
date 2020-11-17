Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E32B55C7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgKQAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbgKQAkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605573605;
        bh=zMQW2Ot90G2WINtuptuKiyco9CER8ScYxej0iBWIMP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIbpUGMyYA84DHSLfUMFTAMP1qAxOkVUchdjYnCAxGSJrbyx5YEt5T+Pw3RAeULB6
         4SWSrw4e5ceB93n78tsb42v7aBsCfXGxhYnpK/ekHYYQy9xSsronq0bFgWCI3JHkB/
         XwIVqRVhjQ7gNbtRwcFaYXei5lGNbUTdO2BwPDTk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvneta: fix possible memory leak in
 mvneta_swbm_add_rx_fragment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557360530.10137.9059888755046904016.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 00:40:05 +0000
References: <df6a2bad70323ee58d3901491ada31c1ca2a40b9.1605291228.git.lorenzo@kernel.org>
In-Reply-To: <df6a2bad70323ee58d3901491ada31c1ca2a40b9.1605291228.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, echaudro@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 19:16:57 +0100 you wrote:
> Recycle the page running page_pool_put_full_page() in
> mvneta_swbm_add_rx_fragment routine when the last descriptor
> contains just the FCS or if the received packet contains more than
> MAX_SKB_FRAGS fragments
> 
> Fixes: ca0e014609f0 ("net: mvneta: move skb build after descriptors processing")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment
    https://git.kernel.org/netdev/net/c/9c79a8ab5f12

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


