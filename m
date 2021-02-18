Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E765731E37E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 01:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBRA1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 19:27:52 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34325 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBRA1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 19:27:46 -0500
Received: by mail-il1-f197.google.com with SMTP id c16so58987ile.1
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 16:27:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=O+x9o+ZqY3A+p1PVu4qZBSCbVWR7ynX8ZB8xdbSabKw=;
        b=PSFjLi8m2caN9CbMcYCHgC86gpBoJuHX9j/vKNABIhjxGNSZRZIvK4OepcIHGyO3ve
         6HvHnSMVdV7yA7kuVjJ7SiKvUHmaurebA5GI0fOayjAwfXlKmf8TlNGpHha/ag3GnYqK
         wLrOREEwBYcVLT6uzq+IGRcmV+IHSGiTR9lKOO9DASGtuDkVveZ/AJb0kL68yBk/StW5
         G4xMNt3qnmFFt4MOdUhV9lZoDkVmz5NDw6XFRqoa0VDSd9LQBCsJpisU5q312v3k6bHk
         nhwk+psmu2nT3W9AP5P+Y5cw7bTHOC1SDOC+rB0hWTGK/RIVki5nJ+yaXZi5Yel15DY2
         gJGA==
X-Gm-Message-State: AOAM5318qJhYXVaCq7GL2BlvcyiIY1+F8k7Jf8kuw6y+SNedfLRRZWfZ
        ZItdrnLCKMuHEBKuXILNAZfgajhmNszrv0qi4HEUEL78L4zv
X-Google-Smtp-Source: ABdhPJxO8r/5nk0DFl25ML2casoWzcuGZsMZXBITWPLwcONa2GWX24ufN0whZzxNEe7f+VsppvpgfMFh29PS8wEIOS3X0snRXScG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8ab:: with SMTP id a11mr1385794ilt.137.1613608025229;
 Wed, 17 Feb 2021 16:27:05 -0800 (PST)
Date:   Wed, 17 Feb 2021 16:27:05 -0800
In-Reply-To: <000000000000064f0f05bb76ff3b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000268f5d05bb91654a@google.com>
Subject: Re: WARNING in slave_kobj_release
From:   syzbot <syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, hdanton@sina.com,
        j.vosburgh@gmail.com, jamie@nuviainc.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=169ceb24d00000
start commit:   f40ddce8 Linux 5.11
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=159ceb24d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=119ceb24d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b919ebed7b4902
dashboard link: https://syzkaller.appspot.com/bug?extid=bfda097c12a00c8cae67
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111279f4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15861a4cd00000

Reported-by: syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
