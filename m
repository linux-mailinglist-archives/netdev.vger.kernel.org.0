Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A021082D7
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfKXKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:19:13 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:52744 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfKXKTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 05:19:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5F62E201AA;
        Sun, 24 Nov 2019 11:19:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dEctGi5lvyAs; Sun, 24 Nov 2019 11:19:10 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A655F2019C;
        Sun, 24 Nov 2019 11:19:10 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Sun, 24 Nov 2019
 11:19:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4081C31801A8;
 Sun, 24 Nov 2019 11:19:10 +0100 (CET)
Date:   Sun, 24 Nov 2019 11:19:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     kbuild test robot <lkp@intel.com>
CC:     Sabrina Dubroca <sd@queasysnail.net>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ipsec-next:testing 6/6] net/xfrm/espintcp.c:402:13: sparse:
 sparse: incompatible types in comparison expression (different address
 spaces):
Message-ID: <20191124101910.GE14361@gauss3.secunet.de>
References: <201911231026.qn0a6HJ2%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201911231026.qn0a6HJ2%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 10:53:27AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> head:   73994d31bda7074698e8d07b40152eeabccd5780
> commit: 73994d31bda7074698e8d07b40152eeabccd5780 [6/6] xfrm: add espintcp (RFC 8229)
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-36-g9305d48-dirty
>         git checkout 73994d31bda7074698e8d07b40152eeabccd5780
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> net/xfrm/espintcp.c:402:13: sparse: sparse: incompatible types in comparison expression (different address spaces):
> >> net/xfrm/espintcp.c:402:13: sparse:    void [noderef] <asn:4> *
> >> net/xfrm/espintcp.c:402:13: sparse:    void *

Sabrina, can you please fix this?
