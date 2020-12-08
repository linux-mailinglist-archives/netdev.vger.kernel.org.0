Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2562D2049
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgLHBrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgLHBrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 20:47:20 -0500
Date:   Mon, 7 Dec 2020 17:46:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607391999;
        bh=0QTIqEhA9j0m/r1x1C7A0XMyV9xdxEQFGDzY9d0jjLw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=siXg/w4Q+Iy83Nu2qm9LIrr8mQhUAzwJPRC+mghcSI3GKuw3MoA4f3pZdtGNoN6ke
         TVg0sYNL9++60JFeYkhbHheL0sr6v++MOxknwTC+bURiA/4g5Ib+J2Jz3Iwg8PfblH
         mbziwVwgLsKNyViwiBS1YNSFcYkZryPxsPMX2fpqmykvxOGBQ8jnhHRo+NmV+wzQfz
         aOqDYe1ZRCMaCC8vxPND0DcV+GiNm2XLYqS5KlOZBjqIJ/nI/YmyJVm6s1xXraLG9N
         2NE88mEXjTglvwY5UjZqGIlReMUIxXc3lIerfhUCFwylPnb7AKY//uqRQnbsrPUTR/
         xqiqXhCYpDytw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        davem@davemloft.net
Subject: Re: [PATCH net v2] mptcp: print new line in mptcp_seq_show() if
 mptcp isn't in use
Message-ID: <20201207174638.3740a734@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <142e2fd9-58d9-bb13-fb75-951cccc2331e@163.com>
References: <142e2fd9-58d9-bb13-fb75-951cccc2331e@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 15:56:33 +0800 Jianguo Wu wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> When do cat /proc/net/netstat, the output isn't append with a new line, it looks like this:
> [root@localhost ~]# cat /proc/net/netstat
> ...
> MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0[root@localhost ~]#
> 
> This is because in mptcp_seq_show(), if mptcp isn't in use, net->mib.mptcp_statistics is NULL,
> so it just puts all 0 after "MPTcpExt:", and return, forgot the '\n'.
> 
> After this patch:
> 
> [root@localhost ~]# cat /proc/net/netstat
> ...
> MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0
> [root@localhost ~]#
> 
> Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> Acked-by: Florian Westphal <fw@strlen.de>

Applied, thanks!
