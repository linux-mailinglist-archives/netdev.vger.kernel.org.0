Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9605619759C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgC3HZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:25:04 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34124 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgC3HZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:25:04 -0400
Received: by mail-io1-f72.google.com with SMTP id n26so15364116iop.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 00:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TZJbpgebPbX3Q4FeLfNCFQJD77ggPTwgpCJg6I/5kLk=;
        b=V77XjrkLD7hC38gXJPEGBKknP1xzRUNZrRYO9H4XfvwS0JaBA8SqwxMv4AFsh7Osbx
         QMNdgYl9L84oDgrK3rSe0ly60xBpeJtsbmbVEROT9wLCMAsABb52XTtRPZeD1Th/TGeG
         bdYe+9LsjFPWAmRGljWbJ/JI1n3X9UnHpDoDtRzXzW1BJDIqSlSOkMp37ylsg1dCjad1
         ZCgt+HL+JkDUl7DDITfW2sbL3/NbbqWYGdSizq7CHpeB3wXqwdKgdCtPzJQcG7Z7k6Ix
         /iGLW0L9ULpIHXixED0F6hnDIduBo6gEKVwjbd+bpV3N7nnu0gThM0WHgvrc6hohYN6Q
         iCGA==
X-Gm-Message-State: ANhLgQ1TpWeZTWKvfG/yOfIyy+/sxlVdeWJeh0Aj3U/QZE/f9h6slibm
        JHblvC1yWIivZ9g8zJr8R+Xst13J7NtQ0vYvQpfu7PkJFljA
X-Google-Smtp-Source: ADFU+vtBbBt6BuinPFFJY8ewnoDn/U9q2ryhLsaXg+psdNxruEaMqWJqvCEaD1smqkJhUjifXxvNwbU5if/xCAxan2Tj9cQry9q1
MIME-Version: 1.0
X-Received: by 2002:a6b:e316:: with SMTP id u22mr9378632ioc.1.1585553103320;
 Mon, 30 Mar 2020 00:25:03 -0700 (PDT)
Date:   Mon, 30 Mar 2020 00:25:03 -0700
In-Reply-To: <000000000000aa9a23059f62246a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007effb905a20d5904@google.com>
Subject: Re: WARNING in sk_stream_kill_queues (4)
From:   syzbot <syzbot+fbe81b56f7df4c0fb21b@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, aviadye@mellanox.com,
        borisp@mellanox.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, edumazet@google.com,
        jbaron@akamai.com, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, shuah@kernel.org,
        soheil@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit b6f6118901d1e867ac9177bbff3b00b185bd4fdc
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Feb 25 19:52:29 2020 +0000

    ipv6: restrict IPV6_ADDRFORM operation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1177dc25e00000
start commit:   f8788d86 Linux 5.6-rc3
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=fbe81b56f7df4c0fb21b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fd92c3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11679a81e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: ipv6: restrict IPV6_ADDRFORM operation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
