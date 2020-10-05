Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6528430E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgJEXyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 19:54:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60510 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgJEXyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 19:54:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kPaId-0001Sf-A5; Tue, 06 Oct 2020 10:53:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Oct 2020 10:53:47 +1100
Date:   Tue, 6 Oct 2020 10:53:47 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: [PATCH 7/9 net-next] xfrm: use dev_sw_netstats_rx_add()
Message-ID: <20201005235346.GB13517@gondor.apana.org.au>
References: <20201005203634.55435-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005203634.55435-1-fabf@skynet.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 10:36:34PM +0200, Fabian Frederick wrote:
> use new helper for netstats settings
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  net/xfrm/xfrm_interface.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
