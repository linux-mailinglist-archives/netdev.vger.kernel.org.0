Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286FDF303F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbfKGNmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:06 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55644 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbfKGNmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:05 -0500
Received: by mail-il1-f197.google.com with SMTP id n81so2604318ili.22
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ENxD+/fIw0mYa6vyCEJ9BP1QogAHJZe3kkohsrzQFAg=;
        b=St7Av5snWfN/VBgcBfSypNHWYBTV5dsR1tJ/F8wLjDcFzjFzLGrJ/PPs8Vw/a6kJlr
         vapQolWFfJ87igrSggtU6wMCG13EASqOIo1C619cdVIILGvGcYiMtL6khKq4PUjqgBcz
         rdSnyEcnzProTSokHJkU6K/DmX5ipZXQlchsqD9F5roNWq48VVeDQ35Qi95Sjv+Xz0zG
         Vk6gzSVQzd0ZD+5JgOlZeFAFUr1XD1svex6DoEkE2AxA3FuCiYLW6QvsPKe/BXcnLcjy
         uPFVX1rWGLAwS5zZ1kkcPISpTbl4H816PvfR33GGzcCWdieJf28vuTfTyRv2eWe521Vz
         iT2A==
X-Gm-Message-State: APjAAAWMqTj5NSZRP2TqmWrc1GRXqneZjC5EWcEZGjOyzb1WtvIESeds
        uNwGeHHch1FBNajr1EpNWdDlgnzp7MwftR/2gEzs4gLIs3KK
X-Google-Smtp-Source: APXvYqxgUiKUUpVf8mANbwuq5h5ETdkG1+2bc1EZcA3Iu8zgmeR5189VzsX5FO9eWFvmABYaiGgJH8JWUel87EI/ZKuu+fPSmejM
MIME-Version: 1.0
X-Received: by 2002:a6b:ee07:: with SMTP id i7mr3695643ioh.26.1573134125000;
 Thu, 07 Nov 2019 05:42:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:04 -0800
In-Reply-To: <000000000000ee4dab0570be896c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4731e0596c1d418@google.com>
Subject: Re: general protection fault in p9_conn_cancel
From:   syzbot <syzbot+4d29d76a0da7a8c4d86c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dominique.martinet@cea.fr, ericvh@gmail.com,
        jiangyiwen@huwei.com, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 9f476d7c540cb57556d3cc7e78704e6cd5100f5f
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Mon Jul 23 18:42:53 2018 +0000

     net/9p/trans_fd.c: fix race by holding the lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1150b430600000
start commit:   30c2c32d Merge tag 'drm-fixes-2018-07-10' of git://anongit..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
dashboard link: https://syzkaller.appspot.com/bug?extid=4d29d76a0da7a8c4d86c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e2c5b2400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179415b2400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race by holding the lock

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
