Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707963AE069
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFTUsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 16:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhFTUsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 16:48:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82AEC061574;
        Sun, 20 Jun 2021 13:45:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lv4K2-0003IO-AO; Sun, 20 Jun 2021 22:45:38 +0200
Date:   Sun, 20 Jun 2021 22:45:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nfnetlink_hook: fix check for
 snprintf() overflow
Message-ID: <20210620204538.GB10010@breakpoint.cc>
References: <YM33YmacZTH820Cv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YM33YmacZTH820Cv@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The kernel version of snprintf() can't return negatives.  The
> "ret > (int)sizeof(sym)" check is off by one because and it should be
> >=.  Finally, we need to set a negative error code.

Reviewed-by: Florian Westphal <fw@strlen.de>
