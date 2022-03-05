Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D64CE50E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 14:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiCENtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 08:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 08:49:03 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592F4419B4
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 05:48:14 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id 24-20020a5d9c18000000b0064075f4edbdso7297240ioe.19
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 05:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pk5i+sOPNXGGBb0bRxTeZIscW27o2u6cpIxn3IP3DjI=;
        b=sPBv9pxcNHjCyN1+u4dwoWaRlTgj2Po4NvigyBJg4rbT4899D6Q42a5PbL7Zpnennp
         yyYqNCXW8XGlNwCIi+eqMGWfNZ4qidYGqVUxa8CqbXCQRHkd+WTVqzdZypH0Ec07T8sy
         bACi/2o+EI1acD0hSIIVCBxNmgy2cC2zvPobLQXLIYWQ/GP8Nxv37DfW9yx88Gwus88h
         BgvypVHQEZ6a4IDKunprAJVcLcKcIrBNAYQTh2X9N7m0YAgARYo8MFZX+uR49sJmfctd
         M3A5UlHEp3GpxCmVH+pRdK4J6YPpquVriNtJey1n/04rVU4/4mToXuXUxFdUZPk4fVqa
         6BCA==
X-Gm-Message-State: AOAM532v++6CQZYTbxph2AyAn5c6VKyFdVZRTsAE+1Z2R+a78byJKxYi
        91zimAyKkR+jIiNSS7qaL8kSAIk+KLFE+9eH1Rl9m3yLRXD0
X-Google-Smtp-Source: ABdhPJwFokXr7PNDlAhr5YTXrfGJwclIsk7jdhrcR6q7AYq7uZuP2/Pw/iovnLwCRfTkfZQLaa9C8ZvbWLcE2WMPYwPkuL1FiVXU
MIME-Version: 1.0
X-Received: by 2002:a5d:9301:0:b0:614:549c:4c40 with SMTP id
 l1-20020a5d9301000000b00614549c4c40mr3047461ion.50.1646488093616; Sat, 05 Mar
 2022 05:48:13 -0800 (PST)
Date:   Sat, 05 Mar 2022 05:48:13 -0800
In-Reply-To: <20220305133546.2971-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f2732b05d978e176@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in smc_fback_error_report
From:   syzbot <syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com>
To:     hdanton@sina.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com

Tested on:

commit:         07ebd38a Merge tag 'riscv-for-linus-5.17-rc7' of git:/..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
kernel config:  https://syzkaller.appspot.com/x/.config?x=542b2708133cc492
dashboard link: https://syzkaller.appspot.com/bug?extid=b425899ed22c6943e00b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=171228ee700000

Note: testing is done by a robot and is best-effort only.
