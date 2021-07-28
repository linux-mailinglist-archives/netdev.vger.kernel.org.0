Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9FF3D8E4B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhG1MxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:53:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51550 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235105AbhG1MxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:53:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m8j3N-0006Ou-VM; Wed, 28 Jul 2021 20:52:54 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m8j3I-0000lq-L8; Wed, 28 Jul 2021 20:52:48 +0800
Date:   Wed, 28 Jul 2021 20:52:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Revert "net: Get rid of consume_skb when tracing is off"
Message-ID: <20210728125248.GC2598@gondor.apana.org.au>
References: <20210728035605.24510-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728035605.24510-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:56:05AM +0800, Yajun Deng wrote:
> This reverts commit be769db2f95861cc8c7c8fedcc71a8c39b803b10.
> There is trace_kfree_skb() in kfree_skb(), the trace_kfree_skb() is
> also a trace function.
> 
> Fixes: be769db2f958 (net: Get rid of consume_skb when tracing is off)
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Please explain in more detail why your patch is needed.  As it
stands I do not understand the reasoning.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
