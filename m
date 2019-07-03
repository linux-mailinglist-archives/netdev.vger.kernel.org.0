Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A560D5EB89
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfGCS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:26:01 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46672 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCS0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:26:01 -0400
Received: by mail-io1-f72.google.com with SMTP id s83so3518749iod.13
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 11:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ol2oTL6I09LrbBugODTrPEcLgmAtDlXO+xFKA9FYWzI=;
        b=duOEOOfsj/BGA0NZBEWlXcmf/xLRe593lf6J9rfWRaWk0z3ppvm/Qe6KgN21uEb37P
         hldebpb/vcRZ51g2t0ZxKmjngjWyl2UI7m+oT7vSLza6ab+x+JInuCTAuv1KHRfeln/I
         Hgdmb82FhMrbq0IDGEi1gZmkYz6FRfmqid7sC5WV8VmHUzGO6CQqR+grJMxvu93xi54W
         ieEHz5In5C8Chheu9uAKPOEWpGHrPRHeTN2FTUbuyHPcutNo4rGDddcOhiWl940kkA4W
         b5Y0uVZZY0t+c5oSmppLxqAnaWhHxCCkNnI5HTNc29vV3CwFXnbJbYckFhSp3Wdn6cpe
         jLNw==
X-Gm-Message-State: APjAAAUGiLCTXoUFsDpnN1uo57/0c29YzVCN1hg6S0hlAdFDu7kfn+0C
        XmUhnEWZR/itgPKGtPcttTBTH5QazvHW+aDZPnl6OH0/ViM6
X-Google-Smtp-Source: APXvYqwnKz9Y5ErGzM/oENrZog1dO7eB2V3AocjmtCzYXUDUaLNQ1kAbKUGqE/0CNl8wQiJx3GqOLtHaUDhnnEPnEz2HNfDxKgvN
MIME-Version: 1.0
X-Received: by 2002:a02:c50a:: with SMTP id s10mr45090759jam.106.1562178360550;
 Wed, 03 Jul 2019 11:26:00 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:26:00 -0700
In-Reply-To: <00000000000035c756058848954a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041ac74058ccafe0d@google.com>
Subject: Re: KASAN: use-after-free Read in hci_cmd_timeout
From:   syzbot <syzbot+19a9f729f05272857487@syzkaller.appspotmail.com>
To:     chaitra.basappa@broadcom.com, davem@davemloft.net,
        jejb@linux.vnet.ibm.com, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, marcel@holtmann.org,
        martin.petersen@oracle.com, mpt-fusionlinux.pdl@broadcom.com,
        netdev@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ff92b9dd9268507e23fc10cc4341626cef50367c
Author: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Date:   Thu Oct 25 14:03:40 2018 +0000

     scsi: mpt3sas: Update MPI headers to support Aero controllers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130ac8dda00000
start commit:   eca94432 Bluetooth: Fix faulty expression for minimum encr..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=108ac8dda00000
console output: https://syzkaller.appspot.com/x/log.txt?x=170ac8dda00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=19a9f729f05272857487
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125b7999a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176deefba00000

Reported-by: syzbot+19a9f729f05272857487@syzkaller.appspotmail.com
Fixes: ff92b9dd9268 ("scsi: mpt3sas: Update MPI headers to support Aero  
controllers")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
