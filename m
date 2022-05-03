Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7136518233
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 12:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiECKZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 06:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiECKZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 06:25:21 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44FA55AB;
        Tue,  3 May 2022 03:21:48 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 60B20C022; Tue,  3 May 2022 12:21:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1651573307; bh=dsiFLdFkeDL9R7Ag/77dSPiK8kJjT3gJ12I5PBBLWMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mFQkW6uZqX0RIsVpCmxgtFaUBLIe/wq7Bxpf8DXliUeePzWc3mMO1f4YxrhArGXFN
         ATtI2HtMfiJNISQAy0UMZV+sIQWDrjFFC0VH1TAvPSpvpzUEZDDashpFXTrtnZYY0a
         qvXrwQW8sE+/UNt4yQ8in2q8loGdi1Z6jzd45UyJ2GW6RNMEnvi9y18TyHgjSaCpWV
         ju0q7OA4zXoQTGfcxQs3MWQHHKutjW+Visb89A1jZ3lmgJ1DoaPtxhLaAd94pGllx4
         og6oQBGu4oq1LKI9jrMn2vkVyK4KLQj+CUfYQJ2Uxj044xnOeYQJbQK8LZ8JrO5vvN
         Y/ch8TWqJlZxg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 4D1AAC01A;
        Tue,  3 May 2022 12:21:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1651573305; bh=dsiFLdFkeDL9R7Ag/77dSPiK8kJjT3gJ12I5PBBLWMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjYR2HkYno4RqtWouAgZjnwfO53ln561f/qJOCTV8qucrvXcGNvatLLjcmqN1F8jn
         WZQAnp8lROzBTVR/BQrN6rjcZ0HaBBTGMFxPGBKx44ZDQZCmRwRLAvoYgGvtYhDsa0
         +vlabBqj+Xb1oelf6JaPbImmChLqGkKUVz0gNPhvBykA9nyAzPJMvdWIsA33ViBCQC
         QnGkmJfHYDZUyskqwy2wBEKM2qNuJSSww4X59nJeR7chXaGN64yGg0YXYN3wOpHdXF
         p5HLSgg8N1PnirV1BPLNF2mmBY378T9TTl2WValg9GC3Q5F8fFDeEJNcgWQ8HFDtSa
         M+nJpPvqm+gCA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 861edad9;
        Tue, 3 May 2022 10:21:38 +0000 (UTC)
Date:   Tue, 3 May 2022 19:21:23 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Howells <dhowells@redhat.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark
 (was: 9p fscache Duplicate cookie detected))
Message-ID: <YnECI2+EAzgQExOn@codewreck.org>
References: <YmKp68xvZEjBFell@codewreck.org>
 <1817268.LulUJvKFVv@silver>
 <3174158.1650895816@warthog.procyon.org.uk>
 <1817722.O6u07f4CCs@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1817722.O6u07f4CCs@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the delay.

