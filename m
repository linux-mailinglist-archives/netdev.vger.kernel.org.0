Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E67104A68
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 06:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKUFvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 00:51:55 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:58392 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfKUFvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 00:51:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5A376204EF;
        Thu, 21 Nov 2019 06:51:53 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aJIckJi97ehm; Thu, 21 Nov 2019 06:51:52 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1F55C20270;
        Thu, 21 Nov 2019 06:51:52 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 21 Nov 2019
 06:51:51 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C3C153182768;
 Thu, 21 Nov 2019 06:51:51 +0100 (CET)
Date:   Thu, 21 Nov 2019 06:51:51 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next v5 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191121055151.GW14361@gauss3.secunet.de>
References: <cover.1573487190.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1573487190.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:18:37PM +0100, Sabrina Dubroca wrote:
> This patchset introduces support for TCP encapsulation of IKE and ESP
> messages, as defined by RFC 8229 [0]. It is an evolution of what
> Herbert Xu proposed in January 2018 [1] that addresses the main
> criticism against it, by not interfering with the TCP implementation
> at all. The networking stack now has infrastructure for this: TCP ULPs
> and Stream Parsers.
> 
> The first patches are preparation and refactoring, and the final patch
> adds the feature.
> 
> The main omission in this submission is IPv6 support. ESP
> encapsulation over UDP with IPv6 is currently not supported in the
> kernel either, as UDP encapsulation is aimed at NAT traversal, and NAT
> is not frequently used with IPv6.
> 
> Some of the code is taken directly, or slightly modified, from Herbert
> Xu's original submission [1]. The ULP and strparser pieces are
> new. This work was presented and discussed at the IPsec workshop and
> netdev 0x13 conference [2] in Prague, last March.
> 
> [0] https://tools.ietf.org/html/rfc8229
> [1] https://patchwork.ozlabs.org/patch/859107/
> [2] https://netdevconf.org/0x13/session.html?talk-ipsec-encap

The patchset does not apply anymore after updating the
ipsec-next tree. Can you respin once again?

I'll apply it right away then.

Thanks!
