Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED713E38
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfEEHpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:45:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfEEHpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:45:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49D4714C03B11;
        Sun,  5 May 2019 00:45:23 -0700 (PDT)
Date:   Sun, 05 May 2019 00:27:12 -0700 (PDT)
Message-Id: <20190505.002712.639270971831500623.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, tom@quantonium.net
Subject: Re: [PATCH v9 net-next 0/6] exthdrs: Make ext. headers & options
 useful - Part I
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556579717-1554-1-git-send-email-tom@quantonium.net>
References: <1556579717-1554-1-git-send-email-tom@quantonium.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 00:45:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Mon, 29 Apr 2019 16:15:11 -0700

> Extension headers are the mechanism of extensibility for the IPv6
> protocol, however to date they have only seen limited deployment.
> The reasons for that are because intermediate devices don't handle
> them well, and there haven't really be any useful extension headers
> defined. In particular, Destination and Hop-by-Hop options have
> not been deployed to any extent.
> 
> The landscape may be changing as there are now a number of serious
> efforts to define and deploy extension headers. In particular, a number
> of uses for Hop-by-Hop Options are currently being proposed, Some of
> these are from router vendors so there is hope that they might start
> start to fix their brokenness. These proposals include IOAM, Path MTU,
> Firewall and Service Tickets, SRv6, CRH, etc.
> 
> Assuming that IPv6 extension headers gain traction, that leaves a
> noticeable gap in IPv4 support. IPv4 options have long been considered a
> non-starter for deployment. An alternative being proposed is to enable
> use of IPv6 options with IPv4 (draft-herbert-ipv4-eh-00).

"Assuming ipv6 extension headers gain traction, my patch set is useful."

Well, when they gain traction you can propose this stuff.

Until then, it's a facility implemented based upon wishful thinking.

Sorry Tom, I kept pushing back using trivial coding style feedback
because I simply can't justify applying this.

