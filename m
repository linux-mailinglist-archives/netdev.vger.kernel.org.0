Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604D83AF69F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhFUUIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 16:08:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56540 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhFUUIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 16:08:34 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 13FBF641D0;
        Mon, 21 Jun 2021 22:04:55 +0200 (CEST)
Date:   Mon, 21 Jun 2021 22:06:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nfnetlink_hook: fix check for
 snprintf() overflow
Message-ID: <20210621200616.GA5033@salvia>
References: <YM33YmacZTH820Cv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YM33YmacZTH820Cv@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 04:55:46PM +0300, Dan Carpenter wrote:
> The kernel version of snprintf() can't return negatives.  The
> "ret > (int)sizeof(sym)" check is off by one because and it should be
> >=.  Finally, we need to set a negative error code.

Applied, thanks.
