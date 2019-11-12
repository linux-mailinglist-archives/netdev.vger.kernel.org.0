Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44940F9A83
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKLUXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:23:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKLUXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:23:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D279F154D32D6;
        Tue, 12 Nov 2019 12:23:01 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:23:01 -0800 (PST)
Message-Id: <20191112.122301.947461264517400659.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        steffen.klassert@secunet.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573487190.git.sd@queasysnail.net>
References: <cover.1573487190.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:23:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Tue, 12 Nov 2019 16:18:37 +0100

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
 ...

This looks generally fine to me, and I assume Steffen will pick this up
and integrate it into his ipsec-next tree.

For the series:

Acked-by: David S. Miller <davem@davemloft.net>
