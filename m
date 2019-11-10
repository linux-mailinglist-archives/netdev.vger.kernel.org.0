Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C152CF6BD1
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 23:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKJWzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 17:55:01 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:34682 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKJWzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 17:55:01 -0500
Received: by mail-il1-f199.google.com with SMTP id m12so12021167ilq.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 14:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/Pa8UKCMA8SPihRiDsHarMOuNUw5vqsXgCzbPaMPce4=;
        b=ZNbrfLDWxt1mkUBYR1OykxAK8WOQ9jF77muBa6NCo/XakF0/H7BCbRqOYiyxhS2UZw
         +7EhNSxCAJPVzYQLOELQhNL5T63XeMr/say9PbXeVdfWYbLgJ7a1VZFjmvP13CdzaERF
         UDEDg9/Gt8aORy8dlNUjiUEml2EnUlXcd38ydHgppgkwQFRO6nYLl8w7rDgTDrtKJhja
         hFn5Kn5TEhqCdlK+x2Tckj+4b5jmsyR5vCp+QQoxS8HB4teGOTkH/94sbt0R8t/Z6m3T
         Ebm24DC2mMJGpPKf6YaoCHYT2CstKo8aVQ0kKFyZUFINS0Pmnnp+uHSowpg3rbAsDTZA
         D5Og==
X-Gm-Message-State: APjAAAWW/qhWv6NY9t2JwIM6r5n2Ano+OtyDVNjPOTa9AXUzgzAcGE3x
        NXQdjpoRr/CHMzOj7kW/3sf/zcZgKIzgUhVrpPmnXleIVUfY
X-Google-Smtp-Source: APXvYqxWupxkjD8ceSh/6a3yrJv8V9rVgU5A/fgW9YnNAd6CimDELG1I6tO19zEfdiU5wFsMPZGE1ex5HT3ZsMNciuLWHpaXCXfE
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6b6:: with SMTP id d22mr23089821jad.60.1573426500631;
 Sun, 10 Nov 2019 14:55:00 -0800 (PST)
Date:   Sun, 10 Nov 2019 14:55:00 -0800
In-Reply-To: <000000000000a3cc890597025437@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a68113059705e7d4@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_sk_recv
From:   syzbot <syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f08e72e00000
start commit:   5591cf00 Add linux-next specific files for 20191108
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12f08e72e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14f08e72e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1036c6ef52866f9
dashboard link: https://syzkaller.appspot.com/bug?extid=07ca5bce8530070a5650
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165ad206e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cf9c3ce00000

Reported-by: syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
