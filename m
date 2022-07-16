Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3EE576DA5
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiGPLyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiGPLye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:54:34 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F44C1ADAD;
        Sat, 16 Jul 2022 04:54:33 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 11A86C01F; Sat, 16 Jul 2022 13:54:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657972472; bh=oyzbxOjURZ0sFk365mtqWl8JBCEDiqGZxcNXeEMsT4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTuav0noZipklwA8bzqnj5tv4mKEY/2s8JJZcOqZTzWM5zOLUjVgq4ZwVzXibCYXL
         ujsxDfewBtJX6MszlGqcoPzGRg77pxv744xcy5a6HhAGt2V+4rQh2FJ8lHkKnJOeD1
         j7oslirO2G9r3Xgvh7C3MZHjePs9LFemuT9yJwRqIT/Xbc167gU3CM0vWV2ZyoliVq
         glqhJit882MOG+3O5p7C5M5GR6oAuDDaaRa0YLRqpQwIfeE5dbAhGIPPROfgOW1t4y
         TnNVxeyP09VB8diaTLdZQeuVUewBvKmZWnJtBOOGnbxZQ6NZ97p+jH4rwi1x2LmFaT
         yJV71IlJuWJMg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id ED385C009;
        Sat, 16 Jul 2022 13:54:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657972470; bh=oyzbxOjURZ0sFk365mtqWl8JBCEDiqGZxcNXeEMsT4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bld0kl0VgpSaUjA5HAkcvXSoUmgcsntrTLjvZEUOuiCkia1Tif3oQ/9p6tnZD35Te
         3KWJk4/1dICn8jeT2R2Xx8L09PmHGbKc7aY9IN5Q7X1OFDgknMh7DcJRyQnbukVzNH
         /L9VTeBI/DG9vxHHXJk1OH7QUPpdwLW6FWANWYCaYsSln5eag0Y/IEBgd/6hlS5dAt
         SfacHPI7NKPeZ8+rAV3BUbMKgLz/aVlc8h7NxqzPDV2zIGdxZnD76rDBRdowCpuN+r
         ENBFJ/qCZvoOPQCwZgjblzCCK04F+JHO72kyO7T+gPHdKj5Kh0dZ1qcS7zrNYGbb3H
         0gjELFezLS5tQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 5bf80499;
        Sat, 16 Jul 2022 11:54:23 +0000 (UTC)
Date:   Sat, 16 Jul 2022 20:54:08 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Message-ID: <YtKm4M8W+rL+buNj@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <YtHqlVx9/joj+AXH@codewreck.org>
 <YtH4M9GvVdAsSCz2@codewreck.org>
 <6713865.4mp09fW1HV@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6713865.4mp09fW1HV@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sat, Jul 16, 2022 at 11:54:29AM +0200:
> > Looks good to me, I'll try to get some tcp/rdma testing done this
> > weekend and stash them up to next
> 
> Great, thanks!

Quick update on this: tcp seems to work fine, I need to let it run a bit
longer but not expecting any trouble.

RDMA is... complicated.
I was certain an adapter in loopback mode ought to work so I just
bought a cheap card alone, but I couldn't get it to work (ipoib works
but I think that's just the linux tcp stack cheating, I'm getting unable
to resolve route (rdma_resolve_route) errors when trying real rdma
applications...)


OTOH, linux got softiwarp merged in as RDMA_SIW which works perfectly
with my rdma applications, after fixing/working around a couple of bugs
on the server I'm getting hangs that I can't reproduce with debug on
current master so this isn't exactly great, not sure where it goes
wrong :|
At least with debug still enabled I'm not getting any new hang with your
patches, so let's call it ok...?

I'll send a mail to ex-collegues who might care about it (and
investigate a bit more if so), and a more open mail if that falls
short...

--
Dominique
