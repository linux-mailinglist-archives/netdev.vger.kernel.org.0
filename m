Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6F1620A6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgBRGDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:03:02 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50654 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgBRGDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 01:03:02 -0500
Received: by mail-il1-f197.google.com with SMTP id z12so16135527ilh.17
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 22:03:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=s90mtOgUot9BLQ8vD0J1ERBgI+WUMFy7aI1WWZiJRPc=;
        b=NXsrQd2MdYofnbJ4cKgWazE5n9kQFN5nmAvVYHT3nzrDTYd7awsHlr70QUyOTbwC36
         1LxL3COpNQb1WQdSpaAZeXmTMg3/h9qc0vYKQyuNe1H+h3z9r3TWPTxruQtjj37Td3l3
         453+RZx2VFeIDmyvm3Tu99y/LfVVS0Rjn0YcEbWFMMJdWRQOs4hF9sg59Jam5rwU4Djs
         ZmcxqG/wZve0Q2IOoc1UWfo81VBoRfsrQzju0UprRICUm8QAniNtx/SWKdbxq3Ws6UvN
         CegKKJroLThjn1hY54JyeHHq265Idf9CPp8bdRiK2qzaCFkyAdlFcBMCcgpHmxY8TC43
         Kwww==
X-Gm-Message-State: APjAAAX7ZPCt3TqB+u+lXQIp5J1qWPqMqQx3WMVG5u+IVrwRhqjiEO2x
        uu6AAVvYnf9pKnMnc+q6LQybIRTlAn0Eq9ab+ukVmN2aARrR
X-Google-Smtp-Source: APXvYqyKbrb4s0QHhXUHJyLBgCo8QfHdPqjJt+Gn6V7xrj04pmL0UCt5qN2sCqpWHU5C1lVX4urkbh8cyDLI0yG0Ty2a9C4plVi6
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f9:: with SMTP id s25mr15172224jaq.83.1582005781889;
 Mon, 17 Feb 2020 22:03:01 -0800 (PST)
Date:   Mon, 17 Feb 2020 22:03:01 -0800
In-Reply-To: <0000000000007838f1059ed1cea5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a98782059ed36cb4@google.com>
Subject: Re: general protection fault in l2cap_sock_getsockopt
From:   syzbot <syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, eric.dumazet@gmail.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit eab2404ba798a8efda2a970f44071c3406d94e57
Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date:   Fri Feb 14 18:08:57 2020 +0000

    Bluetooth: Add BT_PHY socket option

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b08045e00000
start commit:   c25a951c Add linux-next specific files for 20200217
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14708045e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10708045e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c727d8fc485ff049
dashboard link: https://syzkaller.appspot.com/bug?extid=6446a589a5ca34dd6e8b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10465579e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dabb11e00000

Reported-by: syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com
Fixes: eab2404ba798 ("Bluetooth: Add BT_PHY socket option")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
