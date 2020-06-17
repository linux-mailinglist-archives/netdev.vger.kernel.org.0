Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318B91FD49C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgFQSeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:34:05 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57341 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:34:05 -0400
Received: by mail-il1-f199.google.com with SMTP id k13so2125047ilh.23
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=F3B7POYganjcYcTK3xulmlzDnkNmuFC83gI/QGxJRTY=;
        b=fh9iuRnvV7lDhZL1ZJ+/rbmoAF3d3rjlmG0WKChtuAWqW1A5KeQegz1drVQkWJo4B/
         wu2M9Dzz0Qunfnc99bY2NrkkcvgnBIpHyuETGP+zqTAA2NRxPahUaidRWjETfVydvUxV
         RDzSzz8+EqBthS7SLwfStSjOIRybS5FN4U/aC3xVUsiPUWIxjC+ugsCmOokdlSfDLotN
         JwUEhs0+ctaDlrJgQsN/cU9VQkcY4Z4eTgeouOvaqXucp4llKA1DXig3xHJUsePqhg+8
         L5Q8ywCd55zkFk5Mlv/+0+2Ozlno23YGQ8FqkVvsTQb++rCOPuFQfy4trNn5jQiwq8+F
         6sIw==
X-Gm-Message-State: AOAM533YeqWaVABOqkPcbtpKs8mfvvEFnq8p4WotGjnX7ufE2kq16y4l
        e7pIKhFUJvqVCmye9KBrzhUysl+1yv3kNQ2+cHLZr+7MPXVr
X-Google-Smtp-Source: ABdhPJygKKcZu/ebf2TevbrWJlM+0CuGBrPVjGvdAgLKjnmnW+3Wbg2+h5A3SrR7rk6IBnaFssLxIhPC1NUTeKocc3UNX41F5Ya9
MIME-Version: 1.0
X-Received: by 2002:a02:770b:: with SMTP id g11mr621320jac.69.1592418844130;
 Wed, 17 Jun 2020 11:34:04 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:34:04 -0700
In-Reply-To: <0000000000000655c0057cd141f1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000089c74405a84be7aa@google.com>
Subject: Re: WARNING: locking bug in __queue_work
From:   syzbot <syzbot+6174a6c5eba4b3cdd606@syzkaller.appspotmail.com>
To:     agruenba@redhat.com, bp@alien8.de, cluster-devel@redhat.com,
        davem@davemloft.net, hpa@zytor.com, jon.maloy@ericsson.com,
        keescook@chromium.org, konrad.wilk@oracle.com,
        kuznet@ms2.inr.ac.ru, len.brown@intel.com,
        linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@redhat.com, netdev@vger.kernel.org, nstange@suse.de,
        puwen@hygon.cn, rpeterso@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tipc-discussion@lists.sourceforge.net, wad@chromium.org,
        wang.yi59@zte.com.cn, x86@kernel.org, ying.xue@windriver.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit ea22eee4e6027d8927099de344f7fff43c507ef9
Author: Bob Peterson <rpeterso@redhat.com>
Date:   Wed Apr 29 13:45:54 2020 +0000

    gfs2: Allow lock_nolock mount to specify jid=X

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fcf249100000
start commit:   fe5cdef2 Merge tag 'for-linus-5.1-2' of git://github.com/c..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
dashboard link: https://syzkaller.appspot.com/bug?extid=6174a6c5eba4b3cdd606
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f6c7e3200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101507fd200000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: gfs2: Allow lock_nolock mount to specify jid=X

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
