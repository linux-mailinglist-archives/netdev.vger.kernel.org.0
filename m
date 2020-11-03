Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89432A44CB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgKCMIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:08:44 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49500 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgKCMIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 07:08:42 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kZv79-0002vb-9o; Tue, 03 Nov 2020 23:08:40 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Nov 2020 23:08:39 +1100
Date:   Tue, 3 Nov 2020 23:08:39 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH ipsec] xfrm: Pass template address family to
 xfrm_state_look_at
Message-ID: <20201103120839.GA10834@gondor.apana.org.au>
References: <20201103023217.27685-1-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103023217.27685-1-ajderossi@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:32:19PM -0800, Anthony DeRossi wrote:
> This fixes a regression where valid selectors are incorrectly skipped
> when xfrm_state_find is called with a non-matching address family (e.g.
> when using IPv6-in-IPv4 ESP in transport mode).

Why are we even allowing v6-over-v4 in transport mode? Isn't that
the whole point of BEET mode?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
