Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B61145D6C
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAVVBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:01:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:35686 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAVVBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:01:01 -0500
Received: by mail-io1-f69.google.com with SMTP id x10so592961iob.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 13:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lYr3VEa0Huaaj5cr2eT5ZYbboOtwrfmYEjzqbnc0FyU=;
        b=IqJs+TK4Ni7Ks2SLkbLV2p7jFp0Bf99ymApGLhKS/v+O2W19GdQzksbSkzOefyso2f
         IbJ48kv7oPrNR+n5KPDvjEV/iEyqujSJVgaZK55+gcyLXyLS4cRdg+33ikZgEdfprU71
         fZIvjLu6uk0xNKx902XYfA0YgWssI+WVVTLMJraF0Zoo5H3htkOJwRuxYuCTctkwNbLp
         Jd/Rowzf3ZtuAtEvh096jL3Rf5SJYKtsgjb+gOE/hj8aYHbGJLeibqzSy4x6U474k9on
         4UQWyIX/W8Xx8dy7uFuN7ihTqni6qfmHh14H3lQPfc/NnF77aub560mcWgw3HxL8IXrM
         vf/A==
X-Gm-Message-State: APjAAAUHOvRgMNpXmz5knuULfpqydC3u316Sz+uqun2vVViNvqxJVQrP
        rtQY3mdXltx0MFeKSWLyWSfxqTlcPGDjiJ0cJbAbFwLkdrmH
X-Google-Smtp-Source: APXvYqy98tfXila0SvcgGKr7oS77gUHB1tW0UiRvSHV2F9dhjQ09YKNKJt8UX6JmXLfF/xJtAX4wfwJJc78t2tikEEKrLfVlGsr1
MIME-Version: 1.0
X-Received: by 2002:a5e:924c:: with SMTP id z12mr8598447iop.296.1579726861270;
 Wed, 22 Jan 2020 13:01:01 -0800 (PST)
Date:   Wed, 22 Jan 2020 13:01:01 -0800
In-Reply-To: <000000000000a16ad7059cbcbe43@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000068843f059cc0d214@google.com>
Subject: Re: WARNING in bpf_warn_invalid_xdp_action
From:   syzbot <syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        corbet@lwn.net, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kuba@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 58956317c8de52009d1a38a721474c24aef74fe7
Author: David Ahern <dsahern@gmail.com>
Date:   Fri Dec 7 20:24:57 2018 +0000

    neighbor: Improve garbage collection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124a5985e00000
start commit:   d0f41851 net, ip_tunnel: fix namespaces move
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=114a5985e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=164a5985e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=8ce4113dadc4789fac74
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f99369e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d85601e00000

Reported-by: syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com
Fixes: 58956317c8de ("neighbor: Improve garbage collection")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
