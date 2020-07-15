Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861EF22127A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgGOQjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:39:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33453 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgGOQjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:39:05 -0400
Received: by mail-io1-f71.google.com with SMTP id a12so1737115ioo.0
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 09:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bpi1X2/kiZRhiI5Uh4MWU1GOK2TwFKFWyvVbQHnHroo=;
        b=TXfAe57CvWBUwTx9F3C7CbARpmhLTY99cwisXEfLvDlXX1u2E1CNFSYhjqtg+4GzPx
         nVNhqjdXbbM92z1nND/AgHx6tKQsNV5TF1diYdMqV4yBZVkM0skd3FxbNmbWiCLxirRj
         6srECJ4D1sI2KAzvhapaxu2SeyxY5ohRfx04G6pklnZ9/floLLIxVVNvSQB8pTX2T4Di
         mnacqn5J+ocXinPWfXQD6gcdy6CNeXcl9q/T56iDA27ifjQR60Zyz+v+t+fTtiYK2LMP
         xQewp+GpNQoUtQE42P7CJrf9bCbgAwdqgxGwPrK35AmO/5nkuzGwOq0uDgTpoy6+3Mvn
         6qIA==
X-Gm-Message-State: AOAM5320WHLUSkqQEyQ3A555VmnXMqhl91L4qRT5uYkBK0f30NNxblHv
        FyflqtjcisxMsHr0jlA/EPJC1kgnkFCFLbht/Kr0m3mai4SG
X-Google-Smtp-Source: ABdhPJyj/1GBiR6PORckm/5csMRZ7ojgTW/dLEi19AkOiFkL5lHeuRaRNTDxUunwfQt8Wvb4CMqCf2S1geELgmOTfXfL7noTXw6M
MIME-Version: 1.0
X-Received: by 2002:a6b:16c4:: with SMTP id 187mr130872iow.7.1594831144722;
 Wed, 15 Jul 2020 09:39:04 -0700 (PDT)
Date:   Wed, 15 Jul 2020 09:39:04 -0700
In-Reply-To: <00000000000065e73d05aa743471@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dbb12b05aa7d8f77@google.com>
Subject: Re: INFO: rcu detected stall in __do_sys_clock_adjtime
From:   syzbot <syzbot+587a843fe6b38420a209@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158ab3e0900000
start commit:   a581387e Merge tag 'io_uring-5.8-2020-07-10' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138ab3e0900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=587a843fe6b38420a209
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14778a77100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15150e13100000

Reported-by: syzbot+587a843fe6b38420a209@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
