Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70267479EA3
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 02:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhLSBDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 20:03:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:43825 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhLSBDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 20:03:10 -0500
Received: by mail-io1-f69.google.com with SMTP id j13-20020a0566022ccd00b005e9684c80c6so4438755iow.10
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 17:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CI48j3ubhiTdfUyLSvTdm3aMA4INZMzb9ghIYvLpbqM=;
        b=i2bXJTDyh3h6LNBgU1QLOL4H2sQN1mAOJRer30A+sqF+tkizRRgBEtXgkZs6lpkYZA
         980jPTi6NyVSM1Kdp9UNAHWKu4EMQ1cj3tixFhr5914Y5zoxt68m1NBMi7U5pQc37qpB
         cEuvj6ezwhIrJ7Z6iluNO3THNVURaDcT1d503COnVx879LgZgpABLYzo6T915AYcE+XQ
         HABPTiYkgfMElnb6dINbJHJVRgwjGjtGXXVKRK1efyGd0qkWtWguQEs+QRGwp2a6aB9N
         xMzp3fHcNtZSPMzm033XKK0/XJaIByZizrqniT1S4N5/pR4negszUWxd/POEqWeyyFwh
         XILQ==
X-Gm-Message-State: AOAM532GJyEWPAAkc8+cADHH+FysNittH76FyacFzutVzrBCdn8Lfzlf
        niukqVdHdmrPPf5TJwWbrPMhiFC+xmBAQI4keGPywL6A2uMw
X-Google-Smtp-Source: ABdhPJyzClBydsueqtINlV1Pw/7cLJZN42JvPu3XVdTZ3uqKoF3ibacyZV2iu4orAFF+rRlqqX+NPfnRwy8brdkqy5vaoryv25Hw
MIME-Version: 1.0
X-Received: by 2002:a02:b707:: with SMTP id g7mr42266jam.86.1639875789559;
 Sat, 18 Dec 2021 17:03:09 -0800 (PST)
Date:   Sat, 18 Dec 2021 17:03:09 -0800
In-Reply-To: <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e99dbc05d3755514@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
From:   syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com

Tested on:

commit:         b0a8b505 kmsan: core: add dependency on DEBUG_KERNEL
git tree:       https://github.com/google/kmsan.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
dashboard link: https://syzkaller.appspot.com/bug?extid=f44badb06036334e867a
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=163c52a5b00000

Note: testing is done by a robot and is best-effort only.
