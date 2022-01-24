Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE2498000
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiAXM4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiAXM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:56:45 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428AEC06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:56:45 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B572FC020; Mon, 24 Jan 2022 13:56:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643029001; bh=6JseWqubkmwnt9lHAQktZszwisBSVcxFLmnfh66TQgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GzOavpODz14oqxbv5RbdR2wLXq7pTEcI5u52H8PadYg0JmPfnhk9oeWKJfZBn8vkB
         I4MsutqTgDaVtMyvRpwLbWYRwycqZwYHIjGoyUxzTT/IyixGRlMH5w27qKi4Guh4md
         Ljuc5UaY10+V3Jfe/MGnYbWa65xJdr4AJlG6QBCDig2ShklBcd+u+XuYMVoJl4v+Hj
         hVd/j1AzpEDvjhvfHiTTnvBCWyVJ3SHCbLo2I8P3aycgn7D5q7i41+Ij4vUDRevgil
         iSv/0fCxf28N/66hLsQhwmG/ck0RRLj49nB4nid8Oby+JWeEe8keFyboDZMUIq0WLh
         UXTrClGc+YaWg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3EE97C009;
        Mon, 24 Jan 2022 13:56:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643029000; bh=6JseWqubkmwnt9lHAQktZszwisBSVcxFLmnfh66TQgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYbYbt/ayX1dCV2uNBYlm4FO5W0WDRsU+1mzAuT1ae9ai3t+B4Us7miCxTydHAqct
         cSLnGZUa0J9eRHFJ2Z4c7mvhv4uwvBFIXmjQkz+ATLe0b/ULwo5ZQtuIpr8b6CVumQ
         lJ7dO4pOhJjqUTxtzGXCFdY+XlsIiJt8qAP0iQtDFoubx4E8R3iKHZin0dhO60O5jr
         pue+e51LHe4ybTtwchjHKulBLYkT50roiafWWo1dCB4Rfj0I5JA8frBzYk79GH1TOa
         kpgLpdxAKw3dScYBZi+6HGhgFVV4UyIKJeDgN5TJaxZax9F69ROTjjztamMyk5SbCx
         ELo51HZsZFS/g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a5f2f446;
        Mon, 24 Jan 2022 12:56:32 +0000 (UTC)
Date:   Mon, 24 Jan 2022 21:56:17 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Message-ID: <Ye6h8U/NJcx3ErHa@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
 <Ye6IaIqQcwAKv0vb@codewreck.org>
 <22204794.ZpPF1Y2lYg@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22204794.ZpPF1Y2lYg@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Mon, Jan 24, 2022 at 12:57:35PM +0100:
> > We're just starting a new development cycle for 5.18 while 5.17 is
> > stabilizing, so this mostly depends on the ability to check if a msize
> > given in parameter is valid as described in the first "STILL TO DO"
> > point listed in the cover letter.
> 
> I will ping the Redhat guys on the open virtio spec issue this week. If you 
> want I can CC you Dominique on the discussion regarding the virtio spec 
> changes. It's a somewhat dry topic though.

I don't have much expertise on virtio stuff so don't think I'll bring
much to the discussion, but always happy to fill my inbox :)
It's always good to keep an eye on things at least.

> > I personally would be happy considering this series for this cycle with
> > just a max msize of 4MB-8k and leave that further bump for later if
> > we're sure qemu will handle it.
> 
> I haven't actually checked whether there was any old QEMU version that did not 
> support exceeding the virtio queue size. So it might be possible that a very 
> ancient QEMU version might error out if msize > (128 * 4096 = 512k).

Even if the spec gets implemented we need the default msize to work for
reasonably older versions of qemu (at least a few years e.g. supported
versions of debian/rhel can go quite a while back), and ideally have a
somewhat sensible error if we go above some max...

> Besides QEMU, what other 9p server implementations are actually out there, and 
> how would they behave on this? A test on their side would definitely be a good 
> idea.

9p virtio would only be qemu as far as I know.

For tcp/fd there are a few:
 - https://github.com/chaos/diod (also supports rdma iirc, I don't have
any hardware for rdma tests anymore though)
 - https://github.com/nfs-ganesha/nfs-ganesha (also rdma)
 - I was pointed at https://github.com/lionkov/go9p in a recent bug
report
 - http://repo.cat-v.org/libixp/ is also a server implementation I
haven't tested with the linux client in a while but iirc it used to work


I normally run some tests with qemu (virtio) and ganesha (tcp) before
pushing to my linux-next branch, so we hopefully don't make too many
assumptions that are specific to a server


> > We're still seeing a boost for that and the smaller buffers for small
> > messages will benefit all transport types, so that would get in in
> > roughly two months for 5.18-rc1, then another two months for 5.18 to
> > actually be released and start hitting production code.
> > 
> > 
> > I'm not sure when exactly but I'll run some tests with it as well and
> > redo a proper code review within the next few weeks, so we can get this
> > in -next for a little while before the merge window.
> 
> Especially the buffer size reduction patches needs a proper review. Those 
> changes can be tricky. So far I have not encountered any issues with tests at 
> least. OTOH these patches could be pushed through separately already, no 
> matter what the decision regarding the virtio issue will be.

Yes, I've had a first look and it's quite different from what I'd have
done, but it didn't look bad and I just wanted to spend a bit more time
on it.
On a very high level I'm not fond of the logical duplication brought by
deciding the size in a different function (duplicates format strings for
checks and brings in a huge case with all formats) when we already have
one function per call which could take the size decision directly
without going through the format varargs, but it's not like the protocol
has evolved over the past ten years so it's not really a problem -- I
just need to get down to it and check it all matches up.

I also agree it's totally orthogonal to the virtio size extension so if
you want to wait for the new virtio standard I'll focus on this part
first.

-- 
Dominique
