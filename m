Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C178F342BB8
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCTLMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCTLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:12:10 -0400
Received: from mail-il1-x145.google.com (mail-il1-x145.google.com [IPv6:2607:f8b0:4864:20::145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2367C061793
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:35:10 -0700 (PDT)
Received: by mail-il1-x145.google.com with SMTP id r16so26721679ilj.9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TY6eWPej2xyMujUIiW14t6MNCP0JG96Bsng7hloAJn4=;
        b=HcbHtU0lQnGCxyvjrJXRMwFofG3M9+hCq7tMDPTYvqCJ6Ap51/AAmjg9uBhouGxzdF
         /6Qb2IvXykERfPsdN54aGPRB5nrC7WEhS9if58rom/R2WsAWBD+tLCT6q6IXhZ9QQUdZ
         kkjFCpyL1GNb63ruVRHNG+K4Ty1VQQjGGEQ84P/NFkJGkoH7v53A8CKttqCxeynshxo2
         EeA/FKBT+LX/YqoTXQ7t23fH11OEXykL24t6NhcjXLKD2P/6rq7ev6GGkOZpmcCN8TVg
         i0QTx04jZd4illLs7/Mbzk0lU/TU9nEt/wzCKp7KcfhGl0cM2pOeH/b8BK/1ZB0oVwz1
         Icqg==
X-Gm-Message-State: AOAM533U3MB0KGQ412GSofvsMA7NH2FX8v8k9THdnDX6syKdIiK8ApEf
        G7RfMkKOWEkFBskfbV04uC5Zov0M2PnIszd489B/eITcP0TH
X-Google-Smtp-Source: ABdhPJzd4Hj0631V/HLa6Uj7/62+FcuBi7Qtrnplas/d5g38qhibrBz0f8jwbnFRIVPYlFVkOb2/5wjN/P0+HfQ/VrrH9dXKJCjr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2184:: with SMTP id j4mr5426084ila.308.1616228824055;
 Sat, 20 Mar 2021 01:27:04 -0700 (PDT)
Date:   Sat, 20 Mar 2021 01:27:04 -0700
In-Reply-To: <00000000000076ecf305b9f8efb1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef073a05bdf398e0@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in add_adv_patterns_monitor
From:   syzbot <syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com>
To:     apusaka@chromium.org, dan.carpenter@oracle.com,
        davem@davemloft.net, finanzas1@logisticaenlinea.net,
        hdanton@sina.com, howardchung@google.com, johan.hedberg@gmail.com,
        johan.hedberg@intel.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, mcchou@chromium.org,
        mmandlik@chromium.org, netdev@vger.kernel.org, sashal@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b4a221ea8a1f890b50838ef389d016c7ff280abc
Author: Archie Pusaka <apusaka@chromium.org>
Date:   Fri Jan 22 08:36:11 2021 +0000

    Bluetooth: advmon offload MSFT add rssi support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ef5ad6d00000
start commit:   b491e6a7 net: lapb: Add locking to the lapb module
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
dashboard link: https://syzkaller.appspot.com/bug?extid=3ed6361bf59830ca9138
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10628ae8d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12964b80d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: advmon offload MSFT add rssi support

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
