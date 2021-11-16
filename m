Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9B3453A3B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbhKPTgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240016AbhKPTgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:36:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35BE36140D;
        Tue, 16 Nov 2021 19:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637091197;
        bh=olyTIDgKbN/LE4SS8IVu3CEuEwJQDAiGRdFxH0j4aN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GGREMuU5oJGgcafoWoMt7qq1vFZDzu3tjd+0dPH/9t++9uxsibvGrEXhwVH1urJoR
         GTp1mr04GebScjeouLVZ1WwJA2jeaYnDXaX36ziao+V4GCiMhtvH7uUsnjGzJklHfN
         r1Hpq0USwgrIAU2O1nt8h3qk2/1OiFE4KSgFMDNmVfvioobmYSCkci6M8ysCsjzqzi
         kBzGum8bAWFXjCV/2hBYH3ZZ/nsrbaxZ8ozHWGjIt+ylHAwPpPgtVlvOGtc07uzLFZ
         F+wlImcvqsFXIEeiAx3YgZGDaor22dJRZWOoK/S6If2JaxrQqD7wYk4PBv5KFRLAvP
         xlUYJVIJOwj0g==
Date:   Tue, 16 Nov 2021 11:33:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] tipc: check for null after calling kmemdup
Message-ID: <20211116113316.00d7d8cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116113232.45eceecf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
        <0f144d68-37c8-1e4a-1516-a3a572f06f8f@redhat.com>
        <20211112201332.601b8646@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <997876b6-39b4-64f0-648a-8b042b03a3a8@linaro.org>
        <20211116113232.45eceecf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 11:32:32 -0800 Jakub Kicinski wrote:
> On Fri, 12 Nov 2021 21:42:11 -0800 Tadeusz Struk wrote:
> > On 11/12/21 20:13, Jakub Kicinski wrote:
> >  [...]    
>  [...]  
> > > Hm, shouldn't we free all the tfm entries here?    
> > 
> > Right, I think we just need to call tipc_aead_free(&tmp->rcu);
> > here and return an error.  
> 
> Would be good to get an ack From Jon or Ying on that one.

Ah, I hit reply on the wrong sub-thread, this was meant for the "any
feedback question".
