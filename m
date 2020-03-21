Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB67718DDE3
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 05:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgCUEtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 00:49:05 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:50300 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgCUEtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 00:49:04 -0400
Received: by mail-il1-f197.google.com with SMTP id z12so7010007ilh.17
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 21:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rvmUPiw7rPSJlg92ogk4urICD4aqXpL+uX1Y0EwFPbo=;
        b=oOsBjHy0PPf+E+MgnQap1kCfbLhomPiiiCuEX2JUNbPxRVMBfe/fd2VN0BcinSEHgJ
         90vkUjCYc1e8M0sHOzCopAbR7g0Ec3gDaYfENfSMzQN+kFVYFPVAxbZ4QzFmld4yLIL8
         7tJeNvfu5x067MOGMpjDhPxK6tUZUM+gUkdfEzXdre5mQ8opoHbfjRttgN4J+Q4ENVee
         Ves1Lnx8k5HV7JvIw1m00VF0lad4T+0t8AmfqUvns94mcBIx+V9ZOeKxBwkqfnHAEoLN
         vJY0PVAFuYsJcP1eoh94uxh9o2NK7CpB25PMlj3pzf8qReagKC1t+5HBXluySiVZunsR
         hoHA==
X-Gm-Message-State: ANhLgQ2vrkP2GlnrdxucIN3oXl3C+13SHCuiKnzlpDfYE/q696ENIDGF
        8yZNH0hhz/zCN+jUvNACJbsoR7y59Lt8wpY+Z1/5pCt6SJKN
X-Google-Smtp-Source: ADFU+vsIyP0VfZ6xrFZPZ16PlF2rSDU5ykaROKu09kcDvjHT5c2GSBuKPcaP+zOXNNI4Vxujqx9weHYXl9pOs/D5HzZ36C8tFWMC
MIME-Version: 1.0
X-Received: by 2002:a6b:7407:: with SMTP id s7mr10534502iog.11.1584766143328;
 Fri, 20 Mar 2020 21:49:03 -0700 (PDT)
Date:   Fri, 20 Mar 2020 21:49:03 -0700
In-Reply-To: <000000000000b380de059f5ff6aa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006777805a1561fa3@google.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
From:   syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>
To:     adam.zerella@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@dominikbrodowski.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 836e9494f4485127a5b505ae57e4387bea8b53c4
Author: Adam Zerella <adam.zerella@gmail.com>
Date:   Sun Aug 25 05:35:10 2019 +0000

    pcmcia/i82092: Refactored dprintk macro for dev_dbg().

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175cffe3e00000
start commit:   74522e7b net: sched: set the hw_stats_type in pedit loop
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14dcffe3e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10dcffe3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5acf5ac38a50651
dashboard link: https://syzkaller.appspot.com/bug?extid=46f513c3033d592409d2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bfff65e00000

Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
Fixes: 836e9494f448 ("pcmcia/i82092: Refactored dprintk macro for dev_dbg().")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
