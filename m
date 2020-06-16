Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2CA1FB582
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgFPPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:05:48 -0400
Received: from 167-179-156-38.a7b39c.bne.nbn.aussiebb.net ([167.179.156.38]:37193
        "EHLO fornost.hmeau.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729839AbgFPPFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:05:45 -0400
X-Greylist: delayed 1649 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2020 11:05:43 EDT
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlCj1-00032J-9E; Wed, 17 Jun 2020 00:38:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 17 Jun 2020 00:38:07 +1000
Date:   Wed, 17 Jun 2020 00:38:07 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200616143807.GA1359@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
 <20200616103440.35a80b4b@canb.auug.org.au>
 <20200616010502.GA28834@gondor.apana.org.au>
 <20200616033849.GL23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616033849.GL23230@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 04:38:49AM +0100, Al Viro wrote:
>
> Folded and pushed

Thanks Al.  Here's another one that I just got, could you add this
one too?

diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd/nand/raw/cadence-nand-controller.c
index c405722adfe1..c4f273e2fe78 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -17,6 +17,7 @@
 #include <linux/mtd/rawnand.h>
 #include <linux/of_device.h>
 #include <linux/iopoll.h>
+#include <linux/slab.h>
 
 /*
  * HPNFC can work in 3 modes:

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
