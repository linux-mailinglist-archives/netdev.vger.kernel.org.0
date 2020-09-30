Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90927E654
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgI3KOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:14:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42710 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgI3KO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 06:14:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kNZ7u-00049c-8C; Wed, 30 Sep 2020 20:14:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Sep 2020 20:14:22 +1000
Date:   Wed, 30 Sep 2020 20:14:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     James Morris <jmorris@namei.org>
Cc:     Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
Message-ID: <20200930101422.GC25359@gondor.apana.org.au>
References: <160141647786.7997.5490924406329369782.stgit@sifl>
 <alpine.LRH.2.21.2009300909150.6592@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2009300909150.6592@namei.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 09:09:20AM +1000, James Morris wrote:
>
> I'm not keen on adding a parameter which nobody is using. Perhaps a note 
> in the header instead?

Please at least change to the struct flowi to flowi_common if we're
not adding a family field.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
