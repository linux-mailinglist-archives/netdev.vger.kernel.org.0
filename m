Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A37624EA1A
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 00:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHVWsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 18:48:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54898 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgHVWsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 18:48:15 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k9cIm-0003UW-Ac; Sun, 23 Aug 2020 08:47:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Aug 2020 08:47:56 +1000
Date:   Sun, 23 Aug 2020 08:47:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
Message-ID: <20200822224756.GA17844@gondor.apana.org.au>
References: <20200821222329.GA2633@gondor.apana.org.au>
 <20200822175419.GA293438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822175419.GA293438@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 01:54:19PM -0400, Neil Horman wrote:
>
> Wouldn't it be better to make this:
> #define consume_skb(x) kfree_skb(x)

Either way is fine but I prefer inline functions over macros.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
