Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF46F2800
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 10:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjD3IAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 04:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjD3IAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 04:00:44 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8022272C
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 01:00:42 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32f240747cdso126660915ab.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 01:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682841642; x=1685433642;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a1IDexcHuombdCZ4bVG8CXLltliWPzqUXk6Z55Zt+1g=;
        b=ArLmIdG3KYeXko/n5YPD1LSkzdcHS0h2JGdq4H/HYeQUnRCzB9WfLywfe1+rRpKJYz
         Fpd5ILMSQ8bp1YD9cu6sTc2t2gv2Cve7eBtPkRC5NesBJeR4mWAqNrO0nz7YcwsFU8PE
         ZKtyJ+5HYU1yt6Cp7PElV2drJGaMiEBcpkpZNn+v4Nv/vGst91nLBNVzttaw57y3Iycl
         NP3N2TIJbqleXO/z9p+92jrBZhHRFdYOFckKy2Y6eoSH93JTELCorqKBXX6DW5gGwKu1
         Z31pX1QlJ60AU3kwR/9y+37iqeNKB63oV/CagDdk7NZvpu8BsoSK0qGoCPPmdKKySj/7
         zbmA==
X-Gm-Message-State: AC+VfDx8+NMLLap7WBvO929kagfiGJmp9h6Xh8gURlp2wAB/2ZyWQY7c
        85mEsbd7g3peRmVftrwHZl7wpgcWK5p9l0nkHqhVuDxG+PlJ
X-Google-Smtp-Source: ACHHUZ4/XGK5QEZGjatsgLOMA57M9b9WoU+Oaty0ka3edIlYCmGpUkKZ6daOcAJZQHXqDzyXqsUU33DW7FKUNIY+3QmsnOAE6cmb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d96:b0:32c:b2b4:3bc2 with SMTP id
 h22-20020a056e021d9600b0032cb2b43bc2mr9966869ila.1.1682841642120; Sun, 30 Apr
 2023 01:00:42 -0700 (PDT)
Date:   Sun, 30 Apr 2023 01:00:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004abe4905fa891a51@google.com>
Subject: [syzbot] Monthly bluetooth report (Apr 2023)
From:   syzbot <syzbot+list71ad3118d9e6461faaf3@syzkaller.appspotmail.com>
To:     johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello bluetooth maintainers/developers,

This is a 31-day syzbot report for the bluetooth subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bluetooth

During the period, 2 new issues were detected and 1 were fixed.
In total, 24 issues are still open and 50 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  6076    Yes   possible deadlock in rfcomm_sk_state_change
                   https://syzkaller.appspot.com/bug?extid=d7ce59b06b3eb14fd218
<2>  3047    Yes   WARNING in hci_conn_timeout
                   https://syzkaller.appspot.com/bug?extid=2446dd3cb07277388db6
<3>  1047    Yes   INFO: task can't die in __lock_sock
                   https://syzkaller.appspot.com/bug?extid=7d51f807c81b190a127d
<4>  662     No    KASAN: slab-use-after-free Read in hci_conn_hash_flush
                   https://syzkaller.appspot.com/bug?extid=8bb72f86fc823817bc5d
<5>  331     Yes   possible deadlock in rfcomm_dlc_exists
                   https://syzkaller.appspot.com/bug?extid=b69a625d06e8ece26415
<6>  82      No    possible deadlock in hci_unregister_dev
                   https://syzkaller.appspot.com/bug?extid=c933391d8e4089f1f53e
<7>  66      Yes   WARNING in call_timer_fn
                   https://syzkaller.appspot.com/bug?extid=6fb78d577e89e69602f9
<8>  47      No    possible deadlock in discov_off
                   https://syzkaller.appspot.com/bug?extid=f047480b1e906b46a3f4
<9>  29      Yes   WARNING: ODEBUG bug in put_device
                   https://syzkaller.appspot.com/bug?extid=a9290936c6e87b3dc3c2
<10> 27      Yes   WARNING: bad unlock balance in l2cap_disconnect_rsp
                   https://syzkaller.appspot.com/bug?extid=180f35f8e76c7af067d2

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
