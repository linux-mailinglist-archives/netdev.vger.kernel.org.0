Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CC104F26
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKUJ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:26:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49637 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUJ0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:26:02 -0500
Received: by mail-io1-f71.google.com with SMTP id w12so1744436ioa.16
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 01:26:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6ozcDbr2hFtQSnK/28jfucsXIR73JWIXzNBJp3f0sak=;
        b=JxuqXXYX3vA3fpha8MwFzWbBdUm/OVF68TpVUloRLqZuf2HFjQz6XGPUv10S1v/xYY
         dcEpRrC0RnwiaHDKhy+MYh9jTzmwGVJX4gF3UkuKJPy9HEpaRaUwf7ikTmzpVxpnwWEJ
         iJA0cN1IcksZc7tMBuZnpaJ9Fz/BgPeBT/2iCYeLlpPQpQO15/Vyh0gHmbjPDhvsKt7E
         sMXwcyOzSAlioOm+IlXbEGs5FhfDxQNO+Iiir7Wx868251gTnLwkZ0G50n5S9FNjNpAA
         2Qgk6us19+KUMTgIYvTxu9aIlO1z/Tpo+rLpmBG931bfcpEpvKpC/Q5UJOiQ5wZTpFQM
         Uk8A==
X-Gm-Message-State: APjAAAWZnrvlk4EyWuN99OfWX8Lt/giS5Qmt4YUd+YK6H8oX6UpDr6Iw
        Aqz0Oex67ex0SB/tOY25sYnTHMQvPpdS3eZw8H9jh3o+Xq1b
X-Google-Smtp-Source: APXvYqw8McZGbc2E/hPpvSV9U/mYJEuNQ3Tf7YiJBqO3ltBpa24uKOnf8sl9TjJv3OXD3dnvqSNkYTI9MC9u8nButoyEwUC6F1z+
MIME-Version: 1.0
X-Received: by 2002:a92:45ca:: with SMTP id z71mr9226460ilj.106.1574328361224;
 Thu, 21 Nov 2019 01:26:01 -0800 (PST)
Date:   Thu, 21 Nov 2019 01:26:01 -0800
In-Reply-To: <00000000000028f3c20597d2d8ee@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb10ec0597d7e2bb@google.com>
Subject: Re: WARNING in j1939_sk_queue_activate_next
From:   syzbot <syzbot+49595536c57ef38095ed@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152c6bace00000
start commit:   c74386d5 afs: Fix missing timeout reset
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=172c6bace00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132c6bace00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4737c15fc47048f2
dashboard link: https://syzkaller.appspot.com/bug?extid=49595536c57ef38095ed
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8ba86e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ce855ae00000

Reported-by: syzbot+49595536c57ef38095ed@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
