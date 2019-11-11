Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196CDF7860
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKKQHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:07:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:40885 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfKKQHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:07:02 -0500
Received: by mail-il1-f200.google.com with SMTP id x17so17254740ill.7
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 08:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gFl20HjZDqq+nPQeJUYSxv5Bfmo8ZIyMRQ74ccfUZsc=;
        b=QFToBtUkgjQC5kvNQ71gLcjCVFuziAzNJ6pOCbwpG0ZL9ZwJo6ubKECWBuvzUnfHbA
         yvDkIoIZ0a4Rgh5ZAC5cA1ok9DWz+R51Agn2GWoCOdcjgZSkjYiwDwEC6keoLxiBh/Iw
         zexY4ZAclK/raXM1IZCE/GQ8bQFys1LGJWv20h7EtiKz5JSoZLNfKv7crdwNTKRToUUt
         +2Xc2RZB4kKK55wDVW3x9QMfJtCKLLL14SKl4sdq7Y66l67GUfCmjEe0ev4jI/6mnZY6
         jK4yAZyzrKVwNA95/3BPxfvHW2/go/ZkG4ntyqM3SbIIWbswAF4LuCTR+120piqzrP4E
         W2Kg==
X-Gm-Message-State: APjAAAVF7LFLRnfvCB935I54I1u/F17DlLJAGTtQH+4/Q50tczF+a1wQ
        R9fV6kf8nWHe+HCIv6P/v5IMgATICkm5p3oEzY7Oanh/INJF
X-Google-Smtp-Source: APXvYqywxuAwIOiw8d0TKszs0yk4o9kaGMvUJ9K55SHH6Im/F08TWUOQQw1vBGPnwfBhSwGcTMIJv9gca9cNfCX3fkgdzA02Qkyu
MIME-Version: 1.0
X-Received: by 2002:a92:dd0f:: with SMTP id n15mr31057502ilm.146.1573488421314;
 Mon, 11 Nov 2019 08:07:01 -0800 (PST)
Date:   Mon, 11 Nov 2019 08:07:01 -0800
In-Reply-To: <000000000000aae1480596a5632b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000692ac105971452c5@google.com>
Subject: Re: WARNING: refcount bug in j1939_netdev_start
From:   syzbot <syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17100f3ae00000
start commit:   9805a683 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14900f3ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10900f3ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=afd421337a736d6c1ee6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d713c6e00000

Reported-by: syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
