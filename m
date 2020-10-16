Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25D3290E45
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409926AbgJPXvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387948AbgJPXts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 19:49:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF01322201;
        Fri, 16 Oct 2020 23:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602892151;
        bh=YcYFgwk6x9lyikQD3et0GilWBVcmuTFMfEgqx2S7WDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JajTIaj06mapDsMvZS450fV5Ktikzj8no9VTIiSqBird1IUuh5IMhYgK0TqtY9eLD
         UoLannAYEZs2jo88IHF1UrPHgRN0eV/VhFKZGvIhrRUjTBphf7KE9WkzIC9hvI0ptG
         GA/Hdr8KQvLMO/KVW/mldGGuYCgS3lxvZFFYBrHE=
Date:   Fri, 16 Oct 2020 16:49:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Keyu Man <kman001@ucr.edu>
Subject: Re: [PATCH net] icmp: randomize the global rate limiter
Message-ID: <20201016164909.45d02606@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015184200.2179938-1-eric.dumazet@gmail.com>
References: <20201015184200.2179938-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 11:42:00 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Keyu Man reported that the ICMP rate limiter could be used
> by attackers to get useful signal. Details will be provided
> in an upcoming academic publication.
> 
> Our solution is to add some noise, so that the attackers
> no longer can get help from the predictable token bucket limiter.
> 
> Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Keyu Man <kman001@ucr.edu>

Applied, queued up, thank you!
