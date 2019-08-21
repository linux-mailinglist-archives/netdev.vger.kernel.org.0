Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6C3976FE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfHUKSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:18:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUKSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 06:18:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A55D308FC23;
        Wed, 21 Aug 2019 10:18:01 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0395D5D6B7;
        Wed, 21 Aug 2019 10:17:59 +0000 (UTC)
Date:   Wed, 21 Aug 2019 12:17:58 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC ipsec-next 0/7] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20190821101758.GA5282@bistromath.localdomain>
References: <cover.1561457281.git.sd@queasysnail.net>
 <20190816141814.GA12002@bistromath.localdomain>
 <20190821065911.GO2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190821065911.GO2879@gauss3.secunet.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 21 Aug 2019 10:18:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-21, 08:59:11 +0200, Steffen Klassert wrote:
> On Fri, Aug 16, 2019 at 04:18:14PM +0200, Sabrina Dubroca wrote:
> > Hi Steffen,
> > 
> > 2019-06-25, 12:11:33 +0200, Sabrina Dubroca wrote:
> > > This patchset introduces support for TCP encapsulation of IKE and ESP
> > > messages, as defined by RFC 8229 [0]. It is an evolution of what
> > > Herbert Xu proposed in January 2018 [1] that addresses the main
> > > criticism against it, by not interfering with the TCP implementation
> > > at all. The networking stack now has infrastructure for this: TCP ULPs
> > > and Stream Parsers.
> > 
> > Have you had a chance to look at this?  I was going to rebase and
> > resend, but the patches still apply to ipsec-next and net-next (patch
> > 2 is already in net-next as commit bd95e678e0f6).
> 
> I had a look and I have no general objection against this. If you
> think the patchset is ready for inclusion, just remove the RFC and
> resend it. I'll have a closer on it look then.

Ok, thanks, I'll repost.

-- 
Sabrina
