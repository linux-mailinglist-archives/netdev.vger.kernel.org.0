Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE54011E0
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 00:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbhIEVtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 17:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhIEVtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 17:49:32 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66B8C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 14:48:28 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 98BF3C01E; Sun,  5 Sep 2021 23:48:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630878506; bh=E3CpFhtC5vZdsCCmZ25m/Icoi/10FRhH19d0kLWps/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AvwqISm8tHyi7uwJZy/sRkbOK2DSvXMR7MMTf3BgR+Hfz9ci8qUEey51WG85yA2lM
         D01vq11bj+IbWEcjdakG9liAzhmKDrZ6LMd1OXZFrrG6GQvf33zCOUqZaxAdnKbUB5
         rnzRcqq4jU/y1P8S51+Zn9hGDXCowNndtedhqteAZGICHUQtBF4xDjxDX7Sq2tYW9C
         8cKDZ0WUZsPv6Z/oKj0W49sfelE/DOsOOneTj2lEnzfAvtFUKbIxzcy2uTyq/346Sj
         sGtKO3VcPdhi5lHMx+WgL8NpIangdXdUhenDoWfzZ7B2mk9mtxRSpcRsb016R6Rfjl
         r5/0aaaybLS2w==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C6765C009;
        Sun,  5 Sep 2021 23:48:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630878505; bh=E3CpFhtC5vZdsCCmZ25m/Icoi/10FRhH19d0kLWps/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4CL7BhJI3+/9BdgSTesaCP+qvtXQ75E8qqHG0CINLg2YTwlrgaEAq1rZfDBGn1hkY
         RBR8Qur9gUfRKV7s5ZtFkbB4tMsoIMq7RmXM8LD9+eDAuHZDwY/wTIypYJ7Q5B6gl7
         nRUkPY14t+jl8St3CMSk+bqySpXn5vl+YvwycR4INR9E+TQ5fWdNOnR1PTxm0spPRX
         awwm8HSzDr8dM71yvzfX7b2qIfe0CudB0vTTlBJXmbT1NazXj/YnbbyIKFrhCyId9X
         wH1Wi1hjU9AwyZxGPUWgRaaOeB9BZullsYIijlt9w1xw4qHYVv938IwsC9+6DsFu0N
         6LL+byxytgduQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 39a969f2;
        Sun, 5 Sep 2021 21:48:19 +0000 (UTC)
Date:   Mon, 6 Sep 2021 06:48:04 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH 2/2] net/9p: increase default msize to 128k
Message-ID: <YTU7FJuooYSjISlq@codewreck.org>
References: <cover.1630770829.git.linux_oss@crudebyte.com>
 <61ea0f0faaaaf26dd3c762eabe4420306ced21b9.1630770829.git.linux_oss@crudebyte.com>
 <YTQB5jCbvhmCWzNd@codewreck.org>
 <1915472.2DI3jHSlUk@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1915472.2DI3jHSlUk@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sun, Sep 05, 2021 at 03:33:11PM +0200:
> > Subject: [PATCH] net/9p: increase tcp max msize to 1MB
> 
> Yes, makes sense.
> 
> Is the TCP transport driver of the Linux 9p client somewhat equally mature to 
> the virtio transport driver? Because I still have macOS support for 9p in QEMU 
> on my TODO list and accordingly a decision for a specific transport type for 
> macOS will be needed.

I'd say it should be just about as stable as virtio.. It's definitely
getting a lot of tests like syzcaller as it's easy to open an arbitrary
fd and pass that to kernel for fuzzing.

Performance-wise you won't have zero-copy, and the monolitic memory
blocks requirement is the same, so it won't be as good as virtio but it
can probably be used. The problem will more be one of setting -- for
user networking we can always use qemu's networking implementation, but
for passthrough or tap qemu won't easily be discoverable from the VM,
I'm not sure about that.
Does AF_VSOCK work on macos? that could probably easily be added to
trans_fd...

> For the next series mentioned by me (getting rid of the 512k msize capping) I 
> first need to readup on the Linux kernel code. According to the discussion we 
> already had about that issue, the reason for that capping was that the amount 
> of virtio elements is currently hard coded in the Linux client's virtio 
> transport:
> 
> On Samstag, 27. Februar 2021 01:03:40 CEST Dominique Martinet wrote:
> > Christian Schoenebeck wrote on Fri, Feb 26, 2021 at 02:49:12PM +0100:
> > > Right now the client uses a hard coded amount of 128 elements. So what
> > > about replacing VIRTQUEUE_NUM by a variable which is initialized with a
> > > value according to the user's requested 'msize' option at init time?
> > > 
> > > According to the virtio specs the max. amount of elements in a virtqueue
> > > is
> > > 32768. So 32768 * 4k = 128M as new upper limit would already be a
> > > significant improvement and would not require too many changes to the
> > > client code, right?
> > The current code inits the chan->sg at probe time (when driver is
> > loader) and not mount time, and it is currently embedded in the chan
> > struct, so that would need allocating at mount time (p9_client_create ;
> > either resizing if required or not sharing) but it doesn't sound too
> > intrusive yes.
> > 
> > I don't see more adherenences to VIRTQUEUE_NUM that would hurt trying.
> 
> So probably as a first step I would only re-allocate the virtio elements 
> according to the user supplied (i.e. large) 'msize' value if the 9p driver is 
> not in use at that point, and stick to capping otherwise. That should probably 
> be fine for many users and would avoid need for some synchronization measures 
> and the traps it might bring. But again, I still need to read more of the 
> Linux client code first.

Right, looking at it again p9_virtio_create would already allow that so
you just need to pick the most appropriate channel or create a new one
if required, synchronization shouldn't be too much of a problem.

The 9p code is sometimes impressive in its foresight ;)

> BTW just in case I have not mentioned it before: there are some developer docs 
> for the QEMU 9p server implementation now:
> https://wiki.qemu.org/Documentation/9p

Wow, that's an impressive wiki page.
I've never been good with documentation (be it writing or using it), but
hopefully it'll help people make the first step -- good work!

-- 
Dominique
