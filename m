Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB82C6E3F
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgK1Bnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbgK1Blr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 20:41:47 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF63D221FF;
        Sat, 28 Nov 2020 01:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606527707;
        bh=n1jff1eKrVGNJkxTvjKBVrzwKhaHYtbssaUadJ+owZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SakwCF3W88WwnA9uy7yuCISj4JDtdNeoYEF+HwaCTkmr0akupjeEeJ95bPRPes5dK
         iUkh8O86h77NtDuaHvAj4D5MZQRX3NxWi+pLhGDW8DKRIWsgYTaXZqbqnjpbkqUbzi
         HltMNFT9YmM1dHqxEsaOEUzb/D7YgAGsl2RO5e8U=
Date:   Fri, 27 Nov 2020 17:41:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/10 net-next] net/tipc: fix all kernel-doc and add
 TIPC networking chapter
Message-ID: <20201127174120.22ab7318@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 20:20:16 -0800 Randy Dunlap wrote:
> Fix lots of net/tipc/ kernel-doc warnings. Add many struct field and
> function parameter descriptions.
> 
> Then add a TIPC chapter to the networking documentation book.
> 
> 
> Note: some of the struct members and function parameters are marked
> with "FIXME". They could use some additional descriptions if
> someone could help add to them. Thanks.
> 
> 
> Question: is net/tipc/discover.c, in tipc_disc_delete() kernel-doc,
> what is the word "duest"?  Should it be changed?

Thanks for cleaning those up! 

Looks like this had a conflict with commits from 6375da9dac8b ("Merge
branch 'tipc-some-minor-improvements'") - please rebase.
