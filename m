Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5A3E125E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhHEKN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:13:28 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43623 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbhHEKNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 06:13:24 -0400
Received: by mail-il1-f197.google.com with SMTP id v5-20020a92ab050000b02902223cc2accaso2503874ilh.10
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 03:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=mfp3dcRamri2wGmkRJSK01Pfy3daGYI42UfXp0QgTjU=;
        b=ldBt/lv9YGyvzMd5f/fX9KeuIUPEGPF0kD/t6wmVX+AfGx36J12FXjshw8/JHGohRU
         VZZpgt0c60ifV2M8YgBGtPCTdt+TNpi7pCJM22vzdM1IHkwTNDlgnZaJGxcdk8L2XkA6
         o9AMkyrdMFf+SwrcRyQU7cNjFec2nB7bqkl1HA04Ma82aLVGnCCBxu96tNQN1RxLu8Qa
         byCNNF9S4pZhQv1uD5+3f4vn3nPPBMvNud9InNW/9U/O5BQYmLJxP8/2YJ03Oi2H8RS+
         2ogK1vTIkOHo+UrHEm0CtieHM8yp7EzrY6OlijWpbhe4vdun8+85UK20L19v9pNy+f1u
         bDVQ==
X-Gm-Message-State: AOAM530eAnVKoFLQqawYesNsZlnpc2fkw3c4mI12f+xvsyVouptzvi+s
        qeNz7fWumgHMjz+uP9MI/iZntvMbrBAGIFItiT+BDRxHgxSA
X-Google-Smtp-Source: ABdhPJzPTZ4ctrrUGavvOHBH4NTS8BJbXcUPvlgq/7QfOSLC+LhG2uxQJN+Qfdv0epwVMqtQzdMZM9CmWaSpH6ty4Vl8Ed/4Bek7
MIME-Version: 1.0
X-Received: by 2002:a6b:28a:: with SMTP id 132mr527433ioc.157.1628158390707;
 Thu, 05 Aug 2021 03:13:10 -0700 (PDT)
Date:   Thu, 05 Aug 2021 03:13:10 -0700
In-Reply-To: <00000000000040b7ba05ae32a94a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000842d2f05c8cd2ac7@google.com>
Subject: Re: [syzbot] possible deadlock in __sock_release
From:   syzbot <syzbot+8e467b009209f1fcf666@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dave@pr1mo.net, davem@davemloft.net,
        dsahern@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 8fb4792f091e608a0a1d353dfdf07ef55a719db5
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Tue Jul 20 13:08:40 2021 +0000

    ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113a99f1300000
start commit:   c6c205ed442e Merge branch 'stmmac-ptp'
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=26b64b13fcecb7e1
dashboard link: https://syzkaller.appspot.com/bug?extid=8e467b009209f1fcf666
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152188d2300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d5493c300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
