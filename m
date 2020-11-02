Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1E2A2399
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 04:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgKBDi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 22:38:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41944 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgKBDi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 22:38:58 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kZQgC-00072h-Gs; Mon, 02 Nov 2020 14:38:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 02 Nov 2020 14:38:48 +1100
Date:   Mon, 2 Nov 2020 14:38:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Alistair Delva <adelva@google.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] xfrm/compat: Remove use of kmalloc_track_caller
Message-ID: <20201102033848.GA1861@gondor.apana.org.au>
References: <20201101220845.2391858-1-adelva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101220845.2391858-1-adelva@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:08:45PM -0800, Alistair Delva wrote:
> The __kmalloc_track_caller symbol is not exported if SLUB/SLOB are
> enabled instead of SLAB, which breaks the build on such configs when
> CONFIG_XFRM_USER_COMPAT=m.
> 
> ERROR: "__kmalloc_track_caller" [net/xfrm/xfrm_compat.ko] undefined!

Is this with a recent kernel? Because they should be exported:

commit fd7cb5753ef49964ea9db5121c3fc9a4ec21ed8e
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Mar 23 15:49:00 2020 +0100

    mm/sl[uo]b: export __kmalloc_track(_node)_caller

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
