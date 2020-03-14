Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE518582E
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgCOB5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:57:22 -0400
Received: from mail-qk1-f197.google.com ([209.85.222.197]:34778 "EHLO
        mail-qk1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCOB5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:57:22 -0400
Received: by mail-qk1-f197.google.com with SMTP id x126so13346405qka.1
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 18:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lcIB99Oc70nccWilUatyGo7bA1aJbKIH0bAnGGmG+HI=;
        b=RkMhxGOxoySBL7t3rsDk4pRCLjQWZbmLZV7hSu+rFX9vkCmRLhTwBWoVUGeVPM5tXo
         MqRJOsxmsPhLsv7SEG5LbGUv4YeaGs1M2Ky7yto08Vq6spxALAM1WdeA79+0fgynJ2P9
         McTv1Y02dQ5e2p+z0Vl/RZrcA+g6RImbBO7AX9IcrL09pTxaIIkxS+xAryaxa+Jgj+u+
         Ef7L4CA5ipl42xQucmt1HPeDWGpuZTpEfjZM5g+TjnGAjfkunklj07IaJEahPoq/kJOf
         qMcvJ4SziwqgafbxedoxOAK2+1gER5QZ7XBWDfazrTmAYCTbF+gmxwznYVIN3Tj0qoar
         /a4A==
X-Gm-Message-State: ANhLgQ1Xt/YTfRggO76uoCVzpptNXLs1PFi9UmOabG62LuwrTkz4gv2r
        xGJiZ4HXlHWEcAflSX58v5Akt3cq5x4t1RFvxHT5VtiKfIbK
X-Google-Smtp-Source: ADFU+vtPYT6ImrSmn+n/oX5k44+StXAe5BTdqdlYQ14Q6+IFjM7O2EKZuGalsm3dcqRYn0+Y71MHqpN4yJlLeeGrUHswwpKYHgR0
MIME-Version: 1.0
X-Received: by 2002:a02:cacc:: with SMTP id f12mr13752376jap.99.1584228542130;
 Sat, 14 Mar 2020 16:29:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 16:29:02 -0700
In-Reply-To: <0000000000001ba488059c65d352@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f2c5b05a0d8f312@google.com>
Subject: Re: BUG: corrupted list in __nf_tables_abort
From:   syzbot <syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        johan.hedberg@gmail.com, kadlec@netfilter.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, max.chou@realtek.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 34682110abc50ffea7e002b0c2fd7ea9e0000ccc
Author: Max Chou <max.chou@realtek.com>
Date:   Wed Nov 27 03:01:07 2019 +0000

    Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113e9919e00000
start commit:   d5d359b0 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168a1611e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162f0376e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
