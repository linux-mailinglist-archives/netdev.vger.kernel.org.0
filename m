Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB71403E4
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgAQGXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:23:05 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42538 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAQGXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 01:23:04 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1isL27-0005uG-HU; Fri, 17 Jan 2020 14:23:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1isL24-0002Kk-RB; Fri, 17 Jan 2020 14:23:00 +0800
Date:   Fri, 17 Jan 2020 14:23:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@asicdesigners.com>
Cc:     linux-crypto@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
Message-ID: <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
 <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 01:27:24PM +0530, Ayush Sawal wrote:
>
> The max data limit is 15 sgs where each sg contains data of mtu size .
> we are running a netperf udp stream test over ipsec tunnel .The ipsec tunnel
> is established between two hosts which are directly connected

Are you actually getting 15-element SG lists from IPsec? What is
generating an skb with 15-element SG lists?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
