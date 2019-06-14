Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892DE45A30
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfFNKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:17:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33758 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfFNKRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:17:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E0D9E200A3;
        Fri, 14 Jun 2019 12:17:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RRv7952B7TMd; Fri, 14 Jun 2019 12:17:08 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7A37C200A0;
        Fri, 14 Jun 2019 12:17:08 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Jun 2019
 12:17:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 200253180B3C;
 Fri, 14 Jun 2019 12:17:08 +0200 (CEST)
Date:   Fri, 14 Jun 2019 12:17:08 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jeremy Sowden <jeremy@azazel.net>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] af_key: Fix memory leak in key_notify_policy.
Message-ID: <20190614101708.GP17989@gauss3.secunet.de>
References: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
 <20190614085346.GN17989@gauss3.secunet.de>
 <20190614095922.k5yzeyew2zhrfp7e@azazel.net>
 <20190614101338.hia635sctr6qjmd2@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190614101338.hia635sctr6qjmd2@azazel.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 11:13:38AM +0100, Jeremy Sowden wrote:
> 
> That reminds me.  Stephen Rothwell reported a problem with the "Fixes:"
> tag:
> 
> On 2019-05-29, at 07:48:12 +1000, Stephen Rothwell wrote:
> > In commit
> >
> >   7c80eb1c7e2b ("af_key: fix leaks in key_pol_get_resp and dump_sp.")
> >
> > Fixes tag
> >
> >   Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
> >
> > has these problem(s):
> >
> >   - Subject does not match target commit subject
> >     Just use
> > 	git log -1 --format='Fixes: %h ("%s")'
> 
> What's the procedure for fixing this sort of thing?  Do you need me to
> do anything?

No, that patch is already commited. We can't change the commit
message anymore. Just keep it in mind for next time.
