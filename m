Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB16A395158
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhE3OwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 10:52:12 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60276 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhE3OwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 10:52:11 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 84D7F200EEBB;
        Sun, 30 May 2021 16:50:31 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 84D7F200EEBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622386231;
        bh=t7S6OzyTfswqtF+Kv7MT0p/q3dEZMNshyO4Y8ZrCgD4=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=iwPd3e6418PLh7yDIVX1lcQKajXfcZx7GPqhQ5QSefAxD4O33OyBsAAwM2vU3VIBh
         YKPXPgW9Np0xz1rAdyVHPAXB9qVryFIOKJmKr3p4tKT4gPtvGzOtfqn+LF5Cq3fXI3
         e+ej/7r6v1RAcWu2kG7hUuiW9JBlSrPwOLNSL/uI/bsuc+QhDA3GKMK/oH1U0Wv2GC
         txENuMeifstLkzoCb8ylAH5EKXxMkWVFlfe3wQk7CtpNG8vEKBorEut6K+DVt+JLzv
         Dyo0oZl0+XLMG8TCFzHWgxLJuj5rnU+EcO4P+/xdyPkbyom4IX74wH5lR3t731neQm
         pM72uPZwhOJUw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 795DE6008D47D;
        Sun, 30 May 2021 16:50:31 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rrx8Tfpi907b; Sun, 30 May 2021 16:50:31 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 6228F6008D47B;
        Sun, 30 May 2021 16:50:31 +0200 (CEST)
Date:   Sun, 30 May 2021 16:50:31 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <1616887215.34203636.1622386231363.JavaMail.zimbra@uliege.be>
In-Reply-To: <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-3-justin.iurman@uliege.be> <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: KMu3rfy/JgmAcDHjEzGJ/hX/Qek2UpsQVY0y
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
>>> headers. Default is ignore (= disabled). Another per-interface sysctl
>>> ioam6_id is provided to define the IOAM (unique) identifier of the
>>> interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
>>> define the IOAM (unique) identifier of the node. Default is 0.
>> 
>> Last two sentences are repeated.
> 
> One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the other describes
> net.ipv6.ioam6_id (per namespace). It allows for defining an IOAM id to an
> interface and, also, the node in general.
> 
>> Is 0 a valid interface ID? If not why not use id != 0 instead of
>> having a separate enabled field?
> 
> Mainly for semantic reasons. Indeed, I'd prefer to keep a specific "enable" flag
> per interface as it sounds more intuitive. But, also because 0 could very well
> be a "valid" interface id (more like a default value).

Actually, it's more than for semantic reasons. Take the following topology:

 _____              _____              _____
|     | eth0  eth0 |     | eth1  eth0 |     |
|  A  |.----------.|  B  |.----------.|  C  |
|_____|            |_____|            |_____|

If I only want IOAM to be deployed from A to C but not from C to A, then I would need the following on B (let's just focus on B):

B.eth0.ioam6_enabled = 1 // enable IOAM *on input* for B.eth0
B.eth0.ioam6_id = B1
B.eth1.ioam6_id = B2

Back to your suggestion, if I only had one field (i.e., ioam6_id != 0 to enable IOAM), I would end up with:

B.eth0.ioam6_id = B1 // (!= 0)
B.eth1.ioam6_id = B2 // (!= 0)

Which means in this case that IOAM would also be enabled on B for the reverse path. So we definitely need two fields to distinguish both the status (enabled/disabled) and the IOAM ID of an interface.
