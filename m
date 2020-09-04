Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6091625DA8A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgIDNva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:51:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43100 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730569AbgIDNuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:50:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kEC72-0007X0-Ah; Fri, 04 Sep 2020 23:50:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2020 23:50:44 +1000
Date:   Fri, 4 Sep 2020 23:50:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Message-ID: <20200904135044.GA2836@gondor.apana.org.au>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 01:45:38PM +0000, Srujana Challa wrote:
>
> This block of code is used for LMT store operations. The LMT store operation
> is specific to our platform, and this uses the "ldeor" instruction(which is
> actually an LSE atomic instruction available on v8.1 CPUs) targeting the
> IO address.
> We add it in the driver since we want LMT store to work even if LSE_ATOMICS
> is disabled.

You have exactly the same macro in your net driver.  Move it into
a header file in arch/arm64/include/asm and also add one under
include/asm-generic so we can compile-test.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
