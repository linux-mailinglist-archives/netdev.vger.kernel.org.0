Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025634FEB7A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiDLX0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiDLX0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:26:25 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6007F21A;
        Tue, 12 Apr 2022 15:38:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 1E89CC023; Wed, 13 Apr 2022 00:38:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1649803125; bh=8cKWiKZ+6BTHDIeYecZe923WDWd/fUmOnyJCVtqwQRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mS9vU0aqfwqdsVmn1+fa/0vv8poCioV3NJDSA17DNm9q9Ze0nYISH8TNXvFDpAMS8
         C4Jc6ONlOhQfqyomQD967RYDtuMwtHtWEGhzGcdfmWkYwbwz4GXlYNGAQ8A9U7nqpJ
         CkpdLUAF64RbHktWdxuFbwQD4IFG4rk43Ro7+lFRMqwzTxNDwUYw2jHd2H9rz0Wpxe
         OnMPT1HdWwcZMohiiSfMzF+sFbXKSA3j3YVKpWwZ1/w3epl5Z5jpplVdN8ywCcm9g9
         0dGXaCsPK8357uBBuiXIE9F/syhLwChpq4NkvPhNozRKMyn6YEISHQQRWjauvMRSqs
         MmkfW+8OEuasA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7F9E9C009;
        Wed, 13 Apr 2022 00:38:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1649803123; bh=8cKWiKZ+6BTHDIeYecZe923WDWd/fUmOnyJCVtqwQRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIFkVHZ2ZiGbLOIJpIJcCiS1PLc/cPhwSWBrjYJf9pKPl7B7UmiOchF498QnFkb4y
         d6SAVmOieXRM32MCO7wMHOysrLbU/K7WSjFEzaHPQYYs3ShQxhorVvthNbdgA7A/fF
         otUGRti4jEfWxDr0jUP64iVY6uWuxbrL15XEvAWogBuvScpSDvwwSIkZP2ZokXAT+b
         bbNaKaUl153IEmtWTExOL35yYuFKLq4RYPdrr9w3DKTN1rFppUZO5r4/lqqHEpAkLv
         9iG0aoGGFsNboqQdBUgse5KM+QDo4HxXDYXCzGRqICleQEAS0qI8jNGqVTEIX5TVf5
         OQXfpP3fslG+Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4f5f244e;
        Tue, 12 Apr 2022 22:38:37 +0000 (UTC)
Date:   Wed, 13 Apr 2022 07:38:21 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie
 detected)
Message-ID: <YlX/XRWwQ7eQntLr@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <1966295.VQPMLLWD4E@silver>
 <YlNgN5f1KnT1walD@codewreck.org>
 <3119964.Qa6D4ExsIi@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3119964.Qa6D4ExsIi@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Mon, Apr 11, 2022 at 03:41:45PM +0200:
> I get more convinced that it's a bug on Linux kernel side. When guest is
> booted I always immediately get a read("/var/log/wtmp") = EBADF error on
> guest. And the 9p command sequence sent to QEMU 9p server were:

Yes, I'm not pointing fingers, just trying to understand :)

