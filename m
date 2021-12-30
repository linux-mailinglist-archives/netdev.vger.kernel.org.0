Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D5481E57
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbhL3QuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:50:25 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:44905 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbhL3QuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:50:25 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 377C2202C9C7;
        Thu, 30 Dec 2021 17:50:23 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 377C2202C9C7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640883023;
        bh=MRmSK9Rvy/A1n5pt24GkQwThmC9VNyEkDUFAU4t8h7w=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=yZbe9UZ9jAA0FzKIxLxY096M8bNqHTL4/eWM2skCMzQX5gbaml3mC0EIJ3R9UPq+2
         lWTEpMdCfuDaa8yOQPvwhjenHFi5MI1R1+6ilQM8MZPjApHrd/F8GQ+I/4GjvY/XVV
         0dkVwnpIC2isWgerONj7I34ogu6x8LNySRPnQggF2W+ympNszy05wmC83FsC9dFcGb
         IAaLibK9FHENI7nT9MPipfeX5H/wpNHn60p1NiDibuGTYJZxfa7zLvdczkjpBRaFGP
         BBXAACen23nT9DufxvI9s/zQU2ohEy2rzEv/mdS7sS51lmgRJYHSl5CkZ2R38yeaWj
         O0KQn7g5dVaVQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2F2C3606067D3;
        Thu, 30 Dec 2021 17:50:23 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yTmORLcG5z16; Thu, 30 Dec 2021 17:50:23 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 1890A6008D70E;
        Thu, 30 Dec 2021 17:50:23 +0100 (CET)
Date:   Thu, 30 Dec 2021 17:50:23 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Message-ID: <619801978.249725003.1640883023013.JavaMail.zimbra@uliege.be>
In-Reply-To: <Yc3GeyeVliLWC7El@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be> <YcYJD2trOaoc5y7Z@shredder> <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be> <Ychiyd0AgeLspEvP@shredder> <462116834.246327590.1640523548154.JavaMail.zimbra@uliege.be> <Ychq4ggTdpVG24Zp@shredder> <751671897.247201108.1640614002305.JavaMail.zimbra@uliege.be> <Yc3GeyeVliLWC7El@shredder>
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Queue depth data field
Thread-Index: y8PfLR83AbmGS7nQ3hJRaDTAAdu71g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 30, 2021, at 3:47 PM, Ido Schimmel idosch@idosch.org wrote:
> On Mon, Dec 27, 2021 at 03:06:42PM +0100, Justin Iurman wrote:
>> On Dec 26, 2021, at 2:15 PM, Ido Schimmel idosch@idosch.org wrote:
>> > On Sun, Dec 26, 2021 at 01:59:08PM +0100, Justin Iurman wrote:
>> >> On Dec 26, 2021, at 1:40 PM, Ido Schimmel idosch@idosch.org wrote:
>> >> > On Sun, Dec 26, 2021 at 12:47:51PM +0100, Justin Iurman wrote:
>> >> >> On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
>> >> >> > Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
>> >> >> > seems that queue depth needs to take into account the size of the
>> >> >> > enqueued packets, not only their number.
>> >> >> 
>> >> >> The quoted paragraph contains the following sentence:
>> >> >> 
>> >> >>    "The queue depth is expressed as the current amount of memory
>> >> >>     buffers used by the queue"
>> >> >> 
>> >> >> So my understanding is that we need their number, not their size.
>> >> > 
>> >> > It also says "a packet could consume one or more memory buffers,
>> >> > depending on its size". If, for example, you define tc-red limit as 1M,
>> >> > then it makes a lot of difference if the 1,000 packets you have in the
>> >> > queue are 9,000 bytes in size or 64 bytes.
>> >> 
>> >> Agree. We probably could use 'backlog' instead, regarding this
>> >> statement:
>> >> 
>> >>   "It should be noted that the semantics of some of the node data fields
>> >>    that are defined below, such as the queue depth and buffer occupancy,
>> >>    are implementation specific.  This approach is intended to allow IOAM
>> >>    nodes with various different architectures."
>> >> 
>> >> It would indeed make more sense, based on your example. However, the
>> >> limit (32 bits) could be reached faster using 'backlog' rather than
>> >> 'qlen'. But I guess this tradeoff is the price to pay to be as close
>> >> as possible to the spec.
>> > 
>> > At least in Linux 'backlog' is 32 bits so we are OK :)
>> > We don't have such big buffers in hardware and I'm not sure what
>> > insights an operator will get from a queue depth larger than 4GB...
>> 
>> Indeed :-)
>> 
>> > I just got an OOO auto-reply from my colleague so I'm not sure I will be
>> > able to share his input before next week. Anyway, reporting 'backlog'
>> > makes sense to me, FWIW.
>> 
>> Right. I read that Linus is planning to release a -rc8 so I think I can
>> wait another week before posting -v3.
> 
> The answer I got from my colleagues is that they expect the field to
> either encode bytes (what Mellanox/Nvidia is doing) or "cells", which is
> an "allocation granularity of memory within the shared buffer" (see man
> devlink-sb).

Thanks for that. It looks like devlink-sb would be gold for IOAM. But
based on what we discussed previously with Jakub, it cannot be used here
unfortunately. So I guess we have no choice but to use 'backlog' and
therefore report bytes. Which is also fine anyway. Thanks again for your
helpful comments, Ido. I appreciate.
