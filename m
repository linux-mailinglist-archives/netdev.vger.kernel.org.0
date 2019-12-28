Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1012BD9C
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfL1NLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 08:11:03 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:55821 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfL1NLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 08:11:02 -0500
Received: by mail-il1-f199.google.com with SMTP id p8so3255958ilp.22
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 05:11:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8/MjX1lwUwtL5T8VvrucT08m+Eu8aAT/rAF6iBvp3So=;
        b=tH7KaMxVUl+wCAFqgKKAx+2ztuJSBfAKmeZYlHSi/i0vtux9IuX1b9x6GoEWSj1nPO
         dNe8vhBQR5cGYJpJLhfErYh5mMirH8Mpe1zO5SCFx7whIABUjLAHhQYrY2sC25td+kUi
         P5hqjuOuPn4DJ7ZTcpEUAtTuPt2xpmDURRHfFCbzMJLy7QtEM2GXdm1olc29YS+EfFJL
         ra84Ra8xVAQrl/2dlYJdxob6BchkF2MDHVrhBILuY+grOMFVzkfONHDVBLY7yyP+wMLW
         3Kv6SuqK6zUc6jNGXExo8+a7A0NgQqfUDZVF1yto35RRyAFSF+mHdU0vJKe7FZqWwMxX
         gUrg==
X-Gm-Message-State: APjAAAWBmE8b4NwK/naO0EYfXPTXGZwSl9j9oAEUtJfIJpHHRNEBfSPm
        6xNgaqMiZaB59mSApPCsqZyK9uFYAup8Qm3IX1Chi6okVHiq
X-Google-Smtp-Source: APXvYqwpQmWyQ/qizdsQTsnFqN2fa3qKScrqkdeqj86w0HwUYbNMuL7um6mm8GUN+KnoVCKNQo9OCwzGNT899Y4BoZSj9y3CjtBh
MIME-Version: 1.0
X-Received: by 2002:a6b:7e02:: with SMTP id i2mr37722747iom.172.1577538662128;
 Sat, 28 Dec 2019 05:11:02 -0800 (PST)
Date:   Sat, 28 Dec 2019 05:11:02 -0800
In-Reply-To: <000000000000b63799059aba5164@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009360cb059ac3575d@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in hsr_debugfs_rename
From:   syzbot <syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 4c2d5e33dcd3a6333a7895be3b542ff3d373177c
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Sun Dec 22 11:26:39 2019 +0000

     hsr: rename debugfs file when interface name is changed

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1391cfb6e00000
start commit:   3c2f450e Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1051cfb6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1791cfb6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f6119e2e3675a73
dashboard link: https://syzkaller.appspot.com/bug?extid=9328206518f08318a5fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106d4751e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1775a49ee00000

Reported-by: syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com
Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is  
changed")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
