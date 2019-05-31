Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC364310A5
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEaOyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:54:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49322 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfEaOyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 10:54:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWivQ-0007Jr-Fx; Fri, 31 May 2019 22:54:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWivM-0007Cx-9H; Fri, 31 May 2019 22:54:28 +0800
Date:   Fri, 31 May 2019 22:54:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
Message-ID: <20190531145428.ngwrgbnk2a7us5cy@gondor.apana.org.au>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
 <20190531062911.c6jusfbzgozqk2cu@gondor.apana.org.au>
 <727c4b18-0d7b-b3c6-e0bb-41b3fe5902d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727c4b18-0d7b-b3c6-e0bb-41b3fe5902d3@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 07:50:06AM -0700, Eric Dumazet wrote:
>
> What do you mean by should ?
> 
> Are they currently already linearized before the function is called,
> or is it missing and a bug needs to be fixed ?

AFAICS this is the code-path for locally generated outbound packets.
Under what circumstances can the IPv6 header be not in the head?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
