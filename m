Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6359AF301B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbfKGNmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:31 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:39681 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389186AbfKGNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:10 -0500
Received: by mail-io1-f70.google.com with SMTP id e17so617951ioc.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lYXHu1+8CxUYZrtgD2bXy/E8sjSme0LaouR97ajask0=;
        b=eqXw5TeriZqIP85paW5U7dEwkpLEa7JtWt6pHNUBguwZiHOiVvIDuSMt+md//tUyz7
         l6+GtqwWGxbRC5KeVIj8DM2fVNex9naVatGEQqfs7GBfqANxTJssJmM/Ne3PsAu72Mhx
         JfEMqIsKZzN8tCNjfAiF85c/4sp7eL8c9klNBpS5bzXdiIuihboSqZREel40xsUAwRq4
         7YNzpCAUiHRE52Dw1fy0hRWqeG230KDIF5piIehMwFcPwWttAwJtF2+x2OAuAG73oi62
         VykxXNsb3AEoML1ELwQPKZja3cMPzpA55RznceVBKlTD6bXn5VeAf+RzQzO6d/nC3Gfs
         lUCg==
X-Gm-Message-State: APjAAAUynlf3gNBYy+GHeSJd9uMV323eu3VbdZhbme+GEshEIAvR6OeU
        9gI6RVdIiqVwvmtYVxK7/7QAvn3X41PW1Y9QWMsDJC3g9RHz
X-Google-Smtp-Source: APXvYqyCn5PnsReBzzn0eMeMMCw+qkOz5YAQ4Lrcbdu5KR2Dy7fnX7Bn1RK2uLQWMUldMvI5RwDNhljITPEXD6xZrL9jqRFluc7a
MIME-Version: 1.0
X-Received: by 2002:a5d:9756:: with SMTP id c22mr3662214ioo.233.1573134128190;
 Thu, 07 Nov 2019 05:42:08 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:08 -0800
In-Reply-To: <000000000000f68d660570dcddd8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e51d450596c1d472@google.com>
Subject: Re: kernel BUG at net/ipv4/ip_output.c:LINE!
From:   syzbot <syzbot+90d5ec0c05e708f3b66d@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, johannes.berg@intel.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, posk@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        willemb@google.com, yhs@fb.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit e7c87bd6cc4ec7b0ac1ed0a88a58f8206c577488
Author: Willem de Bruijn <willemb@google.com>
Date:   Wed Jan 16 01:19:22 2019 +0000

     bpf: in __bpf_redirect_no_mac pull mac only if present

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14175486600000
start commit:   112cbae2 Merge branch 'linus' of git://git.kernel.org/pub/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=152cb8ccd35b1f70
dashboard link: https://syzkaller.appspot.com/bug?extid=90d5ec0c05e708f3b66d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153ed6e2400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1539038c400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: bpf: in __bpf_redirect_no_mac pull mac only if present

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
