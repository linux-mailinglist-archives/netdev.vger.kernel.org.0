Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2EE2071F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 14:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfEPMnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 08:43:04 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:45812 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfEPMnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 08:43:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRFii-0002OK-A7; Thu, 16 May 2019 20:42:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRFiW-0004a1-4X; Thu, 16 May 2019 20:42:36 +0800
Date:   Thu, 16 May 2019 20:42:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "neilb@suse.com" <neilb@suse.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH 2/2] rhashtable: Fix cmpxchg RCU warnings
Message-ID: <20190516124236.m5p3zm27kjgtzzvf@gondor.apana.org.au>
References: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
 <E1hRAg8-0004Fy-0O@gondobar>
 <e79357ea8fde45b281be9a8196b806f8@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e79357ea8fde45b281be9a8196b806f8@AcuMS.aculab.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 09:20:36AM +0000, David Laight wrote:
>
> I presume these casts remove an 'rcu' marker on the variable.
> Is there a way of marking such casts as 'for sparse only' so
> that the compiler does proper type checking.
> (Clearly this isn't that relevant here as the cast could be (void **).)
> 
> Hmmm something should be checking that the type of the argument
> to cmpxchg is 'pointer to "something the size of a pointer"'
> Adding any kind of cast subverts that test.

If we were adding this as an RCU primitive then yes that what
it should do.  But it isn't relevant to this patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
