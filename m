Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF77C443103
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhKBPBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhKBPBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 11:01:12 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDED3C061714;
        Tue,  2 Nov 2021 07:58:37 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D5208C022; Tue,  2 Nov 2021 15:58:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635865115; bh=rSQJMUu/Sf6moJ2SUGd9pxO0TmpP6niHHHxwBJHGIfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DuQRAi024wq8Z+7KnDA7YPWNYoEd5mHmS6bzQF667QbQZ5x6Ef9uzDCG4Y8iJhf3Z
         ca+Tw9ABAtgqZ1p4UnCCDqi9M42dLqp0azDFvEzV3XcP1ct9to2Bf2XHuqzXlb9d11
         FdkIGlezPLD/HAgKRdKvAsLtri2GAESS1dlBgOtuaIiTUsrYYo7zdDlUbzti8luehH
         7TbTQCq9/43RCWPSpoOLwWo46RdhJR33ktsyOuYTI6XiOT9B5FND5FPYF38NWywq4n
         gfdYqa3ngAcQDPZSlR/U0BGmNyDRpoIiqk6Gkj42fXk6cBsK+iaiT96DOUecWjcIPY
         eQaBGQtvT58hA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7A857C009;
        Tue,  2 Nov 2021 15:58:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635865112; bh=rSQJMUu/Sf6moJ2SUGd9pxO0TmpP6niHHHxwBJHGIfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=35bAd15JzTIWvbg+dc/k7SeRIfdoy2bZtmjilRkhlwMZA/1ajeEQHh/W1dBho1C4b
         xANvENZz9S4XjWhYnW3W6QeRohSgLnkMdNrWMO6HB6vbVZnGUWpeOzrMG12oaGXuAx
         W/vBsTNMg8RdzazfyrUGDy9MvWJ8E4q+W8hi8UgldrDstB5Lv4XOYrxuYJpkES+nmj
         LmK6jrLpElbpS1f2wctew4gOLbdwpE7Ogu6OmxXXWEII0uFeqexd96r3x2yxUitJ0J
         5f4yZ5n9LTYT0IvoKu1ES+H8NO5T8KJq5PmIehNUSYr5tqcfCoA/y+/p3lGWhnAaqf
         K5pHT6vWCYrPA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id bb0e0d0d;
        Tue, 2 Nov 2021 14:58:27 +0000 (UTC)
Date:   Tue, 2 Nov 2021 23:58:12 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYFSBKXNPyIIFo7J@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
 <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Weißschuh wrote on Tue, Nov 02, 2021 at 03:49:32PM +0100:
> > I guess it wouldn't hurt to have 9p-tcp 9p-unix and 9p-fd aliases to the
> > 9pnet module, but iirc these transports were more closely tied to the
> > rest of 9pnet than the rest so it might take a while to do and I don't
> > have much time for this right now...
> > I'd rather not prepare for something I'll likely never get onto, so
> > let's do this if there is progress.
> > 
> > Of course if you'd like to have a look that'd be more than welcome :-)
> 
> If you are still testing anyways, you could also try the attached patch.
> (It requires the autload patch)
> 
> It builds fine and I see no reason for it not to work.

Thanks! I'll give it a spin.


I was actually just testing the autoload one and I can't get it to work
on my minimal VM, I guess there's a problem with the usermodhelper call
to load module..

with 9p/9pnet loaded,
running "mount -t 9p -o trans=virtio tmp /mnt"
request_module("9p-%s", "virtio") returns -2 (ENOENT)

Looking at the code it should be running "modprobe -q -- 9p-virtio"
which finds the module just fine, hence my supposition usermodhelper is
not setup correctly

Do you happen to know what I need to do for it?

I've run out of time for today but will look tomorrow if you don't know.

(And since it doesn't apparently work out of the box on these minimal
VMs I think I'll want the trans_fd module split to sit in linux-next
for a bit longer than a few days, so will be next merge window)


Thanks,
-- 
Dominique
