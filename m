Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FAF1F60A7
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFKDti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:49:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33284 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgFKDti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 23:49:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjEDe-0002xD-BC; Thu, 11 Jun 2020 13:49:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2020 13:49:34 +1000
Date:   Thu, 11 Jun 2020 13:49:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     ayush.sawal@chelsio.com, netdev@vger.kernel.org,
        manojmalviya@chelsio.com
Subject: Re: [PATCH net-next 0/2] Fixing issues in dma mapping and driver
 removal
Message-ID: <20200611034934.GA27316@gondor.apana.org.au>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
 <20200610.170543.194012331092190844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610.170543.194012331092190844.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 05:05:43PM -0700, David Miller wrote:
>
> Maybe we can start handling these changes via the crypto tree at some
> point?

Yes that's good point Dave.  How about we push changes for chcr_algo
via the crypto tree and the rest via netdev?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
