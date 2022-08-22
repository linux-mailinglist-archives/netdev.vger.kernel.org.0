Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB81359C3FE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiHVQXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbiHVQXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:23:16 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40941C7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:23:12 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id a21-20020a5d9815000000b006882e9be20aso5829755iol.17
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=WkKZ5NODq/Qymdy1tEZzofeSuiOIi9pswPpZMiFn/38=;
        b=TIceS1EMmcIhu2s2lBAxy+BoduVEoc8jfLIOdmsei0pCSQ6MpOVWxFvOredIV0nxxs
         d9uGu1kR8heQUF2Q5NfcvtfzjCT4015VXXMFVxDwfSb7LRlILugY78p01yGnIxh/m8EK
         xB+dy5tIqOK6cRvEcnT9CpoLGzNLpL/sF3WKKeyA7kRamlDjk1hGEdvG4dv6jfBVVJgQ
         Ie+6lis8dwvyeFKA7x6oDvd1zMIHPNysAANAaC9MzChdZl/+JEUm074X3lf/nNR3xySx
         XE3Dv+F84m/5n3utNV6xNEC1sqGwx8JVIgBmoldxock7iT/KNQC+iDtR71dlhKzaIudH
         PzDQ==
X-Gm-Message-State: ACgBeo3yX/oxlUMGPuvZedBswGK1rgmdi641QCAnRBbIvnhA/HlgZpdw
        FT9iclBaNaYk4OFfgGiOXLivGZUpCGsyBLGJFs2lCWwoKbv6
X-Google-Smtp-Source: AA6agR5hxkMoScoyFrXGJPc8cBZJhzujPur3+AOv0D6Bw2fqc99JQx50+BG7985kdQ+w40VR8ouNdtDdOoO+toD4LvEG5FZ+G7Nx
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c26:b0:2e9:9acc:911 with SMTP id
 m6-20020a056e021c2600b002e99acc0911mr4028748ilh.131.1661185392232; Mon, 22
 Aug 2022 09:23:12 -0700 (PDT)
Date:   Mon, 22 Aug 2022 09:23:12 -0700
In-Reply-To: <1959174.1661183147@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035d93c05e6d6dd39@google.com>
Subject: Re: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
From:   syzbot <syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com

Tested on:

commit:         f1e941db nfc: pn533: Fix use-after-free bugs caused by..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1550e4f3080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=930fc801ca92783a
dashboard link: https://syzkaller.appspot.com/bug?extid=7f0483225d0c94cb3441
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1518592d080000

Note: testing is done by a robot and is best-effort only.
