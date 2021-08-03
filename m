Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCE13DF1F2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhHCP7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237186AbhHCP7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 11:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C5360F45;
        Tue,  3 Aug 2021 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628006372;
        bh=ChhPSCYwVwBW+Gw7+iatuovIf2TIbBAIu4oLOgUZzyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXEcYW8VOiRy/IqDk4w1z47ZV6TB8DMXPTzW1CYY5HfajRsDDtvi8Xev/ZUwWC48+
         Aa51HsvYdXIMh8yk5fPYG1VmnBomN8B/Upoq7GG5AzB6SdEhYNL0QSksUWV8kHjKX5
         lQuqpJzsqwsPv6M7XeD8A3Mn4C6MTFIOaDuaKGvo6egbC7csK0LzykiKuk1XGKtvwN
         /pNDxIDlyTL3a5/+kc1KmIonqd46lgyDOr548FG0l6EC8AcJjUWNc56z32KU1oKWbz
         M7higY0/dGWoOrUd7ahds/l7oZ46vMzb6IOwp0J0I6mwXo6rp+4o2jXSrek6Ya4TRD
         5vDGdL3cNsNPQ==
Date:   Tue, 3 Aug 2021 08:59:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     yajun.deng@linux.dev
Cc:     "kernel test robot" <lkp@intel.com>, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        mptcp@lists.linux.dev, Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH net-next] net: Modify sock_set_keepalive() for more
 scenarios
Message-ID: <20210803085930.103d37dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a37faefd6dcad9f01212d60f8bb32f4f@linux.dev>
References: <202108031929.b1AMeeUj-lkp@intel.com>
        <20210803082553.25194-1-yajun.deng@linux.dev>
        <a37faefd6dcad9f01212d60f8bb32f4f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Aug 2021 11:42:39 +0000 yajun.deng@linux.dev wrote:
> The tcp_create_listen_sock() function was already dropped in commit
> <2dc6b1158c28c3a5e86d162628810312f98d5e97> by Alexander Aring.

We don't have the commit you're quoting in the networking trees.

You should modify tcp_create_listen_sock() and we'll deal with 
the conflict during the merge window.

Unless obviously you should wait and "send the patch within a context
of other scenarios".. (I'm unclear on what Denis is referring to.)
