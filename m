Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3A30888
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEaG3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:29:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46012 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfEaG3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 02:29:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWb2U-0004JX-Nr; Fri, 31 May 2019 14:29:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWb2N-000571-RR; Fri, 31 May 2019 14:29:11 +0800
Date:   Fri, 31 May 2019 14:29:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
Message-ID: <20190531062911.c6jusfbzgozqk2cu@gondor.apana.org.au>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:17:04AM -0700, Eric Dumazet wrote:
>
> xfrm6_transport_output() seems buggy as well,
> unless the skbs are linearized before entering these functions ?

The headers that it's moving should be linearised.  Is there
something else I'm missing?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
