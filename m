Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37A8300B1F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbhAVSXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:23:08 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:46684 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbhAVRVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:21:47 -0500
Received: by mail-io1-f71.google.com with SMTP id m14so9850305ioc.13
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Pk7Ng//oZp6bx3wVbtVGOjayazYiW5CoL8C/yLltJEI=;
        b=GiFs6DlyXKZKEBoCzLnlJ2cUHAdGB+AYt8tn0j2SgdV048++yRj9ajQIhoVENbatZ8
         uM4PYjGBCbthKoXk1kEqJvXU+p1pHQe3WV0DBgeTbImLyCcj83D82y3VZ4xQJbg9eg97
         gpR4b03JRW84QP3PFLWIjX0/09e0VArtEKsJl+p2Y4DiakwLjGmwLmuofTGTgkPMmgCA
         PRpoTy4N1oTQyXip0Ib4JWPJm10+B+wVy5JNkruTxdXGZamAZN7/SmXCa2S1NIJ8W6Kw
         5UGHGDRLjSgnAkmUTNnrotenVrzcBACFtQicAe/aKge5DFuFeFqEFXNY6twuDsslopY+
         1Pcg==
X-Gm-Message-State: AOAM531Q7u+tvEyVnnRXInj/V9hZqoJrAYlP/+yYqVDMlyd2GIWBmAqK
        eIyjofVdDlRBCNhlkS8gVf4ZAp9TveOXyp9XyJfVRUUHmsdx
X-Google-Smtp-Source: ABdhPJwuxS5IKE8JH++C9E5iRtlObmCnWu4CK74jGYoTCgwtMlPdCoSd+1qaXik20vfyPhex6LbwlMtwbLleEB929XQ3egRqvMN8
MIME-Version: 1.0
X-Received: by 2002:a6b:4003:: with SMTP id k3mr4151669ioa.105.1611336066630;
 Fri, 22 Jan 2021 09:21:06 -0800 (PST)
Date:   Fri, 22 Jan 2021 09:21:06 -0800
In-Reply-To: <000000000000a358f905ae6b5dc6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd897e05b9806982@google.com>
Subject: Re: KASAN: use-after-free Read in dump_schedule
From:   syzbot <syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com>
To:     anant.thazhemadam@gmail.com, anmol.karan123@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        jhs@mojatatu.com, jiri@resnulli.us, kadlec@netfilter.org,
        kuba@kernel.org, leandro.maciel.dorileo@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        subashab@codeaurora.org, syzkaller-bugs@googlegroups.com,
        vedang.patel@intel.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit cc00bcaa589914096edef7fb87ca5cee4a166b5c
Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Wed Nov 25 18:27:22 2020 +0000

    netfilter: x_tables: Switch synchronization to RCU

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10879d68d00000
start commit:   59126901 Merge tag 'perf-tools-fixes-for-v5.9-2020-09-03' ..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f6ce8d5b68299
dashboard link: https://syzkaller.appspot.com/bug?extid=621fd33c0b53d15ee8de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152c3af9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12213b71900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: x_tables: Switch synchronization to RCU

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
