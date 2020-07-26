Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F9F22DDD7
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 11:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgGZJ5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 05:57:07 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50643 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgGZJ5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 05:57:06 -0400
Received: by mail-il1-f199.google.com with SMTP id l17so9246596ilj.17
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 02:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M+lItSmzANKwPOA/FLnsRuuzLx9O8sKK2O7ztiuewsw=;
        b=TqSE0eAqvf5MvSHEldvWcE+5uA1rPUcmhHPIgYzIUjf/oXkkzcc7lmPURLvxqshV9h
         OrYF8Y4m6ATVjB7X9hqQeLdhWsZqNd5KD6jGLaw0EtnNNsheIYDLO2wtV2o9uGtCprOS
         Z1hiZ571qxMNgipQlLmlWKUfZ3Np8sFZgCo3R4l/mhznPuMjaGElWcx7WbCusuqC8Dpw
         RXXZj/nfbrIYhb46o810QVlfPi/VEHy7f59k5t3GwaBtWSq8U4Z8XTGtbP6BDMv24CU9
         o1k5CDGmK1vNKWoLfxthklQvZEeoRNOkw+99/n/MeJsN182SND74ti6ytkATLfiwuIGd
         PE+A==
X-Gm-Message-State: AOAM5332RmQxOzliJiooUReSRNGoEmeg+6Qa3uI9GtMAWODscE+ki+6c
        je+OG87G3rX//01IJRJQSIS1wdKhe39ENmmDNz4+ICixHOG4
X-Google-Smtp-Source: ABdhPJzTKAuBrLOcNZShjjC5K+KAmmPmtsbgfXbsIB9MoOqOOoq6/meN+p4dsSnL857g+Eev4GfZNXcqIkmPJyR9BymjGF4MALae
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1495:: with SMTP id j21mr20749916jak.136.1595757425808;
 Sun, 26 Jul 2020 02:57:05 -0700 (PDT)
Date:   Sun, 26 Jul 2020 02:57:05 -0700
In-Reply-To: <000000000000a376c105a8313901@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083581705ab553aab@google.com>
Subject: Re: KASAN: use-after-free Read in __smsc95xx_mdio_read
From:   syzbot <syzbot+a7ebdb01bb2cc165cab6@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, dingxiang@cmss.chinamobile.com,
        hdanton@sina.com, kuba@kernel.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 7e23ab72e73bc601b4cf2983382691d9f165c8d1
Author: Ding Xiang <dingxiang@cmss.chinamobile.com>
Date:   Mon Mar 30 07:56:26 2020 +0000

    pinctrl: nomadik:remove unneeded variable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13cfe3a0900000
start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=a7ebdb01bb2cc165cab6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17046c66100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a8a3e100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: pinctrl: nomadik:remove unneeded variable

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
