Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15044FB0BB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 00:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbiDJW51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 18:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiDJW50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 18:57:26 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6503912628;
        Sun, 10 Apr 2022 15:55:13 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 136C5C01F; Mon, 11 Apr 2022 00:55:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1649631311; bh=/TFwqpjQ2c/XbjkybhTOL9F0BbKaoZelQEB5XR4NO2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DdQxknF8c5E5y8Rt9M4hIiL0IdYl/WjsghQKDKUicOg2ozLRQ+Lpql7urObG9Stu5
         a9jYN+cO+ttNsovxzf6TkRls+9zk+PDEsdQFTc63+sM8HAIVGPHfZ9ppFFScTNNWrN
         Uz7mVQ/VqIm5m4BUzR+kljWEdWlxlDUoDdxTyzsEMT3P/bzQMQsdGtYidHwUerTWgD
         kv3UNnBleyoCrJThHoDLA4+L39fT8eLNnBN/1Q2b+Lq1TDsv5R2jpYWM4yRHSUw5v7
         6Xc3TbJ+QYsQXUvc1qfC0KjonUgxeI7bZlVd4GOQUN/pbR1YROG7K/fJ4OXXB4zunD
         JuL5Ke5IpHhvQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D0851C009;
        Mon, 11 Apr 2022 00:55:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1649631309; bh=/TFwqpjQ2c/XbjkybhTOL9F0BbKaoZelQEB5XR4NO2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGgeP9srjGzbGXebFnW4o1uQvo4gSg4sDgWNrBgx4It6QGoYDvUbXfhPMltb2yzF/
         bXYxoQ66FJTeUxtrpdt03RTFG2uJD7Yvyx3XZoOK19tVmrXi3z1bP10Oc/TnRixAJd
         ANrmPMiPo0yciuRP5ZHe6r0k1BffxmVY8TI2Y9TsIy4kUYsfFucTBsTFQxcND01zfb
         Jf2pcssq5x/vOmI9OT8kXPFPyN+Zj9I22GXBy40UUwj7fsMx6AqAu3ALS6rrS0dSoM
         wrFvP7T4NykSc8jSyc+yvWBxchNi2/sAYqMpHVkaWZYyVMWEeyG+MUkIsnobagZxmS
         MrzAGANLqN13Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4ae191f4;
        Sun, 10 Apr 2022 22:55:02 +0000 (UTC)
Date:   Mon, 11 Apr 2022 07:54:47 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie
 detected)
Message-ID: <YlNgN5f1KnT1walD@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3791738.ukkqOL8KQD@silver>
 <9591612.lsmsJCMaJN@silver>
 <1966295.VQPMLLWD4E@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1966295.VQPMLLWD4E@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for keeping it up!

Christian Schoenebeck wrote on Sun, Apr 10, 2022 at 06:18:38PM +0200:
> > I used git-bisect to identify the commit that broke 9p behaviour, and it is
> > indeed this one:
> > 
> > commit eb497943fa215897f2f60fd28aa6fe52da27ca6c (HEAD, refs/bisect/bad)
> > Author: David Howells <dhowells@redhat.com>
> > Date:   Tue Nov 2 08:29:55 2021 +0000
> > 
> >     9p: Convert to using the netfs helper lib to do reads and caching

Yes, quite a few things changed with that.

> I looked into the errors I get, and as far as I can see it, all misbehaviours
> that I see, boil down to "Bad file descriptor" (EBADF) errors being the
> originating cause.
> 
> The easiest misbehaviours on the guest system I can look into, are errors
> with the git client. For instance 'git fetch origin' fails this way:

FWIW I didn't report but did try to reproduce, on my machines (tried a
couple) booting on a small alpine rootfs over 9p works, and I tried some
git clone/git fetch of variying sizes of local repo (tmpfs in VM -> 9p
mount of tmpfs on host) to no avail.
Perhaps backing filesystem dependant? qemu version? virtfs access options?

It's all extremely slow though... like the final checkout counting files
at less than 10/s

> ...
> write(3, "d16782889ee07005d1f57eb884f4a06b"..., 40) = 40
> write(3, "\n", 1)                       = 1
> close(3)                                = 0
> access(".git/hooks/reference-transaction", X_OK) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, ".git/logs/refs/remotes/origin/master", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
> openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 7
> fstat(7, {st_mode=S_IFREG|0644, st_size=2326, ...}) = 0
> fstat(7, {st_mode=S_IFREG|0644, st_size=2326, ...}) = 0
> read(7, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0"..., 8192) = 2326
> lseek(7, -1467, SEEK_CUR)               = 859
> read(7, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0"..., 8192) = 1467
> close(7)                                = 0
> write(3, "d8a68c5027ef629d93b9d9519ff4da95"..., 168) = -1 EBADF (Bad file descriptor)
> ...
> error: cannot update the ref 'refs/remotes/origin/master': unable to append to '.git/logs/refs/remotes/origin/master': Bad file descriptor
> 
> I tried to manually replicate those file access operations on that
> .git/logs/refs/remotes/origin/master file in question, and it worked. But when
> I look at the strace output above, I see there is a close(3) call just before
> the subsequent openat(".git/logs/refs/remotes/origin/master") call returning 3,
> which makes me wonder, is this maybe a concurrency issue on file descriptor
> management?

hmm, in cache=loose case write should just be updating the page cache
for buffers to be flushed later, so this is definitely weird.

If you can reproduce well enough for this, could you first confirm that
the EBADF comes from the client and not qemu? either mounting with debug
or getting traces from qemu at a protocol level would get that.

If it's local there are only so many places EBADF can come from and it
should be possible to trace it back with e.g. perf probe or bpftrace,
but even if we confirm that e.g. the process' fd table is messed up it
won't tell us why it was, so it's going to be annoying... I'd really
like to be able to reproduce this somehow :/

-- 
Dominique

