Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5227CF3031
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbfKGNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:43:20 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49091 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389059AbfKGNmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:07 -0500
Received: by mail-il1-f199.google.com with SMTP id j68so2640077ili.15
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Vf6K/h0qpqQKsSoL002ZxeehhKzDYr+4ythimfWKfZ8=;
        b=uOwYqj8z6Gb3UgChFFqsEDohOdBs4ShZXP6FmIJyMj8FhykmiKR0oHT/BpC1gpI1N2
         ep91QEqr18zyGrguuuV9KKDbH1scUo/b7+FKo5K4H3KFg87aRdbX0cPWvF+rPT38PevA
         u4g2KS2myq9CGQITwXkroD8zkFUxrxCEoANb0enERmsbBwIC6vGHZnIaTNtE+AdgvKn+
         3MU5zR3xe8zI3D7mIbAQCILERuTHBHu9EtUFouYXSa/ZClefdJZjr3vy4KZJQp7yT/sv
         zR8zAvSLdsjpi/Buf8KMyWCND2YA2Oz2hFldB2pDKgx5GvYsFwGy+IuTfkoFDoXPxYaT
         gCXQ==
X-Gm-Message-State: APjAAAVKq6DD0etc+jdFlDXURxHtf+FsbviVh2mfdEwd2MXcDH5sa9NS
        ChzfGFGKx7F5/rsP1hEdgSvhTDVaTdIA4i/Sfs+brrFX3zOY
X-Google-Smtp-Source: APXvYqxtqS9jnDj10uHB/QHrMRUKjJWOjaExI73Hx2xEMNtJxQbyy5I+Msc61BdsDsl5SzjhgXSd4Tpv0SaNrrMljsv9YcDnaitG
MIME-Version: 1.0
X-Received: by 2002:a5e:aa10:: with SMTP id s16mr1261527ioe.113.1573134125893;
 Thu, 07 Nov 2019 05:42:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:05 -0800
In-Reply-To: <00000000000054395605708fbd13@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c214300596c1d487@google.com>
Subject: Re: BUG: corrupted list in p9_conn_cancel
From:   syzbot <syzbot+ad0832746849421bba05@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11adad06600000
start commit:   c25c74b7 Merge tag 'trace-v4.18-rc3-2' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
dashboard link: https://syzkaller.appspot.com/bug?extid=ad0832746849421bba05
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d8db0c400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c12a58400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race by holding the lock

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
