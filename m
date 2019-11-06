Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14553F102F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 08:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfKFH1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 02:27:02 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:42978 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbfKFH1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 02:27:02 -0500
Received: by mail-io1-f70.google.com with SMTP id w1so17510960ioj.9
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 23:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NYZBN2qq6yyZ8/rwJcWC5cQMVkLTLOTvsfT7QODO4L4=;
        b=ggzH4c+6eGP+auEHf94LRAZu1JUzUJ0ZB9KarHPlevqu9d1b3lGVSs39hMjT/+Yv1q
         uRBCQpQuxHzecr4fovUXNWowx1wK+w+uIKMk2hAZ68xBHuNfFjHZo3HibchiQ8HI1l+F
         A0H0FftBsv1fcaY5GQCJfB23Z82iO2DDECkpEwyN+/t4pg/svHK2vZQnSwe1v/hvRBjv
         rssRAF1i+Khw23s/cVhLMPS1Yd9UqYdtGpDjaDrkLa6fKuyWo16UUeiHN6ovPaAy1tYS
         Xl9buJodmI9A6p/0brwFrACZ4aqtK0lagZ5Udt2WkvGWAhJvFno+I+PwnyJC711IP2U+
         TBTA==
X-Gm-Message-State: APjAAAWD0sdYNKl50pG/QNXpvzKea+3Mat8aJGS6tFsAgQ5bDowgLSEd
        8XwBoZLio9C27aWYpwp59dtgL/SRYYvhYqfftJzSZbwKzSSu
X-Google-Smtp-Source: APXvYqyd5FMJZ30orhu9VqKFCYkocrvkw/KRPvt/6hEEuXDUTOVp4lK7oLQ6TTlI9LlVVvYppYwsRyiSWDBpBRBhmASMZ1QlV/mc
MIME-Version: 1.0
X-Received: by 2002:a92:1b1c:: with SMTP id b28mr1150609ilb.278.1573025221369;
 Tue, 05 Nov 2019 23:27:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 23:27:01 -0800
In-Reply-To: <00000000000047580205969ee89b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008aea290596a8795e@google.com>
Subject: Re: general protection fault in j1939_sk_sendmsg
From:   syzbot <syzbot+7044ea77452b6f92b4fd@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 9d71dd0c70099914fcd063135da3c580865e924c
Author: The j1939 authors <linux-can@vger.kernel.org>
Date:   Mon Oct 8 09:48:36 2018 +0000

     can: add support of SAE J1939 protocol

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15874852e00000
start commit:   a99d8080 Linux 5.4-rc6
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17874852e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13874852e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=7044ea77452b6f92b4fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a99e8ae00000

Reported-by: syzbot+7044ea77452b6f92b4fd@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
