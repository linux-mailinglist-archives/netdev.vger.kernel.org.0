Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040432AAE1E
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 23:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgKHWzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 17:55:06 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:41379 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgKHWzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 17:55:06 -0500
Received: by mail-io1-f71.google.com with SMTP id y2so4475101ioy.8
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 14:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Mk8JTr7hVOq3EefkDcYJtK1cseL+MNVUi7YjoZxo834=;
        b=sHWQe09Gk8hMTAa2fg3gxDSmWWDYYF7eV7h2kyMwB3IPIPrJB3CUQb0dynQvz15DBL
         qKrpllYRq+kcyBj0zc0ig5hDiOkdVQtLQYQB4f/tXgGk11qcSsqc98VyAF0be4e2xBLr
         8iiSbLfjlIaul5cbx9m5gWNYY8SCM4kCJsq615O32O5iyoi89SdKJpcFYBVX2Ziyb5i5
         Um2GutaRQiqfbjIg9cXjMLzPla7Piwv5bypFJpeQt928xV7jGYn4FmIp5BKaKetAkwKC
         qACc4eC+ad1w69NxGGcRaIoytbuk5ioMNJ7BwOJRJFfRpoCPgyCLG7tfV9/Mv0L3u98H
         aL6g==
X-Gm-Message-State: AOAM5312Y3XXzIoMAEJDs1Ujt+HXExbnLBVk1MY1swfQrt2tBt4B9dII
        Yp8xxEcug41CATVoLZf0fciD7Rwr+qaaznvGciMQ4BwnREl0
X-Google-Smtp-Source: ABdhPJz46elvAlGQb+4iBu5GDJETkvSCwZYY3fQO4J1bsg3UipRMv59OOfwhgZstYtR/XAJyLUrU+ZktTcqi0Zw4wr4tBtTIjClC
MIME-Version: 1.0
X-Received: by 2002:a02:b1cb:: with SMTP id u11mr8883124jah.95.1604876105313;
 Sun, 08 Nov 2020 14:55:05 -0800 (PST)
Date:   Sun, 08 Nov 2020 14:55:05 -0800
In-Reply-To: <000000000000c57f2d05ac4c5b8e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002a736805b3a05697@google.com>
Subject: Re: BUG: corrupted list in kobject_add_internal
From:   syzbot <syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com>
To:     abhishekpandit@chromium.org, coiby.xu@gmail.com,
        davem@davemloft.net, dvyukov@google.com,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        sonnysasaka@chromium.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a46b7ed4d52d09bd6c7ab53b2217d04fc2f02c65
Author: Sonny Sasaka <sonnysasaka@chromium.org>
Date:   Fri Aug 14 19:09:09 2020 +0000

    Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d75792500000
start commit:   d6efb3ac Merge tag 'tty-5.9-rc1' of git://git.kernel.org/p..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff87594cecb7e666
dashboard link: https://syzkaller.appspot.com/bug?extid=dd768a260f7358adbaf9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105054aa900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ab6976900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
