Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003094A8C8E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiBCTiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:38:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44304 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbiBCTiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:38:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12081B81C86;
        Thu,  3 Feb 2022 19:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4DFC340E8;
        Thu,  3 Feb 2022 19:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643917088;
        bh=lh8mYJkUWr6+UkJwy4ib37AeqmVpc5lHQObJ6QE8z2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzI/9r6/7p/ySM1daEi5YIavwBn1cO2dWqs2PdpgBpDyO495FgcdjzD9N0CwQFO9b
         FpYeUukuw4K/A/mRKFWK+Lx4yXm7L+J0q0kn8Txb83OG6qx8kJzWK/PCE5h0FmnJM4
         ocHGDsyCbf9Iyhyfb/y1W0yCFeDL4M5MgEeRaa9A+QfRlLc6N8iHzu8wcQO52/EEIu
         pkPL1qhg7+p60P0y0q0uvqZmpA/3fWS8cgtbJmF3UaepXdTf2wP9vq7KJhe2Ad1DVv
         TUpbpAQeueGKqfa3cBk28qLkyvMs3Yswhj0zHYZf7ILOjJ9v4m4yl3libPqpvGtvcV
         9TDg8ixn+me+Q==
Date:   Thu, 3 Feb 2022 11:38:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <20220203113807.35d0faad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YfvIgdEmIh6cgk3f@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
        <20220202122848.647635-4-bigeasy@linutronix.de>
        <20220202085004.6bab2fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfvIgdEmIh6cgk3f@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 13:20:17 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-02 08:50:04 [-0800], Jakub Kicinski wrote:
> > On Wed,  2 Feb 2022 13:28:47 +0100 Sebastian Andrzej Siewior wrote:  
> > > so they can be removed once they are no more users left.  
> > 
> > Any plans for doing the cleanup?   
> 
> Sure. If this is not rejected I can go and hunt netif_rx_ni() and
> netif_rx_any_context().

Thanks! Primarily asking because I'm trying to take note of "outstanding
cleanups", but would be perfect if you can take care of it.
