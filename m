Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF33CF301A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbfKGNmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:31 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46462 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389179AbfKGNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:10 -0500
Received: by mail-io1-f70.google.com with SMTP id r4so1849669ioo.13
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=S2wRVclg8UQWRvym++3WP5HdS90cEd2sAd4gL9TrV+I=;
        b=Hvq8VWjFqccj2aweFTzffAi16cRGrxbm1CrfmiIAQO2aSqJxqFc/U5U2+m0G31ouP2
         jCs3TqdsHqEcDEYKuz0oqIRRDToFUvOOJCpRq/1lV7vz4UYptJcKYWFQ1KwSl6doLYW+
         sC2ZQ/hcQDiNR7S0/xUiT3N3Ew1+yUuWeNUmj2Sm7PlXgacHcztQUPHPaxg1sXZLWtMf
         XqkaliCtyaUWSIssPfYFuQ+li81WBvbi+lAFpnMymmQ+oT/i+/txKcq0xrPSw+tWhpqv
         TcYlRMzdwAqUgHpQfLc3dVZuDA+9VDA8Q3aeULK/GVudcL/YpkonmOD36FZ/8jAt1gsf
         3bzA==
X-Gm-Message-State: APjAAAVR+rxqal0qvNF8VQZPeCA1BmnOqwT1JcP5ygbBu5Addxjcjs3V
        iqPmZ0hzfcrVmqPl/bTokwABROuVr4zIqXbwhnozMrVHt5J5
X-Google-Smtp-Source: APXvYqz9Q2PgD7h70IK2LJz5tS3XrxOEo+uTlIzI6FagviYlipCps0BesCYv8Ev2NfBqsoEX1aftYzudEyLJMvtAP/9TWFBjR5Lx
MIME-Version: 1.0
X-Received: by 2002:a05:6638:394:: with SMTP id y20mr4277492jap.0.1573134129274;
 Thu, 07 Nov 2019 05:42:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:09 -0800
In-Reply-To: <0000000000008c6be40570d8a9d8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5a6620596c1d43e@google.com>
Subject: Re: general protection fault in propagate_entity_cfs_rq
From:   syzbot <syzbot+2e37f794f31be5667a88@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andy.shevchenko@gmail.com,
        davem@davemloft.net, douly.fnst@cn.fujitsu.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, info@metux.net,
        jbenc@redhat.com, jgross@suse.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, ville.syrjala@linux.intel.com,
        willemb@google.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit bab2c80e5a6c855657482eac9e97f5f3eedb509a
Author: Willem de Bruijn <willemb@google.com>
Date:   Wed Jul 11 16:00:44 2018 +0000

     nsh: set mac len based on inner packet

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170cc89c600000
start commit:   6fd06660 Merge branch 'bpf-arm-jit-improvements'
git tree:       bpf-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=a501a01deaf0fe9
dashboard link: https://syzkaller.appspot.com/bug?extid=2e37f794f31be5667a88
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1014db94400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f81e78400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: nsh: set mac len based on inner packet

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
