Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF201AB49D
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391401AbgDPALM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:11:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39019 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391380AbgDPALG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 20:11:06 -0400
Received: by mail-io1-f69.google.com with SMTP id h141so22274254iof.6
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 17:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fpoqVPhszf0NVg05C+Ce87uumBc0cG0RasYX5KRrK/A=;
        b=Y+7kmIDfQ1tgLGQ2412gYX2eInXHZQu+uKBynrA7hJNRSwuSVHkW9aDYojUUVf9Vag
         9zvHnVW2PZNlEfvym2BkDmx7rvYk1ZZI2EL8wg14D0KpoxWGFkciEbHKFdiwP17RhPvf
         bZwdtxFYMnAKKaIGvXN5w+R4k5HDuhDoK8/Ot422pJs6FLud7aXPXwGSZVVQTNr4A/3I
         4vGVIQzY61IAxiZreleg1tGLQHNtv+Lr7D4XtAPfw91VlwYlL8Udr41X2vhQgE7JglVm
         CltzqKUHS7uOR8qDUDS61QQIpxz4OHZqgyWvBzZpkQqfAihxVA1W6+guEe2HEJp9jrGj
         odEQ==
X-Gm-Message-State: AGi0Puaj8agyx45SQ+tCkfqGiHz2+X5ljEDXM6XdA15SbP/xro6YTgEt
        ECih9bNUBzlgi8b/SVKiQFUFxXuIOB6YoKV+bauXV0RU1Gf+
X-Google-Smtp-Source: APiQypKcCgI3/2owP+Ax+avsl/BzFIkiA31xvFAOZDOMymkWaDm+4dJSPNPqeM8Ut+RNphNBCe4mDPpNDLKfGAmGhhXHK5QOcm+K
MIME-Version: 1.0
X-Received: by 2002:a02:7b05:: with SMTP id q5mr28919026jac.105.1586995863913;
 Wed, 15 Apr 2020 17:11:03 -0700 (PDT)
Date:   Wed, 15 Apr 2020 17:11:03 -0700
In-Reply-To: <0000000000003ec128058c7624ec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba8e5605a35d4465@google.com>
Subject: Re: WARNING in kernfs_create_dir_ns
From:   syzbot <syzbot+38f5d5cf7ae88c46b11a@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, hdanton@sina.com,
        hongjiefang@asrmicro.com, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, longman@redhat.com,
        mareklindner@neomailbox.ch, mingo@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, ulf.hansson@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 810507fe6fd5ff3de429121adff49523fabb643a
Author: Waiman Long <longman@redhat.com>
Date:   Thu Feb 6 15:24:08 2020 +0000

    locking/lockdep: Reuse freed chain_hlocks entries

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1008138be00000
start commit:   72825454 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=38f5d5cf7ae88c46b11a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6c439a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1353c323a00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: locking/lockdep: Reuse freed chain_hlocks entries

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
