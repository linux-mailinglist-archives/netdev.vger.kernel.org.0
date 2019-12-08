Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D42116156
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 11:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfLHKRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 05:17:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:50515 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfLHKRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 05:17:01 -0500
Received: by mail-io1-f71.google.com with SMTP id e13so67056iob.17
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 02:17:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=k4E/mqa4W+kq1mdY2640K8IoV0aq2OgaR3MQVU5N0qw=;
        b=bGCeRMGR8iKOR69cplRxdt3O3+nuzQzVDm2+GGJlZox12ca+aXvEq1OGd7MQAetj2O
         7ffOrvZ/u3YVkeWWMAhlGzwlofmjrjvUHGThEkUX/+wtDaRhQNsWCIMCRyhYSEIE0mrT
         vJlt649dnNu/grceFvGcwLFkIzQfhBpwYZ1Umgnw5lR0KZrL6i+bEYpA/8XIMX/ZoWop
         BJzm9XR5arLF9/Xbrtc4svd3u+E3OtVrNJiOlsNYI2ZvVjivvT/lryp3l3YGfrRGDh4R
         c3JFMPf67Jj4vnQgas0tZczqAD3oAMTyUshEGG2XZ6PaPqvVJAvnlx+CQjX0N2gA0AaN
         14KQ==
X-Gm-Message-State: APjAAAVHLcAp2Nw0atwFd5KoK6Pv1iq9LdVIY5IDGRPdM5HAQcUbKyL+
        tgmrQe/5aI8x29RqwiMCRYNacKmXDimKuXl9rkzggoH+N26u
X-Google-Smtp-Source: APXvYqxTE6EZREG4LTPjlQr/Cd3zcGls/yAP2gpzh5nqfGaDzJ4084rVdEkfPj9Fp2EmOa+jCyeqD+IN0vzk7/4GuB6BqFmCa5zL
MIME-Version: 1.0
X-Received: by 2002:a5d:9593:: with SMTP id a19mr16249548ioo.36.1575800221149;
 Sun, 08 Dec 2019 02:17:01 -0800 (PST)
Date:   Sun, 08 Dec 2019 02:17:01 -0800
In-Reply-To: <0000000000001282e1057e14848e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006b2f6205992e9402@google.com>
Subject: Re: WARNING in perf_group_attach
From:   syzbot <syzbot+23fe48cbe532abffa52e@syzkaller.appspotmail.com>
To:     Kernel-team@fb.com, acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, arvid.brodin@alten.se,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jbacik@fb.com, jolsa@redhat.com, kafai@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 311633b604063a8a5d3fbc74d0565b42df721f68
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Jul 10 06:24:54 2019 +0000

     hsr: switch ->dellink() to ->ndo_uninit()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1639a42ae00000
start commit:   6fbc7275 Linux 5.2-rc7
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=23fe48cbe532abffa52e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1758795da00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d2fa1ba00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: hsr: switch ->dellink() to ->ndo_uninit()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
