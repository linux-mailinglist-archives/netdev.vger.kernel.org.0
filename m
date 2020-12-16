Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD95C2DC4D3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgLPQ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgLPQ6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 11:58:16 -0500
Date:   Wed, 16 Dec 2020 08:57:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608137855;
        bh=lTbCPUkyt80kUslMKRdJX/8pVPr4xop3ucy9aCJrHic=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=aUF1IRL9NIfISGC+eS103Urpa9+D/0uHm4pFfvfc1WiFc4BtCXIfc1WnsR6UnIKM5
         1MgzAV88VGh5djmwZeIIb7YENnaWOmmitjw1v2JKUgQ4wy/0Vplqd+yUaX0m9BsB7f
         1Lp0nCC1bQYGzXQqiPXhdFppMTva8HTSw247RGMqYYpox1zB7nQsJzPJZta+9dsNiN
         jDP8XxHjVQGgLCLwNBaWj5PMndDLgOlQuGSLME8YkKe+SApGdJKvvC20rc3HrSo3tB
         3zQPKMzUR276xDEa5B6PWSVQkEH1hBnyUzpZrjj/fEFevxuf/JL3paJkLcQnop2F5N
         oJP1CMDbsCZYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: net-next is CLOSED
Message-ID: <20201216085734.50513e30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216164247.dyss26ivjxffrhgo@skbuf>
References: <20201215091056.7f811c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201216164247.dyss26ivjxffrhgo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 18:42:47 +0200 Vladimir Oltean wrote:
> On Tue, Dec 15, 2020 at 09:10:56AM -0800, Jakub Kicinski wrote:
> > The 5.10 PR went out yesterday, you know the drill.
> >
> > There are a few things (Vladimir's DSA+non-DSA bridging series, mlx5 SF
> > patches, Intel's S0ix fixes, Octeon multi-group RSS, threaded NAPI)
> > which we may include in the Thu PR if there is enough confidence.
> > Any other new feature should be posted as RFC at this point.  
> 
> First of all, congratulations for surviving this kernel development
> cycle :D you did a great job and spent a lot of time reviewing code.

Thanks, it's a team effort, so good job everyone! :)

> From my side there is absolutely zero urgency to send another pull
> request with the DSA features that did not make it in time for the first
> PR. I am happy to resend whenever net-next reopens.

Perfect, thanks for the clarification!
