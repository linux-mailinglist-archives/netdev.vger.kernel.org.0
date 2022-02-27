Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65C4C59EC
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 08:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiB0Hxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 02:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiB0Hxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 02:53:49 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657844757A
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 23:53:13 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id o10-20020a92d4ca000000b002c27571073fso6700760ilm.10
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 23:53:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8x4prQR53xKdTVGUoxh3U1NM4w8xxnpghylkDWISnKI=;
        b=QODTG0rgNKvLPM0kX4ME6R9vpowL/VAzfFyVVx4mHW/46+3NmOnv3n9HBXYGILHWTC
         Uj0xyDEI0QgNgfiTtMBvLAKO9ZLZ7EBpAvSMVNcsWTfnQ0av2h3J+gKe+PLiDP9PEBWb
         RAqV7HdLp2GsA4CYxqTrf+G4ZQouhrrCM758PY1swh8srqtmi1t/kVzndJ3Kh8BMMYSt
         ho3KFdA4VVcWH60arZ8Di98CHIsXHVcVIvfyy2gyhctSQeGAMRw6TB2heZEDVY1MziCn
         W38dLDN54e17uLtoNvYB9Jl4VEVlurEu8wLXA4jqppkyY36aQ9AiMBW6NzDy9/bSyKey
         +Y4w==
X-Gm-Message-State: AOAM5302DqWrB/n5/N7D31nTHTnl4RWVwKalIoAjBJJ/QZLAsM4Vjswq
        TdQ89/rfJu+TMUtbXodkeJ8AAG15ueZbml8cKr35jg7t0dcy
X-Google-Smtp-Source: ABdhPJwnM//x289HcGWdyw6/MGcyPjreaVsnsQEtDClJ29ZCA4H62iYtHU111CI/dde+EtOVB0pSCgrO2DM1+90IGs0rgaCC8QmS
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3409:b0:641:a051:df23 with SMTP id
 n9-20020a056602340900b00641a051df23mr11607999ioz.98.1645948392694; Sat, 26
 Feb 2022 23:53:12 -0800 (PST)
Date:   Sat, 26 Feb 2022 23:53:12 -0800
In-Reply-To: <20220227074046.2963-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000043e8b805d8fb398c@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sco_sock_timeout
From:   syzbot <syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com>
To:     desmondcheongzx@gmail.com, hdanton@sina.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com

Tested on:

commit:         922ea87f ionic: use vmalloc include
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f802340579dda19
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=134f85da700000

Note: testing is done by a robot and is best-effort only.
