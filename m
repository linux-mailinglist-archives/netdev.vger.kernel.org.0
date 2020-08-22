Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F524E45F
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 03:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHVBIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 21:08:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51226 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgHVBIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 21:08:39 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k9I1H-0000Ki-M0; Sat, 22 Aug 2020 11:08:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Aug 2020 11:08:31 +1000
Date:   Sat, 22 Aug 2020 11:08:31 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
Message-ID: <20200822010831.GA15568@gondor.apana.org.au>
References: <20200821222329.GA2633@gondor.apana.org.au>
 <5d9b715e-d213-8e82-1a68-aee24c3b589d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9b715e-d213-8e82-1a68-aee24c3b589d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 04:40:49PM -0700, Eric Dumazet wrote:
>
> I am not completely familiar with CONFIG_TRACEPOINTS
> 
> Is "perf probe" support requiring it ?

Yes.

perf probe requires CONFIG_KPROBE_EVENTS which selects CONFIG_TRACING
which selects CONFIG_TRACEPOINTS.

> We want the following to be supported.
> 
> perf probe consume_skb

That should continue to work as this patch does not change anything
when CONFIG_TRACEPOINTS is enabled.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
