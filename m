Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0362A646F34
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiLHMCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLHMCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:02:20 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC39E862D2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:02:19 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id z10-20020a921a4a000000b0030349fa9653so913702ill.7
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JjxQ34dJ3tskIxeH8twqyU5m7zs/JDWT/OvBnJNVkBs=;
        b=ceh9J69kkGr7kzJ978kmxBRsd8UG1w/lRsP8zcF4fUn4V1vjH7Kg6SfoCYueUFZZq6
         tqSSpT7NHBBXnSdQf6JbgQQBBTAHVIEImbhckxsw8P42XQGKGSVjoSmjP9sJ81V6HKt+
         4NNKayDSgYSC46/b+RKS21VNRPu/efsW0lVyWIDYd1bA+wzto3GDCZZNd+VPa8Wq1+9f
         tjg5NZIXN4iXJBZzh3BkoDVOiYanymktSVOWRRZ7DMGfhI0IZrN34h5zhQVWZT1IuVi2
         3QlN7IWWhaYCtcJ1MafWETKo9hnHuWpJcOyQzqp8MaL2M+stScm9FT0EL0/3W9T2MZ1Q
         dAng==
X-Gm-Message-State: ANoB5pk1Lbx93wEbjFI5uErDrBPpLJXhjplG1X39w62nx8pnxqexuVbl
        D+JOCBd6Y6QF5UFHLJngIlldf0EXfyAi5QmCsKvQqzmVPxb8
X-Google-Smtp-Source: AA0mqf67s/XQpJ2AqNhm4XZgalEZHGLLg2lCUbf0Sqoa5kCKwQ9T8+5LPwZV5H5IkKnRAeWTfc/Whj54TCBMv2tRuh1s+ZDQK05Q
MIME-Version: 1.0
X-Received: by 2002:a5e:a604:0:b0:6de:353:ab43 with SMTP id
 q4-20020a5ea604000000b006de0353ab43mr34638237ioi.40.1670500939298; Thu, 08
 Dec 2022 04:02:19 -0800 (PST)
Date:   Thu, 08 Dec 2022 04:02:19 -0800
In-Reply-To: <1728523.1670498408@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015816905ef4fcf16@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_lookup_local
From:   syzbot <syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com

Tested on:

commit:         d8b879c0 Merge branch 'net-ethernet-ti-am65-cpsw-fix-s..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14186857880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=3538a6a72efa8b059c38
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1257cd23880000

Note: testing is done by a robot and is best-effort only.
