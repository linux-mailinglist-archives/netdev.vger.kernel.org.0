Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9258C21
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfF0U4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:56:09 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46263 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0U4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:56:08 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so8369903edr.13;
        Thu, 27 Jun 2019 13:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hQN5lyIHEpTv7mFta9htRreGSrkPoUPCfBEx1FHIS8=;
        b=nkpdkb28HbplV1bfy7uvGah0hsYcvrLasORikLtmvxoS46eMqkWvdYMa+2+/00UeaQ
         lnMO0fXVsd812yWSY9uamDr/FSlfXtn9P1mZMC/0KNP4219GBbYQPtjoi29R8YxWnhFi
         fPiDYRVx6OHlIamr6YZy56FrF2oEOD3CWGmsY8CTA+T+O0hpaI8qJo9ZzI/VxURaVo2f
         EEw5RbZ5ICe5wi9T5cjCKj0KN6mWgoIufgOdatq9yBWVdEBKn4k33TIzNX0qoWuCxxyW
         oJ65d45MkOj7l/+Yxr6EI0bBotmYjq79h9WdcpQVxu/C1qDhIKna+jObqKE13Mtgsiy5
         rakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hQN5lyIHEpTv7mFta9htRreGSrkPoUPCfBEx1FHIS8=;
        b=QP5B6H3SyI3qd6ZgphIf2aSVCW/Vq5TQUzY6d+dMfgjAB+3wHAYU2DkIPeGN54G2cu
         UeJrfviEuhDxCUiLrqdUU/+hz3N52onRiCyx/6scRwX22heJlGC4dggbvS/JJhyNsDCK
         PbqD71DiK23JZuvj+lhGGOqKYq3dxjsAVpENP4Ewzak3EYuyyTqCNV86r22P1DyW3JJK
         9fP5/DYQCdFBB1yZzT4d1SnhHmSWhVY+Czg521oRGcEylJz2MhmBUsA7BGixX3rZMDKR
         gss8EXStto+vkrWWHvC4SSIK2kO87YVh9Fi+N6AgHOWTUFIqF37MC0DCPLJLdriw28Ss
         2o+g==
X-Gm-Message-State: APjAAAUCI7WNvUPYbG5yWzkhht1EseYnjXoSwgmzTqoazDyyop/bPNDY
        q77jeZQalQM7iOu4MBlEezRmyHoBDpABEgX1Ta/C1g==
X-Google-Smtp-Source: APXvYqzDC9Ne5Od8zZD5gMzJSAbOt1FAMQ+X01MBXVaKuIZbOyjWpuDQ0yh1sKMjvGwyiTXig8YKo5kiEO8Cdob+wG0=
X-Received: by 2002:a17:906:1108:: with SMTP id h8mr5028549eja.229.1561668965618;
 Thu, 27 Jun 2019 13:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
 <156096287188.28733.15342608110117616221.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096287188.28733.15342608110117616221.stgit@warthog.procyon.org.uk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 27 Jun 2019 16:55:29 -0400