> 
> ...
> v9fs_clunk tag 0 id 120 fid 568
> v9fs_walk tag 0 id 110 fid 1 newfid 568 nwnames 1
> v9fs_rerror tag 0 id 110 err 2
> v9fs_walk tag 0 id 110 fid 26 newfid 568 nwnames 1
> v9fs_rerror tag 0 id 110 err 2
> v9fs_readlink tag 0 id 22 fid 474
> v9fs_readlink_return tag 0 id 22 name /run
> v9fs_readlink tag 0 id 22 fid 474
> v9fs_readlink_return tag 0 id 22 name /run
> v9fs_readlink tag 0 id 22 fid 474
> v9fs_readlink_return tag 0 id 22 name /run
> v9fs_readlink tag 0 id 22 fid 474
> v9fs_readlink_return tag 0 id 22 name /run
> v9fs_walk tag 0 id 110 fid 633 newfid 568 nwnames 1
> v9fs_rerror tag 0 id 110 err 2
> v9fs_walk tag 0 id 110 fid 875 newfid 568 nwnames 0
> v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
> v9fs_open tag 0 id 12 fid 568 mode 32769
> v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit 507904
> v9fs_walk tag 0 id 110 fid 875 newfid 900 nwnames 0
> v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
> v9fs_open tag 0 id 12 fid 900 mode 2
> v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit 507904
> v9fs_lock tag 0 id 52 fid 568 type 1 start 0 length 0
> v9fs_lock_return tag 0 id 52 status 0
> v9fs_xattrwalk tag 0 id 30 fid 568 newfid 901 name security.capability
> v9fs_rerror tag 0 id 30 err 95
> v9fs_read tag 0 id 116 fid 568 off 192512 max_count 256
> 
> So guest opens /var/log/wtmp with fid=568 mode=32769, which is write-only
> mode, and then it tries to read that fid 568, which eventually causes the
> read() call on host to error with EBADF. Which makes sense, as the file was
> opened in write-only mode, hence read() is not possible with that file
> descriptor.

Oh! That's something we can work on. the vfs code has different caches
for read only and read-write fids, perhaps the new netfs code just used
the wrong one somewhere. I'll have a look.

> The other things I noticed when looking at the 9p command sequence above:
> there is a Twalk on fid 568 before, which is not clunked before reusing fid
> 568 with Topen later. And before that Twalk on fid 568 there is a Tclunk on
> fid 568, but apparently that fid was not used before.

This one though is just weird, I don't see where linux would make up a fid to
clunk like this... Could messages be ordered a bit weird through
multithreading?
e.g. thread 1 opens, thread 2 clunks almost immediately afterwards, and
would be printed the other way around?
Should still be serialized through the virtio ring buffer so I don't
believe what I'm saying myself... It might be worth digging further as
well.

> > Perhaps backing filesystem dependant? qemu version? virtfs access options?
> 
> I tried with different hardware and different file systems (ext4, btrfs), same
> misbehaviours.
> 
> QEMU is latest git version. I also tried several different QEMU versions, same
> thing.
> 
> QEMU command line used:
> 
> ~/git/qemu/build/qemu-system-x86_64 \
> -machine pc,accel=kvm,usb=off,dump-guest-core=off -m 16384 \
> -smp 8,sockets=8,cores=1,threads=1 -rtc base=utc -boot strict=on \
> -kernel ~/vm/bullseye/boot/vmlinuz \
> -initrd ~/vm/bullseye/boot/initrd.img \
> -append 'root=fsRoot rw rootfstype=9p rootflags=trans=virtio,version=9p2000.L,msize=4186112,cache=loose console=ttyS0' \
> -fsdev local,security_model=mapped,multidevs=remap,id=fsdev-fs0,path=$HOME/vm/bullseye/ \
> -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=fsRoot \
> -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
> -nographic
> 
> Important for reproducing this issue:
> 
>   * cache=loose
>   * -smp N (with N>1)
>   * Guest booted with Linux kernel containing commit eb497943fa21
>     (uname >= 5.16)
> 
> I'm pretty sure that you can reproduce this issue with the QEMU 9p rootfs
> setup HOWTO linked before.

Yes, I'm not sure why I can't reproduce... All my computers are pretty
slow but the conditions should be met.
I'll try again with a command line closer to what you just gave here.


> > It's all extremely slow though... like the final checkout counting files
> > at less than 10/s
> 
> It is VERY slow. And the weird thing is that cache=loose got much slower than
> cache=mmap. My worst case expactation would be cache=loose at least not
> performing worse than cache=mmap.

Yes, some profiling is also in order, it didn't use to be that slow so
it must not be reusing previously open fids as it should have or
something..

-- 
Dominique