Christian Schoenebeck wrote on Tue, Apr 26, 2022 at 05:38:30PM +0200:
> On Montag, 25. April 2022 16:10:16 CEST David Howells wrote:
> > There may be a quick and dirty workaround.  I think the problem is that
> > unless the O_APPEND read starts at the beginning of a page, netfs is going
> > to enforce a read.  Does the attached patch fix the problem?  (note that
> > it's untested)

It might work for this particular case (O_APPEND), but what about an
arbitrary pwrite or seek+write in the middle of a file?
e.g.

$ dd if=/dev/zero of=test bs=1M count=1
$ chmod 400 test
# drop cache or remound
$ dd if=/dev/urandom of=test bs=102 seek=2 count=1 conv=notrunc
dd: error writing 'test': Bad file descriptor


Silly question, how does that work on ceph or AFS? the read back
callback always works regardless of permission?

Basically I think we really only have two choices there:
 - make the readback call work regardless of open mode, e.g. make it use
the writeback fid if it wasn't, and make that writeback_fid all-able

Now I'm looking, v9fs_writeback_fid() calls
v9fs_fid_lookup_with_uid(GLOBAL_ROOT_UID) and opens with O_RDWR, so it
shoud be a root fid we can read regardles of file perm !

The more I think about it and the more I think that's the way to go and
probably how it used to work, I'll look into why this isn't working
(main fid used or writeback fid not root)


 - add some complex code to track the exact byte range that got updated
in some conditions e.g. WRONLY or read fails?
That'd still be useful depending on how the backend tracks file mode,
qemu as user with security_model=mapped-file keeps files 600 but with
passthrough or none qemu wouldn't be able to read the file regardless of
what we do on client...
Christian, if you still have an old kernel around did that use to work?


> Patch doesn't apply for me on master:

It applies on fscache-next
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=fscache-next

But on that branch with the patch (works fine without) I get another
problem just writing normally:
[   94.327094] ------------[ cut here ]------------
[   94.327809] WARNING: CPU: 0 PID: 93 at mm/page-writeback.c:2498 __folio_mark_dirty+0x397/0x510
[   94.329191] Modules linked in:
[   94.329491] CPU: 0 PID: 93 Comm: cat Not tainted 5.18.0-rc1+ #56
[   94.330195] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[   94.331709] RIP: 0010:__folio_mark_dirty+0x397/0x510
[   94.332312] Code: 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 14 01 00 00 44 8b 7b 5c 44 89 3c 24 4c 89 fd 49 63 d7 e9 4d fe ff ff <0f> 0b e9 c0 fc ff f0
[   94.335341] RSP: 0018:ffffc90000257ad0 EFLAGS: 00010046
[   94.336031] RAX: 4000000000000009 RBX: ffffea0001ffb080 RCX: ffffffff815144cc
[   94.336937] RDX: 1ffffd40003ff610 RSI: 0000000000000008 RDI: ffffea0001ffb080
[   94.337749] RBP: ffff8880056c4488 R08: 0000000000000000 R09: ffffea0001ffb087
[   94.338612] R10: fffff940003ff610 R11: 0000000000000001 R12: 0000000000000246
[   94.339551] R13: ffff8880056c4490 R14: 0000000000000001 R15: 0000000000000068
[   94.340487] FS:  00007f18dbc1eb80(0000) GS:ffff88806ca00000(0000) knlGS:0000000000000000
[   94.341558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   94.342369] CR2: 00007f18dbbfd000 CR3: 000000000b5b4000 CR4: 00000000000006b0
[   94.343613] Call Trace:
[   94.343856]  <TASK>
[   94.344052]  filemap_dirty_folio+0x73/0xc0
[   94.344646]  v9fs_write_end+0x18f/0x300
[   94.345195]  generic_perform_write+0x2bd/0x4a0
[   94.345834]  ? __bpf_trace_file_check_and_advance_wb_err+0x10/0x10
[   94.346807]  ? discard_new_inode+0x100/0x100
[   94.347398]  ? generic_write_checks+0x1e8/0x360
[   94.347926]  __generic_file_write_iter+0x247/0x3d0
[   94.348420]  generic_file_write_iter+0xbe/0x1d0
[   94.348885]  new_sync_write+0x2f0/0x540
[   94.349250]  ? new_sync_read+0x530/0x530
[   94.349634]  vfs_write+0x517/0x7b0
[   94.349939]  ksys_write+0xed/0x1c0
[   94.350318]  ? __ia32_sys_read+0xb0/0xb0
[   94.350817]  do_syscall_64+0x43/0x90
[   94.351257]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   94.351955] RIP: 0033:0x7f18dbe0eea3
[   94.352438] Code: 54 ff ff 48 83 c4 58 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 75
[   94.355597] RSP: 002b:00007fffdf4661d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   94.356520] RAX: ffffffffffffffda RBX: 0000000000000068 RCX: 00007f18dbe0eea3
[   94.357392] RDX: 0000000000000068 RSI: 00007f18dbbfd000 RDI: 0000000000000001
[   94.358287] RBP: 00007f18dbbfd000 R08: 00007f18dbbfc010 R09: 0000000000000000
[   94.359318] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000001
[   94.360349] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000020000
[   94.361295]  </TASK>
[   94.361462] ---[ end trace 0000000000000000 ]---

got it with cat but dd with bs >=2 also reproduces, the second write
fails with EBADF:

110   openat(AT_FDCWD, "bar", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
110   dup2(3, 1)                        = 1
110   close(3)                          = 0
110   execve("/run/current-system/sw/bin/cat", ["cat"], 0x12e1010 /* 10 vars */) = 0
110   read(0, "[   94.327094] ------------[ cut"..., 131072) = 52
110   write(1, "[   94.327094] ------------[ cut"..., 52) = 52
110   read(0, "[   94.327809] WARNING: CPU: 0 P"..., 131072) = 98
110   write(1, "[   94.327809] WARNING: CPU: 0 P"..., 98) = -1 EBADF (Bad file descriptor)

I'm sure that could be fixed, but as said above I don't think it's the
right approach.

> > Also, can you get the contents of /proc/fs/fscache/stats from after
> > reproducing the problem?
> 
> FS-Cache statistics

(He probably wanted to confirm the new trace he added got hit with the
workaround pattern, I didn't get that far as I couldn't compile my
reproducer on that fs...)

-- 
Dominique
