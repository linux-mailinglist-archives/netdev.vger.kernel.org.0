Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A1B485330
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiAENFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:05:09 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52164 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiAENFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:05:07 -0500
Received: by mail-il1-f197.google.com with SMTP id y2-20020a056e020f4200b002b4313fb71aso21411653ilj.18
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 05:05:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HSRdWTMwZ0NVGbhn82fv0ZdfTEVZeKB9Mpbh30gZMkU=;
        b=MH5TRDbLm1d5dSbxV1s4bx8M/VCkh4bqi5PFqpMmOePctWqPrVDbqsBbzkjxadQLpT
         peHsvhprWBrxTeQkb7c9UjNK43qu35Aijn8aaI1VAKHTwBxv7ZTUzOyqo0Wdz9sYJ1hy
         BwiUy9wHbJdLW0LsUBpv/MWHe16MrRdZkw71jqdh1vWeS075Egggd0S9fpHkNU0DTI0/
         +yuC3EvGBaqIdlqPgaSKeKzMCmfeOtyAkOjqGUeSoKffX9KdXNlNgI+c43JPUesPRVk4
         LexhIGXkswcZRgB94FKAY+U7uzOz2WYjBA+PPee3kDcA8HY1ZlsZphqtCFk2bN8nQnL+
         liVQ==
X-Gm-Message-State: AOAM532g1ZqUGb4UB1XvnYOUQGjEc2ur2a/Hs5QpLmnYLQog62ZqWx/M
        BKztEbLmQ+yoKS0IJOUhP8t8Xjns/7QYK26oqipk76weAAEM
X-Google-Smtp-Source: ABdhPJy5x96xjIKmmkdWPCYacNAFMeYNDaWDDSM8GrSzjPCLFjWw7wZ0/pJUL3qkYuuidqhU5Y+GAzF7q6+5X9nh6352KMTjpd7z
MIME-Version: 1.0
X-Received: by 2002:a02:cf82:: with SMTP id w2mr24004765jar.314.1641387906942;
 Wed, 05 Jan 2022 05:05:06 -0800 (PST)
Date:   Wed, 05 Jan 2022 05:05:06 -0800
In-Reply-To: <66341bb1-a479-cdc8-0928-3c882ac77712@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000021c8c305d4d56799@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in ax88178_reset
From:   syzbot <syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com

Tested on:

commit:         81c325bb kmsan: hooks: do not check memory in kmsan_in..
git tree:       https://github.com/google/kmsan.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
dashboard link: https://syzkaller.appspot.com/bug?extid=6ca9f7867b77c2d316ac
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10d0da73b00000

Note: testing is done by a robot and is best-effort only.
