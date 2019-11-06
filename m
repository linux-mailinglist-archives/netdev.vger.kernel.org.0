Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B356CF200A
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 21:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732501AbfKFUpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 15:45:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:47266 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfKFUpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 15:45:01 -0500
Received: by mail-il1-f200.google.com with SMTP id c19so22839815ilf.14
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 12:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CKhbFMY96UkeeYW1AdsC4faXW9TdZP8Wwxs32ZLveY8=;
        b=Plo1zEq6BgUyx5u/h3G/4dAjdBr/fCDaEAEyBWWXqksV3WeOwQWvwv+mrByIVhb8fc
         lGLqBM7fMuYorN2QFijmEfwr2jkENkvmoHhejn31o/n6yN/xUJ979/9yDFpnHw82WdMW
         MBaJZ2Ubm3H8mGSV04q1b9j72F4p/p0+vAIONMg+Jtv5SipBZwkk7UkI91kfQYOD+dJK
         x07kVdM+hHO2OggbobMRJxzaC2i/splg6FtOCRn1L9owQEDDXJ3WFJLMY98tdDAdRZyN
         RC0XamozbniTEYbP96vNCvNUA8k+Bv5eCxkymr9kdPr4/GIPIqizGffGubHYNHQC5ncI
         KwNg==
X-Gm-Message-State: APjAAAUnl9b94E2hzwTsKi6yakJ4ouA7GySufMGhNYYo6g185OuGrXjU
        ZSaq0Jw4hYSx1OPnhsZk8yg111EIRpNd7x0pUBzR/GXCHL+L
X-Google-Smtp-Source: APXvYqwl8xKQyAsVboee3xTmV8yURBuHXGkB2ppXEIOqV4SbB6Al/gxxM/2HT9zBlaqoXRoMypAC6mCYV+vxyagef7GIdokmiA+8
MIME-Version: 1.0
X-Received: by 2002:a05:6638:68f:: with SMTP id i15mr20761396jab.37.1573073100939;
 Wed, 06 Nov 2019 12:45:00 -0800 (PST)
Date:   Wed, 06 Nov 2019 12:45:00 -0800
In-Reply-To: <000000000000994f3c059691c676@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000632acf0596b39f6f@google.com>
Subject: Re: general protection fault in j1939_jsk_del
From:   syzbot <syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13341558e00000
start commit:   a99d8080 Linux 5.4-rc6
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10b41558e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17341558e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=6d04f6a1b31a0ae12ca9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450cc58e00000

Reported-by: syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
