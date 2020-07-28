Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EBE230F20
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbgG1QW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:22:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56116 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbgG1QW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:22:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0SNQ-0000BR-Hm; Wed, 29 Jul 2020 02:22:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Jul 2020 02:22:52 +1000
Date:   Wed, 29 Jul 2020 02:22:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Antony Antony <antony@phenome.org>
Subject: Re: [PATCH ipsec-next] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
Message-ID: <20200728162252.GA3255@gondor.apana.org.au>
References: <20200728154342.GA31835@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728154342.GA31835@moon.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:47:30PM +0200, Antony Antony wrote:
> when enabled, 1, redact XFRM SA secret in the netlink response to
> xfrm_get_sa() or dump all sa.
> 
> e.g
> echo 1 > /proc/sys/net/core/xfrm_redact_secret
> ip xfrm state
> src 172.16.1.200 dst 172.16.1.100
> 	proto esp spi 0x00000002 reqid 2 mode tunnel
> 	replay-window 0
> 	aead rfc4106(gcm(aes)) 0x0000000000000000000000000000000000000000 96
> 
> the aead secret is redacted.
> 
> /proc/sys/core/net/xfrm_redact_secret is a toggle.
> Once enabled, either at compile or via proc, it can not be disabled.
> Redacting secret is a FIPS 140-2 requirement.

Couldn't you use the existing fips_enabled sysctl?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
