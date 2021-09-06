Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF59401235
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIFAJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 20:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhIFAJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 20:09:28 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126B8C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 17:08:24 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D607DC01E; Mon,  6 Sep 2021 02:08:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630886898; bh=OeCX4dJpwBgitXOSpmPOmvNzOoK+lAbEx+BXVeu2QM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=17Fqq2Fo5jQOobm0vMf6lneLlkpDc5uxueDYcq1/GU3rsBSmycv9xTu8aZW3+hdPr
         fHaVmAu6ZbaPBGKN8BqbduccwhJ37y0xRln9YOUqM0kJFWZsXtR+Depfpte6tnclSP
         fy4NCB1YX3WYZT/jydnexd2eMi1fh1Nt5Q/13AlFcPDJHfouymV+Jr0OJZ+kD1+BWS
         fS7SAGBRPaZKoE8CcDL1zCaWEdeqoyTGQqu0IXFVQ3dSIjoJUyRyu2Y6Tit9QIIFYa
         D+ZhqkKNqcCDtxqr8eRRW1ip9405NF47N755hweocb1adesDKp4yqvlgDc9TNz0v1J
         Npdtr8yHM/Oxg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7E163C009;
        Mon,  6 Sep 2021 02:08:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630886897; bh=OeCX4dJpwBgitXOSpmPOmvNzOoK+lAbEx+BXVeu2QM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GynXHJhrXtydznYDXD1Zd+zU+gXHeODQ3ykenpx+yygjUyhg0FSE7pI2wmRoyRkjT
         VKwShy/ag4EWe87WDyF++0V0JFEqIQYxetyVBCwRCtjoXZTapoBQdd6A/LgmLmmdET
         nDv/i7yuaExhCV6h72kEy4LBI/JrseIKnR9Pcp/HEpCAf7ZETV6pAauYQk94Mmps+C
         BTkB63PnUNVZR9zuiwkACMD6HBNJ3RIsbdQaZtVK7TtZyyrk6KyuEyD1L7qtOKGoT4
         Tz0h175G7O25e46iELfV2+dO384GSxVRO1KYoSNZacG4uCrBZEytOUHEgKzbhBNvJL
         uII+8LHqv2afQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e8c97575;
        Mon, 6 Sep 2021 00:08:11 +0000 (UTC)
Date:   Mon, 6 Sep 2021 09:07:56 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Greg Kurz <groug@kaod.org>,
        Latchesar Ionkov <lucho@ionkov.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH 2/2] net/9p: increase default msize to 128k
Message-ID: <YTVb3K37JxUWUdXN@codewreck.org>
References: <cover.1630770829.git.linux_oss@crudebyte.com>
 <61ea0f0faaaaf26dd3c762eabe4420306ced21b9.1630770829.git.linux_oss@crudebyte.com>
 <YTQB5jCbvhmCWzNd@codewreck.org>
 <1915472.2DI3jHSlUk@silver>
 <YTU7FJuooYSjISlq@codewreck.org>
 <CAFkjPTkJFrqhCCHgUBsDiEVjpeJoKZ4gRy=G-4DpJo9xanpYaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFkjPTkJFrqhCCHgUBsDiEVjpeJoKZ4gRy=G-4DpJo9xanpYaA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Van Hensbergen wrote on Sun, Sep 05, 2021 at 06:44:13PM -0500:
> there will likely be a tradeoff with tcp in terms of latency to first
> message so while
> absolute bw may be higher processing time may suffer.  8k was default msize
> to more closely match it to jumbo frames on an ethernet.  of course all
> that intuition is close to 30 years out of date….

It's not because the max size is 128k (or 1MB) that this much is sent
over the wire everytime -- if a message used to fit in 8KB, then its
on-the-wire size won't change and speed/latency won't be affected for
these.

For messages that do require more than 8KB (read/write/readdir) then you
can fit more data per message, so for a given userspace request (feed me
xyz amount of data) you'll have less client-server round-trips, and the
final user-reflected latency will be better as well -- that's why
e.g. NFS has been setting a max size of 1MB by default for a while now,
and they allow even more (32MB iirc? not sure)

I've only had done these tests years ago and no longer have access to
the note that was written back then, but TCP also definitely benefits
from > 64k msize as long as there's enough memory available.


The downside (because it's not free) is there though, you need more
memory for 9p with big buffers even if we didn't need so much in the
first place.
The code using a slab now means that the memory is not locked per mount
as it used to, but that also means allocations can fail if there is a
big pressure after not having been released. OTOH as long as it's
consistently used the buffers will be recycled so it's not necessarily
too bad performance-wise in hot periods.

Ideally we'd need to rework transports to allow scatter-gather (iovec or
similar API), and work with smaller allocations batched together on
send, but I don't have time for something like that... If we do that we
can probably get the best of both worlds -- and could consider >1MB, but
that's unrealistic as of now, regardless of the transport.

-- 
Dominique
