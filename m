Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AAA39E5D5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFGRsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:48:39 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:46795 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFGRsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:48:38 -0400
Received: by mail-lj1-f181.google.com with SMTP id e11so23321794ljn.13;
        Mon, 07 Jun 2021 10:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcejzj+YKCRY4WWuFJkzpsXTL8zoFh/y/Gxu0KunwGY=;
        b=BD0Sy4xO4H2zwT5TYjrhUUPywmTKCGM5YrFg1ccipSS3OfqaBZ3gl3YhsoIBPviEsM
         VmPYmaBP25cx0UsWT/ApQw5EAX4XUaysHUNK9zXOns95YPyaU8clEZTzDDy/LIrQXJj4
         StGE4Z0Wprts1sY2GOk9KPRf+CaYSxapaZnWjrQZl8Pd8fAnQjjSm+Ap/V9VOsZD9R4E
         7TuS1gVfa79cOLW9VM0yncWKGTf8g0Y8cO4Waj9ac9wsSRYSiRECYryjI8jnxyyUqT/t
         ti/kZlHRyM6+Kh9LHooRnn2OGj+EutQE4UxK5R/BayAh2048X/1PV3EmdAbnQkxZBTOR
         FtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcejzj+YKCRY4WWuFJkzpsXTL8zoFh/y/Gxu0KunwGY=;
        b=cmf1sgb3HZ2N1XpBmKgb+N6W8pAQ11nY47ccnotiQ7wP4eiaEFjs+GWs3PO1dyqxnq
         iqGKv3jo0IzfCEx4O+sQSBTQI2i6AGEOjLMBNhG3M06qGFk7dMJeNZBboa3B3P2L7Eab
         sx5sYTaW1c7hhIQTQoZAECnz4bRoJFQaHsL2aYptcNVc8Dz6k5jJfOHmdPD41bV1fxgX
         DGFkCq3A/THvVMRyKsUYOTEc22pcANsz/1nwOt3DmyB+d9l+N3sF4ru5jrj4eUbhNuz1
         rvvZPQJJamVou9I26P4R1znb3eXuqcuDS+PohJZ4EbohSwDRxraLv4LJu2zIap+l5u5T
         q4eQ==
X-Gm-Message-State: AOAM530oU7s9RPYa3AiqLVDkokgd/FJcIgNB044cl9jex8CO7Oc3QzMu
        XDjyG85AhCOS66W8N/XnbQU=
X-Google-Smtp-Source: ABdhPJx8tZlIvp5fV59VWUsQzJhqZdEODeudvhf5bmmqzPkbMapfJnHsD4MnIvEL71LD+pDbiZx53w==
X-Received: by 2002:a2e:91c8:: with SMTP id u8mr15030387ljg.309.1623087945375;
        Mon, 07 Jun 2021 10:45:45 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id q16sm1574059lfu.103.2021.06.07.10.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 10:45:45 -0700 (PDT)
Date:   Mon, 7 Jun 2021 20:45:42 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kadlec@netfilter.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        unixbhaskar@gmail.com, yhs@fb.com, yoshfuji@linux-ipv6.org,
        zhengyongjun3@huawei.com
Subject: Re: [syzbot] general protection fault in kcm_sendmsg
Message-ID: <20210607204542.4ad0b33e@gmail.com>
In-Reply-To: <000000000000b3f96105c42ef146@google.com>
References: <000000000000b3f96105c42ef146@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Jun 2021 08:46:26 -0700
syzbot <syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1a802423 virtio-net: fix for skb_over_panic inside
> big mode git tree:       bpf
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=159b08afd00000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=65badd5e74ec62cb67dc syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=104624afd00000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e36197d00000
> 
> The issue was bisected to:
> 
> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Apr 21 07:51:08 2021 +0000
> 
>     netfilter: arp_tables: pass table pointer via nf_hook_ops
> 

It's c47cc304990a ("net: kcm: fix memory leak in kcm_sendmsg") where
the bug was introduced by me :(

I've already sent a revert




With regards,
Pavel Skripkin
