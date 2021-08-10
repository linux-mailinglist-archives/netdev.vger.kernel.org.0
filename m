Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910783E5170
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhHJDXR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Aug 2021 23:23:17 -0400
Received: from lixid.tarent.de ([193.107.123.118]:49346 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232741AbhHJDXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:23:16 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2021 23:23:16 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 160C4140DF0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:17:29 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 3t0bC0V2PsBu for <netdev@vger.kernel.org>;
        Tue, 10 Aug 2021 05:17:23 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id B91B014099A
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:17:23 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 48404521E45; Tue, 10 Aug 2021 05:17:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 4561C520456
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:17:23 +0200 (CEST)
Date:   Tue, 10 Aug 2021 05:17:23 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: Intro into qdisc writing?
Message-ID: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I hope this is the right place to ask this kind of questions,
and not just send patches ☺

I’m currently working with a… network simulator of sorts, which
has so far mostly used htb, netem, dualpi2 and fq_codel to do the
various tricks needed for whatever they do, but now I have rather
specific change requests (one of which I already implemented).

The next things on my list basically involve delaying all traffic
or a subset of traffic for a certain amount of time (in the one‑ to
two-digit millisecond ballpark, so rather long, in CPU time). I’ve
seen the netem source use qdisc_watchdog_schedule_ns for this, but,
unlike the functions I used in my earlier module changes, I cannot
find any documentation for this.

Similarily, is there an intro of sorts for qdisc writing, the things
to know, concepts, locking, whatever is needed?

My background is multi-decade low-level programmer, but so far only
userland, libc variants and bootloaders, not kernel, and what bit of
kernel I touched so far was in BSD land so any pointers welcome.

If it helps: while this is for a customer project, so far everything
coming out of it is published under OSS licences; mostly at
https://github.com/tarent/sch_jens/tree/master/sch_jens as regards
the kernel module (and ../jens/ for the relayfs client example) but
https://github.com/tarent/ECN-Bits has a related userspace project.

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

*************************************************

Mit dem tarent-Newsletter nichts mehr verpassen: www.tarent.de/newsletter

*************************************************
