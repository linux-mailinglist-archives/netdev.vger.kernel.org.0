Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E7C1A2E82
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDIEvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:51:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39298 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgDIEvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 00:51:06 -0400
Received: by mail-io1-f69.google.com with SMTP id h141so1872091iof.6
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 21:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Yk+x42oEX6NPVtof+fwUTcYBaykSE3TPHHScZ5sRcbQ=;
        b=VchxU6Qb6DBTd0fEFtb4IPAC6lncLH4EBUeoODz4T6QhQE9UHetHRq8myxSoEfr+h7
         MSqsVWo20JE/aWtLrgOZKaoGQZhtYv19ix800PQ/G87+QJQOQWk46+F/i0YIN/mWVns7
         x1EMDgMz0yc8CJTa0QY0OoNPhdbtZThh2yBMDmgr3KYq85rERWBgEPC3N/DQcEeoq9wl
         4jBkkYy+jdPQQbrNfGc7Fq0Ex5NtBPRainYcZVhINjo9ujzmANZDYhx17ynZQtenIZfu
         SEbIj4Rh6+3644On5W9//rLMILzkmLO/2mYhp+fR04OEsm+N73xlopDLUEx9WjRLpL8N
         mtsA==
X-Gm-Message-State: AGi0PuaBt9AtoI89Jc6LQ5u207d5NMcNQXVQxFuYk95WqcZYRArUyQAF
        bYa/PV03Zim4r3Eko1YqnUR3E7HXlG3jTH8e6i9DGjbfSFMg
X-Google-Smtp-Source: APiQypLn7zMw/7P+fKa8CU3hxdQVFVajIQITeI3FCvHiaE5RKeyHuTcfFX3S5O8iY9W5R3DeJXsv7wxpJTD+bVVIi2d+2SImhIUk
MIME-Version: 1.0
X-Received: by 2002:a02:b70b:: with SMTP id g11mr992206jam.16.1586407866737;
 Wed, 08 Apr 2020 21:51:06 -0700 (PDT)
Date:   Wed, 08 Apr 2020 21:51:05 -0700
In-Reply-To: <000000000000f3b11305a0879723@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005da8f705a2d45d81@google.com>
Subject: Re: WARNING in kfree (2)
From:   syzbot <syzbot+50ef5e5e5ea5f812f0c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 0d1c3530e1bd38382edef72591b78e877e0edcd3
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Mar 12 05:42:28 2020 +0000

    net_sched: keep alloc_hash updated after hash allocation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1640e277e00000
start commit:   2c523b34 Linux 5.6-rc5
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=50ef5e5e5ea5f812f0c2
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d8ae91e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net_sched: keep alloc_hash updated after hash allocation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
