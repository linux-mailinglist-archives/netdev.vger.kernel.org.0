Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F069F25DC27
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgIDOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:44:14 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:55616 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbgIDOoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:44:10 -0400
Received: by mail-il1-f207.google.com with SMTP id a15so4910691ilb.22
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 07:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GE20mkCJFx34V9csXbBi5MpSPEm23j5O5gEKMXhuGs4=;
        b=UKb5NeYDUSnrcBTcmbefyWkh6+YhP7+rLaPE3KMCOoOm0JukAB4TstBYIWKJ62mTMl
         k/tiWPDI4v3k0005Bvav3JWy1P3dmDiFp4ZkBq9bAAuNYuLWmV4OXlZ0jgxjJqhm1La5
         76jitARWSO3DCPRpmyx/nvxn6dQjkJpqF0C8XxpcO22fM9+FRLKERRIj/dVw+9ph4i27
         FWy6EPWXYXzKM9JZNf8lOZuAKLLmvGUHnRgBrvZCv7NQCLs+b73qqPvwq2KxddsTO4+N
         jRRs2AZrrRgPbOXuumdxyssGM1DyQaBsYNzOgA3NdVLhXeCGCC94Idf+spcx6CAYl/HU
         jhaA==
X-Gm-Message-State: AOAM5317VYJGdsS6uu4VgMbD+NHRqNgNQk/ulUW0Gc9E19BZdol8ECVb
        xgx1jrivBdSVm9hSzmzukkvrqWMurOKCj/xRDcZsrqhStA6l
X-Google-Smtp-Source: ABdhPJxZCmzJJSBtD6oipaJudDBJ1GQFFB0c3Y+RmR7v/iFXEsAA2X6Ph+jfCB/546LXa6E6JWGbeRIObehShZ2GPeZnQjV295Tv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1303:: with SMTP id g3mr4832562ilr.218.1599230649567;
 Fri, 04 Sep 2020 07:44:09 -0700 (PDT)
Date:   Fri, 04 Sep 2020 07:44:09 -0700
In-Reply-To: <00000000000055e1a9059f9e169f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8101605ae7de686@google.com>
Subject: Re: KASAN: use-after-free Write in refcount_warn_saturate
From:   syzbot <syzbot+7dd7f2f77a7a01d1dc14@syzkaller.appspotmail.com>
To:     abhishekpandit@chromium.org, alainm@chromium.org,
        davem@davemloft.net, johan.hedberg@gmail.com,
        johan.hedberg@intel.com, josua.mayer@jm0.eu,
        jukka.rissanen@linux.intel.com, keescook@chromium.org,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mcchou@chromium.org, mike@foundries.io, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b83764f9220a4a14525657466f299850bbc98de9
Author: Miao-chen Chou <mcchou@chromium.org>
Date:   Tue Jun 30 03:15:00 2020 +0000

    Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f92e3e900000
start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf567e8c7428377e
dashboard link: https://syzkaller.appspot.com/bug?extid=7dd7f2f77a7a01d1dc14
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b606dc900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123e87cc900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
