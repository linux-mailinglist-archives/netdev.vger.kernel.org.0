Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9330259AB
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfEUVIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:08:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:32908 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfEUVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:08:01 -0400
Received: by mail-io1-f70.google.com with SMTP id s24so77626iot.0
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 14:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UzmPeUGaB8JKZJ9CS0AWltu9MikJ5xxP1GF6GVzJW6I=;
        b=fy2qgwu5tXIp3v5QPK2psIkriwk/y/YM+2WOxOhhjlh/4VyY78e7s6buFzGGyA6IZz
         5mLCnttJqDUdFanWUzSFYptU3xfk0Qdt8h6jbtqC74ArmYpL69MeA3RFqPCKtbGswpb+
         FxE2uZTKEllDDZnAXi4cU422m1uEo6N2Di7IUMfC8fS3zkcYZAi1+cUpoPp+kG/fz2SN
         gxroTgDWEQ0kKe0By4t6CDaKuKKh5XAp4XpVqL54NhshpI3+dZ1Hq/H8jJAvnLI5/muL
         ZR3aQr99ZNTRHjbHLS+HE29WyC7HvLEGqTdG7OWpgkhAwW4IhYv1LM1ahBR1rS6SfeoF
         ti4A==
X-Gm-Message-State: APjAAAU7yJq/rbPbDyTVrt1VZQaPTZtE/iistgLM3wH9A5QW6+V9I1nH
        aAokhyAJFBaSOMsfCjix5RZIJHqK9npgze25tH1rum1m9YT6
X-Google-Smtp-Source: APXvYqwtcVeO8IOlYtpHb+pYSw2wdqPB0c8EwcnSxnMt61P6oQuZ5TprV3iiiFbK3fSCqQiDaNir0ZBnxV+7ib/d+4hx9iNpXOLP
MIME-Version: 1.0
X-Received: by 2002:a24:7309:: with SMTP id y9mr5819441itb.162.1558472880669;
 Tue, 21 May 2019 14:08:00 -0700 (PDT)
Date:   Tue, 21 May 2019 14:08:00 -0700
In-Reply-To: <000000000000ac9447058924709c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071c8a105896c3ef2@google.com>
Subject: Re: WARNING: locking bug in rhashtable_walk_enter
From:   syzbot <syzbot+6440134c13554d3abfb0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hujunwei4@huawei.com, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, wangxiaogang3@huawei.com,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7e27e8d6130c5e88fac9ddec4249f7f2337fe7f8
Author: Junwei Hu <hujunwei4@huawei.com>
Date:   Thu May 16 02:51:15 2019 +0000

     tipc: switch order of device registration to fix a crash

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1285d39ca00000
start commit:   f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1185d39ca00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1685d39ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=6440134c13554d3abfb0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c586bca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14759fb2a00000

Reported-by: syzbot+6440134c13554d3abfb0@syzkaller.appspotmail.com
Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a  
crash")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
