Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345D918F056
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCWHhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:37:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:56766 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCWHhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:37:05 -0400
Received: by mail-io1-f70.google.com with SMTP id d13so10847461ioo.23
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 00:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xI0usRcGed/whdLZrrsYIFzz4drUK13ORfQnfasIJ14=;
        b=kddFFqEyvmlQpfSvfgr2JqYNoYb/Z7tVEj/ARLSsL/5Q1d+tOcmXsCjQL1qgO87emm
         RHZa4ut5LtuIgzK0DHgm5gfyzGuosQGnGcLcTfkPqIPQcAL6dER9n7NCjKK37dkPVWg0
         xzkzAHuxpPCP5CBmQ+WKmvbL9mMUv7Paw30lI3M5DtO1WSJntJY66afsXkzCMfYUOt6B
         MNacQgkJbqAKFFsZOOcDurHmpbBfs0vysIWKt6PF1Xhgftztcub5Kqr7PnCmTE3xy/1e
         DsXXFiRvuguOc24qHZ7joj9Pwhtph9VEnm6agcSXHEJ9l9KWxTfPnYf4PehD/Xw+Bbab
         bdjQ==
X-Gm-Message-State: ANhLgQ0w6oLwUOjM8xLcsh2paCAGxkgVC9KPdG5H0JvcNdgpb+RRZEts
        my4G9zic2JeStRW/epDi0SV2jyPt+KxLDSk8Q/yiY1PMBDB3
X-Google-Smtp-Source: ADFU+vufWP1ZmfhWge9JYASUxfhkELaTlcETnEuwcsBoeOODucklUQVC3o7tld/u7Pwx7D1VAa9UfQDBlJdJnT2pfzm7+QwL09Wo
MIME-Version: 1.0
X-Received: by 2002:a6b:f60d:: with SMTP id n13mr17817597ioh.147.1584949022600;
 Mon, 23 Mar 2020 00:37:02 -0700 (PDT)
Date:   Mon, 23 Mar 2020 00:37:02 -0700
In-Reply-To: <000000000000e9e518059fd84189@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ab36905a180b328@google.com>
Subject: Re: KASAN: use-after-free Write in hci_sock_bind (2)
From:   syzbot <syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com>
To:     a@unstable.cc, andrew@lunn.ch, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, f.fainelli@gmail.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7d13eca09ed5e477f6ecfd97a35058762228b5e4
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Sat Aug 27 22:34:20 2016 +0000

    Documentation: networking: dsa: Remove platform device TODO

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1746f3f9e00000
start commit:   770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14c6f3f9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c6f3f9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=04e804c8c2224b6a9497
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fc5e75e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10707013e00000

Reported-by: syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com
Fixes: 7d13eca09ed5 ("Documentation: networking: dsa: Remove platform device TODO")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
