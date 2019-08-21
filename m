Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C25972DF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfHUG7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:59:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44050 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfHUG7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 02:59:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 81F6E2059C;
        Wed, 21 Aug 2019 08:59:12 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2afeCh5g0elE; Wed, 21 Aug 2019 08:59:12 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1D079201AA;
        Wed, 21 Aug 2019 08:59:12 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 08:59:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C422E31827CE;
 Wed, 21 Aug 2019 08:59:11 +0200 (CEST)
Date:   Wed, 21 Aug 2019 08:59:11 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC ipsec-next 0/7] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20190821065911.GO2879@gauss3.secunet.de>
References: <cover.1561457281.git.sd@queasysnail.net>
 <20190816141814.GA12002@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190816141814.GA12002@bistromath.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 04:18:14PM +0200, Sabrina Dubroca wrote:
> Hi Steffen,
> 
> 2019-06-25, 12:11:33 +0200, Sabrina Dubroca wrote:
> > This patchset introduces support for TCP encapsulation of IKE and ESP
> > messages, as defined by RFC 8229 [0]. It is an evolution of what
> > Herbert Xu proposed in January 2018 [1] that addresses the main
> > criticism against it, by not interfering with the TCP implementation
> > at all. The networking stack now has infrastructure for this: TCP ULPs
> > and Stream Parsers.
> 
> Have you had a chance to look at this?  I was going to rebase and
> resend, but the patches still apply to ipsec-next and net-next (patch
> 2 is already in net-next as commit bd95e678e0f6).

I had a look and I have no general objection against this. If you
think the patchset is ready for inclusion, just remove the RFC and
resend it. I'll have a closer on it look then.
