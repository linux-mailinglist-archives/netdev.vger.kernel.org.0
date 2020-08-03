Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7108A23AB12
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgHCQ7A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Aug 2020 12:59:00 -0400
Received: from lixid.tarent.de ([193.107.123.118]:42749 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHCQ67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 12:58:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 1A7771409DC;
        Mon,  3 Aug 2020 18:58:56 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id njBK2RGIzm8H; Mon,  3 Aug 2020 18:58:48 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 2EF8C14092A;
        Mon,  3 Aug 2020 18:58:48 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id D8BA95205A6; Mon,  3 Aug 2020 18:58:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id D5DD652028D;
        Mon,  3 Aug 2020 18:58:47 +0200 (CEST)
Date:   Mon, 3 Aug 2020 18:58:47 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
X-X-Sender: tglase@tglase-nb.lan.tarent.de
To:     Ben Hutchings <ben@decadent.org.uk>
cc:     966459@bugs.debian.org, netdev <netdev@vger.kernel.org>
Subject: Re: Bug#966459: linux: traffic class socket options (both IPv4/IPv6)
 inconsistent with docs/standards
In-Reply-To: <db7d2f4dde6db2af82c880756d76af1b7c1e41e8.camel@decadent.org.uk>
Message-ID: <alpine.DEB.2.23.453.2008031733520.11571@tglase-nb.lan.tarent.de>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>   <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>   <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>  <e1beb0b98109d90738e054683f5eb1dd483011dd.camel@decadent.org.uk>
  <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>  <alpine.DEB.2.23.453.2008022243310.15898@tglase-nb.lan.tarent.de> <db7d2f4dde6db2af82c880756d76af1b7c1e41e8.camel@decadent.org.uk>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ben,

> For what it's worth, FreeBSD/Darwin and Windows also put 4 bytes of
> data in a IPV6_TCLASS cmsg.  So whether or not it's "right", it's
> consistent between three independent implementations.

oh, thank you, I don’t have any of these systems around at the
moment, so checking them was tricky for me.

So basically I should read an int in host endianness then (or
keep the code I currently have that compares byte 0 and 3, using
the one that’s not 0, if any). Great, thank you!

After some minor porting work, it turns out that the current code
does work on MidnightBSD (equivalent to FreeBSD 10.4) for IPv6.
I guess I’ll keep ints then.

bye,
//mirabilos
-- 
15:41⎜<Lo-lan-do:#fusionforge> Somebody write a testsuite for helloworld :-)
