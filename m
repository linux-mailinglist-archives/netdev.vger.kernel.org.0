Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26235D0AF7
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfJIJWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:22:04 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52669 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730004AbfJIJWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 05:22:03 -0400
Received: by mail-io1-f69.google.com with SMTP id g8so3568434iop.19
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 02:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HPZvvZ/9gjJip4a0YxXlSMk8fxyxykOWKERE6MG24B8=;
        b=oBDgaXiUo+ODQlDqpIGknVLB+tPMg/SQJdIb1OQSNqqs066Uw2l1HV+F070r7vTwf+
         rWZxND3RBUVONpnOfWjxgIFjuRwJB+Ot9Pql7fDonAuVLlcRpsuidDZ6WtvRtwDubvOZ
         07QDlN09jzkDwk25to8EPlpGeDsfOzy8iYVnh2n1sX+WKt9l2k3zcgJYG05SoOEOoiu7
         Du1vRGGAu1ZS7mtshYIX3lWPN/PdhuXYFifglw5FaQJX670tYswpIxqZxcZnq7YJmuYl
         ciu0ogmU7GInmfqIlJwOzcrN8Fq+IlIshTF5NIaVTC7Xgr4r/Kd8Gw/Po8hdzZ1OPzp2
         zZBQ==
X-Gm-Message-State: APjAAAWHQ6uzCc4ZcdJt/ju4y/T3XmGTCKVc37QEOh/9SIniNNUkWcoH
        VrM28pkajVBCPzBM81yUnuIJbHP/AvBDHIlkZ6GnoKLv+8VG
X-Google-Smtp-Source: APXvYqzusl152j/JV35SyZSwQmWMSoEboM9LDlzkJhrF5z5FXK489gY6noXCILJxl+gcSeoJuYNvC0rsereWl09pW8rCFBXW5FsW
MIME-Version: 1.0
X-Received: by 2002:a6b:6018:: with SMTP id r24mr2427870iog.25.1570612920964;
 Wed, 09 Oct 2019 02:22:00 -0700 (PDT)
Date:   Wed, 09 Oct 2019 02:22:00 -0700
In-Reply-To: <0000000000003dc9ba059475614f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003bdc5f059476d153@google.com>
Subject: Re: KASAN: use-after-free Read in tipc_nl_node_dump_monitor_peer
From:   syzbot <syzbot+d2a8670576fa63d18623@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@mellanox.com, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 057af70713445fad2459aa348c9c2c4ecf7db938
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Sat Oct 5 18:04:39 2019 +0000

     net: tipc: have genetlink code to parse the attrs during dumpit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ac08e7600000
start commit:   f9867b51 netdevsim: fix spelling mistake "forbidded" -> "f..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16ac08e7600000
console output: https://syzkaller.appspot.com/x/log.txt?x=12ac08e7600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=d2a8670576fa63d18623
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d3e04f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a76593600000

Reported-by: syzbot+d2a8670576fa63d18623@syzkaller.appspotmail.com
Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs  
during dumpit")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
