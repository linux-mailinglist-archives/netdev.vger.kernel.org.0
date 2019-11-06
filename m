Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AECF0C30
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbfKFCnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:43:04 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:45571 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730722AbfKFCnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:43:03 -0500
Received: by mail-il1-f200.google.com with SMTP id n84so20267210ila.12
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 18:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=uSWnjSO8aRmC6HOtbozEviyKgrIraDFwwf90scm40l0=;
        b=KByI6ZJRsf+3ymp7Z37Q00+YCDg5WD9mN9CiSvRXLOiibGoKmCxO8NiwC6B8/z+Ewh
         gYF9rUz7Dj2epyRJ5RNz8pvAemkR4fVPhpjaU592ho7itfrEYIYoo1p+fmYcuvt65Vfn
         VhRZRK/njRAwAH5BawkgEEggIHE5ZcZhRGoJ/pUnoS17lOzdXSV+0o0Bf2qyFsSQ/f06
         OJi9CmlQGpHpGiPIYoJv5gA+TSvP1p5HbIxcTbgEnbP04mkumB9UBazrtQkF2Izipd2K
         gJt5RGArSQnNE37FQwoJRYajWSU6umk1y0Qpbdno+/nkofWWH60HpGE+c2AXWW3psQzE
         grTg==
X-Gm-Message-State: APjAAAXIqXIfdtNIKLUwINmarFQwhd4grCQ/lzRKcf3Y46qhZdbNrGbz
        vDCFSY/PgxCJyCQSzGfeue4n0BRA4ieAOlOupk52QEAI1Kxe
X-Google-Smtp-Source: APXvYqxWaexPBXY5jrl37JvvcUZAaVp3KXSs+h0t1RYE4hSK4+O06OdivMpHLxC+8f80DUzb4Mq0EMSAeFKl27IKU5J4/7z8BlIP
MIME-Version: 1.0
X-Received: by 2002:a92:ce42:: with SMTP id a2mr235457ilr.69.1573008181583;
 Tue, 05 Nov 2019 18:43:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:43:01 -0800
In-Reply-To: <0000000000005ed7710596937e86@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e46daf0596a48179@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_xtp_rx_abort_one
From:   syzbot <syzbot+db4869ba599c0de9b13e@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1157fb1ae00000
start commit:   a99d8080 Linux 5.4-rc6
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1357fb1ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1557fb1ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=db4869ba599c0de9b13e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1435c078e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139a3542e00000

Reported-by: syzbot+db4869ba599c0de9b13e@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
