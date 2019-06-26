Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94F5726F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFZUUE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 16:20:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZUUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:20:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F32D714DB839E;
        Wed, 26 Jun 2019 13:20:03 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:20:03 -0700 (PDT)
Message-Id: <20190626.132003.50827799670386389.davem@davemloft.net>
To:     dave.taht@gmail.com
Cc:     netdev@vger.kernel.org, gnu@toad.com
Subject: Re: [PATCH net-next 1/1] Allow 0.0.0.0/8 as a valid address range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561223254-13589-2-git-send-email-dave.taht@gmail.com>
References: <1561223254-13589-1-git-send-email-dave.taht@gmail.com>
        <1561223254-13589-2-git-send-email-dave.taht@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:20:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Taht <dave.taht@gmail.com>
Date: Sat, 22 Jun 2019 10:07:34 -0700

> The longstanding prohibition against using 0.0.0.0/8 dates back
> to two issues with the early internet.
> 
> There was an interoperability problem with BSD 4.2 in 1984, fixed in
> BSD 4.3 in 1986. BSD 4.2 has long since been retired. 
> 
> Secondly, addresses of the form 0.x.y.z were initially defined only as
> a source address in an ICMP datagram, indicating "node number x.y.z on
> this IPv4 network", by nodes that know their address on their local
> network, but do not yet know their network prefix, in RFC0792 (page
> 19).  This usage of 0.x.y.z was later repealed in RFC1122 (section
> 3.2.2.7), because the original ICMP-based mechanism for learning the
> network prefix was unworkable on many networks such as Ethernet (which
> have longer addresses that would not fit into the 24 "node number"
> bits).  Modern networks use reverse ARP (RFC0903) or BOOTP (RFC0951)
> or DHCP (RFC2131) to find their full 32-bit address and CIDR netmask
> (and other parameters such as default gateways). 0.x.y.z has had
> 16,777,215 addresses in 0.0.0.0/8 space left unused and reserved for
> future use, since 1989.
> 
> This patch allows for these 16m new IPv4 addresses to appear within
> a box or on the wire. Layer 2 switches don't care.
> 
> 0.0.0.0/32 is still prohibited, of course.
> 
> Signed-off-by: Dave Taht <dave.taht@gmail.com>
> Signed-off-by: John Gilmore <gnu@toad.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks for following up on this.
