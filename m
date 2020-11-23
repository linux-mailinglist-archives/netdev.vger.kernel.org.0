Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A32C18BE
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbgKWWpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbgKWWpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:45:16 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A844206D8;
        Mon, 23 Nov 2020 22:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171515;
        bh=/p/jbTtRLIIWEgXXbATB4oqtwL6MJqcX0TPc3/A1S1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7pIakUiJFfSqyMuKWUtj7dcC/pGT+jMfh4oYXmVVaTOxpwPgUopS/y6fhjoGpmJN
         9BiQRMqqZlm9SPhmdGnmXzyJiZNQPogZuwlxs3B4Gkv6IdP1Y9KJULXJk7a79W8MTW
         phoxsfTUURqkfyS16t7/Pfc2NImXhIKGTBOscWrI=
Date:   Mon, 23 Nov 2020 16:45:29 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 015/141] netfilter: Fix fall-through warnings for Clang
Message-ID: <20201123224529.GE21644@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <ed43418cabacc651f198fbad9a9fcfe32c6ddf6f.1605896059.git.gustavoars@kernel.org>
 <20201120224737.GR15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120224737.GR15137@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 11:47:37PM +0100, Florian Westphal wrote:
> Gustavo A. R. Silva <gustavoars@kernel.org> wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> > warnings by explicitly adding multiple break statements instead of just
> > letting the code fall through to the next case.
> 
> Acked-by: Florian Westphal <fw@strlen.de>
> 
> Feel free to carry this in next iteration of series, if any.

Thanks, Florian.
--
Gustavo
