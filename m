Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B86ECF2F9
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbfJHGqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:46:03 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33281 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbfJHGqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:46:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id a22so16286133ljd.0
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 23:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jo9C4CG0otGYu0Edb1iYI/l+WZJfAMHI7XCOvhUrSdU=;
        b=r4FkCKFITvN+CbfnbvWfINUJO0unHSC4GaBE/BGOmOQra4a8Dn1GwP5kCRKbJRbfFN
         zL0vKifVBjgmEWE2tdO1AiKBcKxgu/QeWQTDE6fa2oCl+W2ZJ/YPm3HorSf8K93K96XR
         AdpLfmqAp0uyLiVAG056HpM/6TqTkTCfc4uF1fkXhVBCTa4NYcNiXDXnaX+ixqAwdnQR
         RnpVUuXXmNM7yB4DLzc4DmLU0eIFuRicGJyEnLGdPwQHyVAwWXQe+GXfqA0CI80OaIiU
         Ni3u1yuYUL+pNQwu1k7vAaErO6OF/Whyk1uf7Fv60njdY7T9aMHFhWeem0/ptCHxFKUh
         tVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jo9C4CG0otGYu0Edb1iYI/l+WZJfAMHI7XCOvhUrSdU=;
        b=XsHhMEmZ48UAUAfkie/dzGRncmTfpgqGajuvuKDKqEe5Dlme7bEq3RpJaNQb11qpec
         /5m8eY4V84muYshJDLMavj5oYi8eFeFggspMjeKHed0o35c4qbyL2y1bv0ySa280eerF
         9ISPKAG+bkIAJmHG2x+y0G9icR6zMJutvyhFplYIk8cGLwDu6ltk1EDZqOLSWjr25A2n
         CjJO6voUQ5qcogK4pGxOHaNvwyeJZdrFlz5mGi4GkI2yJH9btfZxmD3Q8mfUhtwMSQ94
         Z6thIFk12SnEk+T/+PwGvA6hxCg0k2n2pNWf7DQoHUjKe1AfespDmz5EmzDMUlfM38TC
         KJvw==
X-Gm-Message-State: APjAAAUQMLDwNmobKmZQtAK/VpkFW3+pia7GcgI5m40rq+x8iyX1E29g
        DAyShKQ+XnuNwgoVEemnZgOxpHbmxmLr3U7lpdfn3t13ODU=
X-Google-Smtp-Source: APXvYqzkxSLi6hOzuuE0Vy8114WtEZkt1qKh9440vcD3KXBpmST7sCR2YMr51d5LTde1EPCn2s7bcj0oOD9xrMZeiK8=
X-Received: by 2002:a2e:9615:: with SMTP id v21mr21083058ljh.46.1570517158879;
 Mon, 07 Oct 2019 23:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com>
 <20191008053507.252202-2-zenczykowski@gmail.com> <20191008060414.GB25052@breakpoint.cc>
In-Reply-To: <20191008060414.GB25052@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 7 Oct 2019 23:45:46 -0700
Message-ID: <CAHo-OowyjPdV-WbnDVqE4dJrHQUcT2q7JYfayVDZ9hhBoxY4DQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     Florian Westphal <fw@strlen.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right, so I'm not claiming I'm following what's happening here.

This is on a 4.14 LTS + stuff android device kernel...
which isn't exactly trustworthy...

backporting this patch (ie. the one I proposed reverting) would
potentially fix things,
but I don't really understand why we need this kmemleak_not_leak.

comment#5, 1) kmemleak_U3_8.txt

unreferenced object 0xffffffe9b1246d80 (size 320):
  comm "Chrome_ChildIOT", pid 14510, jiffies 4296946994 (age 6554.257s)
  hex dump (first 32 bytes):
    00 00 00 00 8a 00 8a 00 00 00 76 00 04 00 00 00  ..........v.....
    03 00 00 80 00 00 00 00 00 02 00 00 00 00 ad de  ................
  backtrace:
    [<00000000e8443b2a>] __nf_conntrack_alloc+0x68/0x154
    [<00000000ad74cb6d>] init_conntrack+0xec/0x870
<------------------- caller
    [<0000000021ec0fc5>] nf_conntrack_in+0x5a8/0xc20
    [<0000000037b289f7>] ipv6_conntrack_local+0x58/0x64
    [<00000000fb301f7c>] nf_hook_slow+0x84/0x124
    [<00000000cada0355>] ip6_xmit+0x580/0xaec
    [<00000000f35a7b78>] inet6_csk_xmit+0xc0/0x12c
    [<00000000c6e68096>] __tcp_transmit_skb+0x8e0/0xd64
    [<00000000ab150d11>] tcp_connect+0x888/0x123c
    [<00000000311815d4>] tcp_v6_connect+0x7c8/0x81c
    [<000000005abc5c46>] __inet_stream_connect+0xb8/0x3e4
    [<000000001036b35e>] inet_stream_connect+0x48/0x70
    [<00000000463ca3cd>] SyS_connect+0x138/0x1ec
    [<0000000048eb8c0e>] __sys_trace_return+0x0/0x4
    [<00000000a87abfc9>] 0xffffffffffffffff
