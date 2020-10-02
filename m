Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED38280CD6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 06:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgJBEbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 00:31:10 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:52204 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 00:31:09 -0400
Received: by mail-il1-f205.google.com with SMTP id e3so145398ilq.18
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 21:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2rR7OFCkiGOcbn8yg3FFIizJzk0Y5CDsOwEAe9MFfqY=;
        b=XIreAtQLfU/h0u30mvyteBJK8g4q/gOaiYuJWg6sXu9k32PK4qWIRHlM4kz7j9CZPo
         blKWZTGvTNbwcBcSTYf5Irlo760OBJeT5tvXOvoX64w/Zp/5wHASi18SLr0c94vrMp1m
         kg1GxTipx7qPMuPj/YPXFTbJfGN8eiAbLdrDPvu+inSbUe2Xt9pvA6YGsp65A5k+nJCT
         3Xjk2lQaaRnnUJV7LNRwQ3Aulre3G1Xbj+RfBeDuVMSkxNsMSeQ8BiIbHrwQbCiiA/oS
         CGymqKnvoJF1dISJ16m3eUAQcxYpReEx+17JCF5T9uD8Ro6ggyR2uXzVSBGf3CvOZeR+
         UETg==
X-Gm-Message-State: AOAM5315JyD/oMZHIbaKgf/jQyeLblmiqW6z+3VH5AxmyFGNqnHuSZU7
        rWT4kKTX/X1vbZYXFUlRtM+qgY+o/8fKnIBRfTQ49ACNxCHr
X-Google-Smtp-Source: ABdhPJwyio9B9RK4QMV+77SSkDUiL2aBMDrXygJtRXJZn8ix0TJV07LbSiIGdgU/ICZl+Xp6JhyjTk1bOjljcqJ5nfrSfAkO2l0T
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24c1:: with SMTP id y1mr616780jat.119.1601613068931;
 Thu, 01 Oct 2020 21:31:08 -0700 (PDT)
Date:   Thu, 01 Oct 2020 21:31:08 -0700
In-Reply-To: <0000000000007b357405b099798f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a954d05b0a89a86@google.com>
Subject: Re: WARNING in cfg80211_connect
From:   syzbot <syzbot+5f9392825de654244975@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, david@fromorbit.com, dchinner@redhat.com,
        hch@lst.de, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 16d4d43595b4780daac8fcea6d042689124cb094
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Jul 20 01:38:55 2016 +0000

    xfs: split direct I/O and DAX path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f662b7900000
start commit:   87d5034d Merge tag 'mlx5-updates-2020-09-30' of git://git...
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16f662b7900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12f662b7900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b5cc8ec2218e99d
dashboard link: https://syzkaller.appspot.com/bug?extid=5f9392825de654244975
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1100d333900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1414c997900000

Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com
Fixes: 16d4d43595b4 ("xfs: split direct I/O and DAX path")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
