Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4435F3018
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389382AbfKGNma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:30 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:52690 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389192AbfKGNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:10 -0500
Received: by mail-il1-f199.google.com with SMTP id t23so2625163ila.19
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ts1/QN7SlZAv8FzCyonCkAig7h5V9G7HkY3ov7xjs3M=;
        b=ImxfbQhYPlGbd3gborKdpKXCVyCieadK4+lS5skmazFnpZ0n0nvkVsap0wI9OITrlg
         L3lXx9wyXXlZO+xcjHI70hAujzuOlHJqkWxRO85w3rDk0Mfqx5dUkD5VeELBE7PGTUPx
         4znaHAs0c/N84gC+lyTTKiq1acTiv3IGv82Wi4xbusDxKiVdp6LlLxmQJuj/BQM4MS9+
         86sVA+NtGBYnF1gNx2jnPmGrX2UAnSLjJFVgM3h6a6dfEKRnPiP8iD6VkkpGuIMwq+aE
         dhpEnGp7b8S5PsCyWm0zas/eSVk4N3GIt8vFEq1fKNpPrx+bXGvvwxPMVc5JT0SyFsfo
         UsSA==
X-Gm-Message-State: APjAAAXjxgTiCsBOQjBQfwzfImfZIr6dcI1Wa1NLbOSDfLDIe/alAUdP
        mtsbgQmTy9g1e4UnziAYyphoZzxTHJ5dPvrTkxO+lDM/ax0w
X-Google-Smtp-Source: APXvYqz/g3akW+HYZOqq00GOcwk4TIgPuwUmUsNZ8JleeVUWjArlNV1JzK0GZVOa198jjNQXsMlAh0R+qyRRrxrnABjAL9dYZK4H
MIME-Version: 1.0
X-Received: by 2002:a5d:9f02:: with SMTP id q2mr3553203iot.3.1573134129497;
 Thu, 07 Nov 2019 05:42:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:09 -0800
In-Reply-To: <00000000000006602605752ffa1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f90bb30596c1d438@google.com>
Subject: Re: general protection fault in tcp_cleanup_ulp
From:   syzbot <syzbot+0b3ccd4f62dac2cf3a7d@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, john.fastabend@gmail.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 5607fff303636d48b88414c6be353d9fed700af2
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Tue Sep 18 16:01:44 2018 +0000

     bpf: sockmap only allow ESTABLISHED sock state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fdc73c600000
start commit:   28619527 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f59875069d721b6
dashboard link: https://syzkaller.appspot.com/bug?extid=0b3ccd4f62dac2cf3a7d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13537269400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: bpf: sockmap only allow ESTABLISHED sock state

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
