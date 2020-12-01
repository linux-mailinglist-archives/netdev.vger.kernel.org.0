Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8169A2CB125
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 00:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgLAX4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 18:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgLAX4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 18:56:47 -0500
Date:   Tue, 1 Dec 2020 15:56:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606866967;
        bh=tVGb5cytFSEhe2mqVqX7fmnUeZTQ8Swf2+Si0z5bUbY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJ+GrJgJwG5CJ85SFJE1buS1kfRCpgiDx6VSE7g8hiMtJC2RDKeXSE7TPnFiM71oS
         eGysg8Si7eUQruovbwCyOkkAv1HZRc0uZ3lIT0GCtHGhIic92isI+0mowCJuAgkhAM
         RVtojiAwacfCxEk6qfOa21JObKNAJNZvjdHTqI1Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/10 net-next v2] net/tipc: fix all kernel-doc and add
 TIPC networking chapter
Message-ID: <20201201155605.143569d5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020 10:32:41 -0800 Randy Dunlap wrote:
> Fix lots of net/tipc/ kernel-doc warnings. Add many struct field and
> function parameter descriptions.
> 
> Then add a TIPC chapter to the networking documentation book.
> 
> All patches have been rebased to current net-next.
> 
> 
> Note: some of the struct members and function parameters are marked
> with "FIXME". They could use some additional descriptions if
> someone could help add to them. Thanks.

Applied, thanks!
