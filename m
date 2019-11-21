Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B571D105AAD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKUT6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:58:02 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47498 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfKUT6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:58:02 -0500
Received: by mail-io1-f72.google.com with SMTP id y16so3077645ior.14
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 11:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kyzGaPalk+OtzhfGjgjsp1/zJC5fx+d1jrM2gzyAv18=;
        b=Gy8ZZvZiS4cA8i2AQQ38d3kWZpAX35a4U1JO/In5vbtcajIilx1wYgK4/tnblWXFJF
         g2/7Diqr81hlQtshq0UfiAvuaOa/klsJhVHoxs/HJoGq2NJ2qGv6VB+JQNEHQyiDLZRX
         l5cSgPTPQfCkLGc8NH4pdxlJYQBJMvQmVVhBgUgnxHWqBWsi5YusdDhis+nBYqXis9tm
         /RvzroPTPzxrfkkBeiB10tpzikEbR8RjL6eHu4TTWVUZX1Yefg5UGn4VC1AfyY9KmDDo
         8F7ZeJQnk2v4e2sEva+Z5YKN+lEd5KYjN59vhbONip8Rm80YatyC+RP37/p5rfGHGt5z
         fmPQ==
X-Gm-Message-State: APjAAAV7tzO1X5pF6kneYFM44EvW2Ei36v6zd/+itDYKeQeqPq8f2RY8
        t5WDrNNTjvQXSckkr7chwN/QjWjOesCmVIKb8zzHoPRlJ2it
X-Google-Smtp-Source: APXvYqzR/3sH9+ja80DnB3QgqV56ETLn3nZ9hdmsRzJEMAlxU1EkYOS6cQQlXeISKiEsafKa+XT4Cq33ry8YgrPFMK3XSs3EldbO
MIME-Version: 1.0
X-Received: by 2002:a5d:81cf:: with SMTP id t15mr9459731iol.288.1574366280984;
 Thu, 21 Nov 2019 11:58:00 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:58:00 -0800
In-Reply-To: <0000000000008f9c780581fd7417@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ecb2cb0597e0b62e@google.com>
Subject: Re: INFO: task hung in __flush_work
From:   syzbot <syzbot+aa0b64a57e300a1c6bcc@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vakul.garg@nxp.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a42055e8d2c30d4decfc13ce943d09c7b9dad221
Author: Vakul Garg <vakul.garg@nxp.com>
Date:   Fri Sep 21 04:16:13 2018 +0000

     net/tls: Add support for async encryption of records for performance

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11bf7ecae00000
start commit:   90cadbbf Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13bf7ecae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15bf7ecae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d41c8529d7e7362
dashboard link: https://syzkaller.appspot.com/bug?extid=aa0b64a57e300a1c6bcc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6629b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1222d29b400000

Reported-by: syzbot+aa0b64a57e300a1c6bcc@syzkaller.appspotmail.com
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records  
for performance")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
