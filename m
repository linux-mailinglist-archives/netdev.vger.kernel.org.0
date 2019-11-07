Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539D0F304A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389674AbfKGNoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:44:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:37954 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388780AbfKGNmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:06 -0500
Received: by mail-io1-f71.google.com with SMTP id q4so989444ion.5
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9/okOXkdmyxLp+oZdwuHSBXPqMIfQXakCi7QdBsKzL0=;
        b=RnGZ9UOL0Foh7+rd2WkTmPZkRCohMVu/XlTxMoOuHMeQvJdrGO7qYK1MtKpfc/w5eT
         kJJnDoNxGl96HNsrmUja4Zy20aW6314YzI6ToWNaNjyfnna9anaEUVmh1kfLueD4V7m6
         jPI6htrobojYBG8UpEHrdKSEUXm65vsHQofPHHXbWgG74AF+49gBeN8ITfUPrvcERD9j
         +A/o77AQ9SDuzo1LX+ZWATuH2DZquQqVVAo8R8Bn8tk2HCH+eEIi2ne2LJiBK36NTy+v
         LwPYQ2wJhpgdRWF6yRVhJTlIfQSeuUKA2aIK7ocdj+O6wPIh2EOibMqU9Yd36bqIvnyL
         bibA==
X-Gm-Message-State: APjAAAULFnFvHpqovK5FA/F/pgSsw66D/sZLJrppzEfyI6fmcwbckvtH
        24+QGlq8M73LEWmh2IcZmcYVWeYUetRo8MaklNLagoJOPMDr
X-Google-Smtp-Source: APXvYqz62VjOcTgDOFUdTJ8ThmzQiqH3nU+L2+77ligMCjRnKr8tpBSanxdr4g/glcLnWKYfWPvY/mTB8gNEft9wB4uAI6DEqooQ
MIME-Version: 1.0
X-Received: by 2002:a6b:f914:: with SMTP id j20mr3763359iog.223.1573134125585;
 Thu, 07 Nov 2019 05:42:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:05 -0800
In-Reply-To: <00000000000024f01405708aab83@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd5cdb0596c1d4a7@google.com>
Subject: Re: WARNING: ODEBUG bug in p9_fd_close
From:   syzbot <syzbot+d702a81aadeedd565723@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net,
        dominique.martinet@cea.fr, ericvh@gmail.com, jiangyiwen@huwei.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 430ac66eb4c5b5c4eb846b78ebf65747510b30f1
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Fri Jul 20 09:27:30 2018 +0000

     net/9p/trans_fd.c: fix race-condition by flushing workqueue before the  
kfree()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b5c342600000
start commit:   1e4b044d Linux 4.18-rc4
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
dashboard link: https://syzkaller.appspot.com/bug?extid=d702a81aadeedd565723
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17fa550c400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1214c2c2400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race-condition by flushing workqueue  
before the kfree()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
