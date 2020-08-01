Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD6E234EDC
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgHAARH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:17:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35992 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgHAARH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:17:07 -0400
Received: by mail-il1-f197.google.com with SMTP id o191so20540872ila.3
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EeowjFs3ag00jmXysHEViINXb8Feznj0QWnCDc8JX9k=;
        b=OW+0Nl883hi4NSZiVPGuBOjFiZD+LolvgJZ2RmJ8tmgEqf2dzumdgN3JMI+DEXLzCS
         rsoYzfN9Tik3mzjNNahMdz3R7IKmlw9eud16Gm0IoaFiZqqtOUI3PW6s6vDT161XKLRL
         2PmHqCqJrFjioshAf5eeiPGbeR/YC1misbZUFYdkk2yXGRkc2qmvHK4AHSV7CIe3BjuV
         qAxDXyHwevRh3kWOHwjMFYNEZp22KHLMve/dWzOuT67a/Q1uGcUrei/k6rVE44+Xm7CT
         ryc7VW6f8/hq9dhleF/o+Z+3AFEgCrm8USaoYPBUJLElGgtUt7+BKdAc264famscF0m0
         kO4g==
X-Gm-Message-State: AOAM531jK+GIzdV8KJWe4ne7JJ+UAKR/k6+oCaV8yVLUcXHYUjKA5ZvH
        IQ1dbDGsIhp89C2J2AMufYuyVR7i3l4BZ/c456TpEToRovj7
X-Google-Smtp-Source: ABdhPJyUdXAO2hc9zkb+flLDdicREQ1MO5ek2xuunUaYgAh3EJco6GeHhbiRHe9n9Y2O1M10MBJzTxGwK5OnmfSGd22hGobEilwF
MIME-Version: 1.0
X-Received: by 2002:a5d:8a0c:: with SMTP id w12mr5949284iod.63.1596241026434;
 Fri, 31 Jul 2020 17:17:06 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:17:06 -0700
In-Reply-To: <000000000000f796a105abbfa33d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b507905abc5d32f@google.com>
Subject: Re: INFO: trying to register non-static key in skb_queue_purge
From:   syzbot <syzbot+99efc1c133eff186721a@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 65b27995a4ab8fc51b4adc6b4dcdca20f7a595bb
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Mon Aug 12 21:52:19 2019 +0000

    net: phy: let phy_speed_down/up support speeds >1Gbps

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1327ef50900000
start commit:   83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10a7ef50900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1727ef50900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=99efc1c133eff186721a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12429014900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12dbc404900000

Reported-by: syzbot+99efc1c133eff186721a@syzkaller.appspotmail.com
Fixes: 65b27995a4ab ("net: phy: let phy_speed_down/up support speeds >1Gbps")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
