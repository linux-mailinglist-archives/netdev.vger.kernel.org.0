Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AF92296C2
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgGVK7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:59:08 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:41764 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgGVK7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:59:08 -0400
Received: by mail-il1-f199.google.com with SMTP id k6so788431ilg.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+MTYhbpSCITOUxjmPnhjda3q0hd+gL2rgezFk7qJWaU=;
        b=gGSg0hrQ/1loMt2lOnYAWFyjEPsMN4ubNk5BgKAUpcenn582HVk8v1zrDZs/Agcett
         +Pk35U04mu0VlbqDc2OExSI2emKTgA/IMT2X4xMBuVylJz9wC7tGgPbM3f7fQNI2WlB6
         0ZGdRJcN/CxmtIsV2JUL+7T6vkagrpRha3mHIB8mZgTA172l9iguyPzmHEdlqQyNNlNp
         WuBzrubomoQfw5/yRZ+escEGK2pA9rTmDy+0ANL3LOM/OFpfvr8SINVhbQ+GUHf+36/i
         VQwONdoDgc73NRfB4/KIN0rY323tVJY2OpMZ3+wzvN23mKL2Kfs7+0Pfhza13PRdYnFK
         5h1g==
X-Gm-Message-State: AOAM530X/8uh/auQMaf2ykPzlMT2no/44F8yp0kMi/fnGcBmkWLySZBt
        OUQN7cZEKhuuEAn5GH2ulpd98ZGFmhInOKRIazIRsPRRltP1
X-Google-Smtp-Source: ABdhPJyKtjS5xuKw6MuALvst1m+b7QzvnWngYNvV6LqBHReEEtIkwFNADfCr8JbKjNbF2Bke/lig7Wv1Cfl+GLPkBzoFx6WWGl4H
MIME-Version: 1.0
X-Received: by 2002:a92:d652:: with SMTP id x18mr31350270ilp.248.1595415547083;
 Wed, 22 Jul 2020 03:59:07 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:59:07 -0700
In-Reply-To: <000000000000cbef4a05a8ffc4ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f4040e05ab05a0dc@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible code in tipc_crypto_xmit
From:   syzbot <syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, jon.maloy@ericsson.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, tuong.t.lien@dektech.com.au,
        ying.xue@windreiver.com, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e1f32190cf7ddd55778b460e7d44af3f76529698
Author: Tuong Lien <tuong.t.lien@dektech.com.au>
Date:   Fri Nov 8 05:05:12 2019 +0000

    tipc: add support for AEAD key setting via netlink

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b738a0900000
start commit:   11ba4688 Linux 5.8-rc5
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13b738a0900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15b738a0900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e944500a36bc4d55
dashboard link: https://syzkaller.appspot.com/bug?extid=263f8c0d007dc09b2dda
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14000957100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d30d67100000

Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com
Fixes: e1f32190cf7d ("tipc: add support for AEAD key setting via netlink")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