Message-ID: <CAF=yD-Kgdwt5=0iboxhvZz4zvNewSGow74U15mQQvO1u8VUGcw@mail.gmail.com>
Subject: Re: [PATCH 8/9] keys: Network namespace domain tag [ver #4]
To:     David Howells <dhowells@redhat.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org, dwalsh@redhat.com,
        vgoyal@redhat.com, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 12:49 PM David Howells <dhowells@redhat.com> wrote:
>
> Create key domain tags for network namespaces and make it possible to
> automatically tag keys that are used by networked services (e.g. AF_RXRPC,
> AFS, DNS) with the default network namespace if not set by the caller.
>
> This allows keys with the same description but in different namespaces to
> coexist within a keyring.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: netdev@vger.kernel.org
> cc: linux-nfs@vger.kernel.org
> cc: linux-cifs@vger.kernel.org
> cc: linux-afs@lists.infradead.org
> ---

> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 711b161505ac..076a75c73c9e 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -38,9 +38,16 @@ EXPORT_SYMBOL_GPL(net_namespace_list);
>  DECLARE_RWSEM(net_rwsem);
>  EXPORT_SYMBOL_GPL(net_rwsem);
>
> +#ifdef CONFIG_KEYS
> +static struct key_tag init_net_key_domain = { .usage = REFCOUNT_INIT(1) };
> +#endif
> +
>  struct net init_net = {
>         .count          = REFCOUNT_INIT(1),
>         .dev_base_head  = LIST_HEAD_INIT(init_net.dev_base_head),
> +#ifdef CONFIG_KEYS
> +       .key_domain     = &init_net_key_domain,
> +#endif
>  };
>  EXPORT_SYMBOL(init_net);
>
> @@ -386,10 +393,21 @@ static struct net *net_alloc(void)
>         if (!net)
>                 goto out_free;
>
> +#ifdef CONFIG_KEYS
> +       net->key_domain = kzalloc(sizeof(struct key_tag), GFP_KERNEL);
> +       if (!net->key_domain)
> +               goto out_free_2;
> +       refcount_set(&net->key_domain->usage, 1);
> +#endif
> +
>         rcu_assign_pointer(net->gen, ng);
>  out:
>         return net;
>
> +#ifdef CONFIG_KEYS
> +out_free_2:
> +       kmem_cache_free(net_cachep, net);

needs
            net = NULL;

to signal failure

> +#endif
>  out_free:
>         kfree(ng);
>         goto out;

Reported-by: syzbot <syzkaller@googlegroups.com>

BUG: KASAN: use-after-free in atomic_set
include/asm-generic/atomic-instrumented.h:44 [inline]
BUG: KASAN: use-after-free in refcount_set include/linux/refcount.h:32 [inline]
BUG: KASAN: use-after-free in copy_net_ns+0x1e8/0x431
net/core/net_namespace.c:466
Write of size 4 at addr ffff88809c9de080 by task syz-executor.1/12624

CPU: 1 PID: 12624 Comm: syz-executor.1 Not tainted 5.2.0-rc6-next-20190626 #23
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
 __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
 kasan_report+0x12/0x17 mm/kasan/common.c:614
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x123/0x190 mm/kasan/generic.c:191
 kasan_check_write+0x14/0x20 mm/kasan/common.c:100
 atomic_set include/asm-generic/atomic-instrumented.h:44 [inline]
 refcount_set include/linux/refcount.h:32 [inline]
 copy_net_ns+0x1e8/0x431 net/core/net_namespace.c:466
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
 ksys_unshare+0x444/0x980 kernel/fork.c:2828
 __do_sys_unshare kernel/fork.c:2896 [inline]
 __se_sys_unshare kernel/fork.c:2894 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2894
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459519
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2202261c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f2202261c90 RCX: 0000000000459519
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f22022626d4
R13: 00000000004c8a2c R14: 00000000004df7d0 R15: 0000000000000006

Allocated by task 12624:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
 slab_post_alloc_hook mm/slab.h:520 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
 kmem_cache_zalloc include/linux/slab.h:737 [inline]
 net_alloc net/core/net_namespace.c:410 [inline]
 copy_net_ns+0xf1/0x431 net/core/net_namespace.c:461
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
 ksys_unshare+0x444/0x980 kernel/fork.c:2828
 __do_sys_unshare kernel/fork.c:2896 [inline]
 __se_sys_unshare kernel/fork.c:2894 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2894
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 12624:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 net_alloc net/core/net_namespace.c:427 [inline]
 copy_net_ns+0x3b1/0x431 net/core/net_namespace.c:461
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
 ksys_unshare+0x444/0x980 kernel/fork.c:2828
 __do_sys_unshare kernel/fork.c:2896 [inline]
 __se_sys_unshare kernel/fork.c:2894 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2894
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
