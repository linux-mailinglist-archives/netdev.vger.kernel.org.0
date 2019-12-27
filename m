Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF6712B0B9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfL0CrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:47:04 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:39052 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfL0CrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:47:03 -0500
Received: by mail-io1-f71.google.com with SMTP id i4so18014757iog.6
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9wUyWhkVCaEXCNwORLXmBdo7IR6pgdqnHT8ZPHyEEOI=;
        b=b0wwEO4l14ytn5uprhsN7748g1v4OIa2DW1+tV1eAs0GiJqr7RhdGUB3kk/Cu5GDQv
         slInt7DtQ5lbnlkERpkJgS83bkbwArJ8tMYejgbi7CtKRhaLfCLVAgH2k8ZfUVvGwxHw
         u1FI6C+C2LpI6By3FiVmT/wFStTdDQ3CFTyCPGcoZ3CPFWUmPtBZBhikXnDgdQmGq9y8
         /3jJetbdBSjNrRynf4MbQRHyBZG8DHIOjnM/6+cH/N17/9lw+z3pGhijn9ElFOwhXD7B
         galqtSLyuuLKHU2p7wdrVyEKCs8Zqbk1D83JZ4FeBJLfJAaWVfPeQkmTfhlM4MoQakEj
         PFoQ==
X-Gm-Message-State: APjAAAXBnIduRgxXp9IDGqebxwggHzpfkTQTXLbruyYGXlBK61s77+8m
        0wgTcxSwE/YNvGZgk+sV3N93sLa3T9uSQm0hEvhI6hTMKlFC
X-Google-Smtp-Source: APXvYqy/glUbW4fyY45ilDNcSBPrbmY8p44WAOpcXDXHF91TBRPIzoRZYjV4mJKH8foQH5c56NeEd3d20Al3XaiB4s0DhImJVTjq
MIME-Version: 1.0
X-Received: by 2002:a92:d809:: with SMTP id y9mr44099353ilm.261.1577414821279;
 Thu, 26 Dec 2019 18:47:01 -0800 (PST)
Date:   Thu, 26 Dec 2019 18:47:01 -0800
In-Reply-To: <00000000000057fd27059aa1dfca@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015fd8f059aa682d3@google.com>
Subject: Re: general protection fault in xt_rateest_tg_checkentry
From:   syzbot <syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 3427b2ab63faccafe774ea997fc2da7faf690c5a
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri Mar 2 02:58:38 2018 +0000

     netfilter: make xt_rateest hash table per net

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151a26c1e00000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=171a26c1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=131a26c1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=d7358a458d8a81aee898
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13713ec1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1272ba49e00000

Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com
Fixes: 3427b2ab63fa ("netfilter: make xt_rateest hash table per net")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
