Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793831FFE5B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgFRWwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:52:08 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:49282 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgFRWwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:52:07 -0400
Received: by mail-il1-f197.google.com with SMTP id i7so5094120ilq.16
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=eWQTfX1g8JOgeWYSSIzFk760Kxm5cADaSJtq+50orro=;
        b=eJIGjFzYIsRzrWtnPHNfRtxKlsWdBPw1ywMxliDZbR4Y6JNrY6VlqPCmYc5dD6pKaD
         Mpm37uY9KUUvoUG5Ttl0P5Ndd4TRvlHK7RxsKSY8vIT0aZWPGRvaqpDXURkHpnLK2Sfx
         Uj06pN1LKU2ma73s8Epa/NyiIdE51yxcfuSzSXGAEcf/sapUMfA73PXvMqX2MmQ06R+B
         tcaHk7OJ8fGkFCrkFgJxCDw+1uLMvrqsnJUD9yiTyAnph6oXkw4qxnXk4CkCYmNbn4s1
         6rrjez5kWn9GhQSjnk17vtOx4iAlPB0KYbSYTIaLOi0CbcIWRVcvRv0qEbD4jUB5ZAMn
         aFEA==
X-Gm-Message-State: AOAM5326IboxWHf4DzxEgN1FbyfTPpnUe8QhRGnyx3h3aipNqgR+LHVS
        wPqL17hbWkehIu1yMaGuJr2/V6fIRJGo8QfzPDfQdQUDS4l9
X-Google-Smtp-Source: ABdhPJzueD6XzKGdxKBPJFSLQ5DjaVU/HXFzLbQiJVdvX4tT+HS52gVxYvFpJZJ1Ljb0snBMpA/OhqPiLRLuhFxaiBc66KFh8fm0
MIME-Version: 1.0
X-Received: by 2002:a92:a198:: with SMTP id b24mr864894ill.46.1592520726414;
 Thu, 18 Jun 2020 15:52:06 -0700 (PDT)
Date:   Thu, 18 Jun 2020 15:52:06 -0700
In-Reply-To: <00000000000086d87305801011c4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000320bcb05a863a04c@google.com>
Subject: Re: general protection fault in __bfs (2)
From:   syzbot <syzbot+c58fa3b1231d2ea0c4d3@syzkaller.appspotmail.com>
To:     amitc@mellanox.com, andy.shevchenko@gmail.com,
        bgolaszewski@baylibre.com, bp@alien8.de, davem@davemloft.net,
        douly.fnst@cn.fujitsu.com, hpa@zytor.com, idosch@mellanox.com,
        jon.maloy@ericsson.com, konrad.wilk@oracle.com,
        len.brown@intel.com, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, petrm@mellanox.com,
        puwen@hygon.cn, rppt@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tipc-discussion@lists.sourceforge.net, x86@kernel.org,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 46ca11177ed593f39d534f8d2c74ec5344e90c11
Author: Amit Cohen <amitc@mellanox.com>
Date:   Thu May 21 12:11:45 2020 +0000

    selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1315b059100000
start commit:   8834f560 Linux 5.0-rc5
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f00801d7b7c4fe6
dashboard link: https://syzkaller.appspot.com/bug?extid=c58fa3b1231d2ea0c4d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bab650c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a331df400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
