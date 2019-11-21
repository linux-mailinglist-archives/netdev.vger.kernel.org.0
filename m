Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED6104F60
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUJgI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 04:36:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59361 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:36:07 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-NraGDYRhP0a1o934b5P2VQ-1; Thu, 21 Nov 2019 04:36:02 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 830C8107B790;
        Thu, 21 Nov 2019 09:36:01 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DA9244F98;
        Thu, 21 Nov 2019 09:35:59 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:35:58 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next v5 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191121093558.GA3571977@bistromath.localdomain>
References: <cover.1573487190.git.sd@queasysnail.net>
 <20191121055151.GW14361@gauss3.secunet.de>
MIME-Version: 1.0
In-Reply-To: <20191121055151.GW14361@gauss3.secunet.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: NraGDYRhP0a1o934b5P2VQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-21, 06:51:51 +0100, Steffen Klassert wrote:
> On Tue, Nov 12, 2019 at 04:18:37PM +0100, Sabrina Dubroca wrote:
> > This patchset introduces support for TCP encapsulation of IKE and ESP
> > messages, as defined by RFC 8229 [0]. It is an evolution of what
> > Herbert Xu proposed in January 2018 [1] that addresses the main
> > criticism against it, by not interfering with the TCP implementation
> > at all. The networking stack now has infrastructure for this: TCP ULPs
> > and Stream Parsers.
> > 
> > The first patches are preparation and refactoring, and the final patch
> > adds the feature.
> > 
> > The main omission in this submission is IPv6 support. ESP
> > encapsulation over UDP with IPv6 is currently not supported in the
> > kernel either, as UDP encapsulation is aimed at NAT traversal, and NAT
> > is not frequently used with IPv6.
> > 
> > Some of the code is taken directly, or slightly modified, from Herbert
> > Xu's original submission [1]. The ULP and strparser pieces are
> > new. This work was presented and discussed at the IPsec workshop and
> > netdev 0x13 conference [2] in Prague, last March.
> > 
> > [0] https://tools.ietf.org/html/rfc8229
> > [1] https://patchwork.ozlabs.org/patch/859107/
> > [2] https://netdevconf.org/0x13/session.html?talk-ipsec-encap
> 
> The patchset does not apply anymore after updating the
> ipsec-next tree. Can you respin once again?
> 
> I'll apply it right away then.
> 
> Thanks!

Ah, yes, that's the change Eric mentioned last week. I'll repost in a
bit, thanks.

-- 
Sabrina