unreferenced object 0xffffffeac8de7e00 (size 128):
  comm "Chrome_ChildIOT", pid 14510, jiffies 4296946994 (age 6554.257s)
  hex dump (first 32 bytes):
    69 6f 6e 2d 73 79 73 74 65 6d 2d 36 30 32 2d 61  ion-system-602-a
    6c 6c 6f 63 61 74 6f 72 2d 73 65 72 76 69 00 de  llocator-servi..
  backtrace:
    [<00000000620a1869>] __krealloc+0xc0/0x134
    [<000000007c526d10>] nf_ct_ext_add+0xd0/0x1b8
    [<00000000e7d08252>] init_conntrack+0x2e8/0x870
    [<0000000021ec0fc5>] nf_conntrack_in+0x5a8/0xc20
    [<0000000037b289f7>] ipv6_conntrack_local+0x58/0x64
    [<00000000fb301f7c>] nf_hook_slow+0x84/0x124
    [<00000000cada0355>] ip6_xmit+0x580/0xaec
    [<00000000f35a7b78>] inet6_csk_xmit+0xc0/0x12c
    [<00000000c6e68096>] __tcp_transmit_skb+0x8e0/0xd64
    [<00000000ab150d11>] tcp_connect+0x888/0x123c
    [<00000000311815d4>] tcp_v6_connect+0x7c8/0x81c
    [<000000005abc5c46>] __inet_stream_connect+0xb8/0x3e4
    [<000000001036b35e>] inet_stream_connect+0x48/0x70
    [<00000000463ca3cd>] SyS_connect+0x138/0x1ec
    [<0000000048eb8c0e>] __sys_trace_return+0x0/0x4
    [<00000000a87abfc9>] 0xffffffffffffffff


comment#5, 2) kmemleak_U3_24.txt

private/msm-google/net/netfilter/nf_conntrack_core.c
unreferenced object 0xffffffca447d0780 (size 320):
  comm "NetworkService", pid 11981, jiffies 4296499821 (age 639.230s)
  hex dump (first 32 bytes):
    01 00 00 00 11 00 11 00 04 00 67 70 00 00 00 00  ..........gp....
    6f 53 00 00 00 00 00 00 b8 4d 89 e4 cb ff ff ff  oS.......M......
  backtrace:
    [<00000000be8a10e5>] __nf_conntrack_alloc+0x68/0x154
    [<0000000086bc83ff>] init_conntrack+0xec/0x870
<---------------- caller
    [<00000000a2e722fc>] nf_conntrack_in+0x5a8/0xc20
    [<0000000092c99949>] ipv4_conntrack_local+0x110/0x158
    [<00000000cbc301a4>] nf_hook_slow+0x84/0x124
    [<00000000ca439d6c>] __ip_local_out+0xf8/0x16c
    [<000000004ee66db3>] ip_queue_xmit+0x3f8/0x510
    [<00000000a7155c11>] __tcp_transmit_skb+0x8e0/0xd64
    [<000000009f5bf497>] tcp_connect+0x888/0x123c
    [<00000000b593e23f>] tcp_v4_connect+0x69c/0x7e8
    [<000000009cf8bbe8>] __inet_stream_connect+0xb8/0x3e4
    [<00000000dd889c48>] inet_stream_connect+0x48/0x70
    [<00000000f8db9417>] SyS_connect+0x138/0x1ec
    [<00000000f587c037>] __sys_trace_return+0x0/0x4
    [<00000000a409c2be>] 0xffffffffffffffff
