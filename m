Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20A32D547
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhCDOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:30:13 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49536 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhCDO3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:29:47 -0500
Received: by mail-il1-f199.google.com with SMTP id q3so20639130ilv.16
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 06:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+kcrwDzNNHcCwSp7vaCGNHpSpPV6e8DUvjBhwiEP8pU=;
        b=dDrZQ2G5nkWan0eWLRIjpqTxurx+g4RQZ0/D0yJi0Jxd8kW4P4hdHp3GrwcV9vkDMo
         d2k16h55kYayxw07ar5PQA9b4gIuhNstTK0MKihcWbPOwVYk4BqNG+329XSEg2c/jNe2
         tTI3pYVo/PAO+ymf+H/de1/mC06FiNTOBHSkF5kwvMPu4GuFqoSwKSIE/YvQOWradgvN
         p6pIATTCqVAWMWmsXM1kYCOj+4Ktz1DpAsMlYPHVGxnNavIUmOIyPKbgUCdj41DuansS
         vv+puk5Kba7un2SZqO4wNJKsspNXKKLAIw239sp1bQrWmwAcx6DBCwjV083IY7jSnAKW
         hK3A==
X-Gm-Message-State: AOAM530p+UD2xbhQ8eGqRCmywv8Sk1jjwChH2QrlvHoeCGiALCwGAlI2
        he3zipNQBfWQksZba7d85893OyXmgZLu6fD3T7RUAzXajX7G
X-Google-Smtp-Source: ABdhPJzJnSKr1pWXAFbJrRBB8V9CltBDMNX/c17YuUTYDXIwLV1cTTAvSc+KIpn15cTGHwMS5UEGEbdw2dURRxZ9663vlJyC/w8d
MIME-Version: 1.0
X-Received: by 2002:a5d:818b:: with SMTP id u11mr3615979ion.59.1614868146643;
 Thu, 04 Mar 2021 06:29:06 -0800 (PST)
Date:   Thu, 04 Mar 2021 06:29:06 -0800
In-Reply-To: <0000000000004dbaa505a5a165f7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003d692a05bcb6ca26@google.com>
Subject: Re: WARNING in carl9170_usb_submit_cmd_urb/usb_submit_urb
From:   syzbot <syzbot+9468df99cb63a4a4c4e1@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, brookebasile@gmail.com,
        chunkeey@googlemail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, ingrassia@epigenesys.com, jack@suse.cz,
        kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 6a66a7ded12baa6ebbb2e3e82f8cb91382814839
Author: zhangyi (F) <yi.zhang@huawei.com>
Date:   Thu Feb 13 06:38:20 2020 +0000

    jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14bd498ed00000
start commit:   f69d02e3 Merge tag 'misc-5.12-2021-03-02' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16bd498ed00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12bd498ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0da2d01cc636e2c
dashboard link: https://syzkaller.appspot.com/bug?extid=9468df99cb63a4a4c4e1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11770346d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17be69ccd00000

Reported-by: syzbot+9468df99cb63a4a4c4e1@syzkaller.appspotmail.com
Fixes: 6a66a7ded12b ("jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
