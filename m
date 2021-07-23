Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF383D3A47
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhGWLwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 07:52:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56916 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhGWLvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 07:51:43 -0400
Received: from netfilter.org (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 874EB6244C;
        Fri, 23 Jul 2021 14:31:20 +0200 (CEST)
Date:   Fri, 23 Jul 2021 14:31:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin Ian King <colin.king@canonical.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnl_hook: fix unused variable warning
Message-ID: <20210723123150.GA15125@salvia>
References: <20210721152245.2751702-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210721152245.2751702-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 05:22:32PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The only user of this variable is in an #ifdef:
> 
> net/netfilter/nfnetlink_hook.c: In function 'nfnl_hook_entries_head':
> net/netfilter/nfnetlink_hook.c:177:28: error: unused variable 'netdev' [-Werror=unused-variable]

Applied, thanks.