unreferenced object 0xffffffcb46ad9380 (size 128):
  comm "NetworkService", pid 11981, jiffies 4296499821 (age 639.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 02 00 00 00 00 ad de  ................
    00 00 00 00 18 30 00 00 00 00 00 00 00 00 00 00  .....0..........
  backtrace:
    [<000000007102ad50>] __krealloc+0xc0/0x134
    [<00000000274813fb>] nf_ct_ext_add+0xd0/0x1b8
    [<0000000029bb07b0>] init_conntrack+0x2e8/0x870
<------------ caller
    [<00000000a2e722fc>] nf_conntrack_in+0x5a8/0xc20
    [<0000000092c99949>] ipv4_conntrack_local+0x110/0x158
    [<00000000cbc301a4>] nf_hook_slow+0x84/0x124
    [<00000000ca439d6c>] __ip_local_out+0xf8/0x16c
    [<000000004ee66db3>] ip_queue_xmit+0x3f8/0x510
    [<00000000a7155c11>] __tcp_transmit_skb+0x8e0/0xd64
    [<000000009f5bf497>] tcp_connect+0x888/0x123c
    [<00000000b593e23f>] tcp_v4_connect+0x69c/0x7e8
    [<000000009cf8bbe8>] __inet_stream_connect+0xb8/0x3e4
    [<00000000dd889c48>] inet_stream_connect+0x48/0x70
    [<00000000f8db9417>] SyS_connect+0x138/0x1ec
    [<00000000f587c037>] __sys_trace_return+0x0/0x4
    [<00000000a409c2be>] 0xffffffffffffffff

---
and another one from a different device, but also 4.14 lts

unreferenced object 0xfffffffbd5d2a180 (size 320):
  comm "GCMWriter", pid 12045, jiffies 4296160038 (age 105.074s)
  hex dump (first 32 bytes):
    01 00 00 00 0f 00 0f 00 05 00 fa ef bf ff ff ff  ................
    81 f4 01 00 00 00 00 00 00 d2 6f e6 fc ff ff ff  ..........o.....
  backtrace:
    [<00000000274ac54c>] kmem_cache_alloc+0x188/0x2ac
    [<00000000b8014b3d>] __nf_conntrack_alloc+0x68/0x144
    [<0000000049a70b0e>] init_conntrack+0xc0/0x4a0
    [<000000009e67654a>] nf_conntrack_in+0x2b4/0x7b4
    [<00000000ca4d0a3e>] ipv4_conntrack_local+0xa4/0xac
    [<0000000081d01fa2>] nf_hook_slow+0x4c/0xdc
    [<0000000097b73dfa>] __ip_local_out+0xfc/0x140
    [<00000000b21eaa8e>] ip_queue_xmit+0x344/0x3a0
    [<00000000b24cb740>] __tcp_transmit_skb+0x710/0x9c8
    [<00000000feb142b2>] tcp_connect+0x9d8/0xc74
    [<000000007f161285>] tcp_v4_connect+0x388/0x3fc
    [<00000000adf5f95c>] tcp_v6_connect+0x254/0x4e0
    [<0000000072d33635>] __inet_stream_connect+0x90/0x2d8
    [<0000000058fab473>] inet_stream_connect+0x48/0x70
    [<00000000da64280e>] SyS_connect+0xb8/0x134
    [<0000000044b2efde>] __sys_trace_return+0x0/0x4
unreferenced object 0xfffffffce5cc4a00 (size 128):
  comm "GCMWriter", pid 12045, jiffies 4296160038 (age 105.074s)
  hex dump (first 32 bytes):
    80 45 cc e5 fc ff ff ff 00 00 00 00 00 00 00 00  .E..............
    00 00 00 00 18 30 00 00 00 00 00 00 00 00 00 00  .....0..........
  backtrace:
    [<00000000eb5f9abf>] __kmalloc_track_caller+0x1b4/0x314
    [<0000000093176ee9>] __krealloc+0x54/0xa8
    [<000000006dcdc738>] nf_ct_ext_add+0xac/0x13c
    [<00000000afc95893>] init_conntrack+0x278/0x4a0
    [<000000009e67654a>] nf_conntrack_in+0x2b4/0x7b4
    [<00000000ca4d0a3e>] ipv4_conntrack_local+0xa4/0xac
    [<0000000081d01fa2>] nf_hook_slow+0x4c/0xdc
    [<0000000097b73dfa>] __ip_local_out+0xfc/0x140
    [<00000000b21eaa8e>] ip_queue_xmit+0x344/0x3a0
    [<00000000b24cb740>] __tcp_transmit_skb+0x710/0x9c8
    [<00000000feb142b2>] tcp_connect+0x9d8/0xc74
    [<000000007f161285>] tcp_v4_connect+0x388/0x3fc
    [<00000000adf5f95c>] tcp_v6_connect+0x254/0x4e0
    [<0000000072d33635>] __inet_stream_connect+0x90/0x2d8
    [<0000000058fab473>] inet_stream_connect+0x48/0x70
    [<00000000da64280e>] SyS_connect+0xb8/0x134

On Mon, Oct 7, 2019 at 11:04 PM Florian Westphal <fw@strlen.de> wrote:
>
> Maciej =C5=BBenczykowski <zenczykowski@gmail.com> wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > This reverts commit 114aa35d06d4920c537b72f9fa935de5dd205260.
> >
> > By my understanding of kmemleak the reasoning for this patch
> > is incorrect.  If kmemleak couldn't handle rcu we'd have it
> > reporting leaks all over the place.  My belief is that this
> > was instead papering over a real leak.
>
> Perhaps, but note that this is related to nfct->ext, not nfct itself.
>
> I think we could remove __krealloc and use krealloc directly with
> a bit of changes in the nf_conntrack core to make sure we do not
> access nfct->ext without holding a reference to nfct, and then drop
> rcu protection of nfct->ext, I don't think its strictly required anymore.
