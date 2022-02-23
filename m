Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2574C0F57
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiBWJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiBWJkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:40:37 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8351D5B8BD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:40:09 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id 24-20020a5d9c18000000b0064075f4edbdso10468659ioe.19
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Cescbg8/jp8FsTcSy9R5A0Hc7x8UbA/1yigZrf68OGw=;
        b=7Z9WNRiO1lNpJa0rfDW0gqlmle0d9N3UjJ4j9dhuCDK39s01XLJLgyv7BmXhGoB8Qq
         zPaczEFtuMyx8FC/4SiszkT0g8vafMjh2niGIFIyZz1L4bCyQlb/CmKzSv/ILOEeTA0B
         YFX7xUm36mcisShn+BXxsBC8A4JRFeETd1hQQ4lYVVpGwZNh6+7XsvddFqdGUkUOKnpJ
         YCPqiduTCEJ9aO+4RJzPHSMubcFTE6n7XghsCZ4MJ04d1KL9u9ut2HMQG5GQ/2ZGFmyB
         six9FSsMhEBtVBWxd1j/wnp4T1sMiJeXTCUdLyS4uGLKv55CruM4N3bccru770UWHwVr
         3qCQ==
X-Gm-Message-State: AOAM533r49pnkDkHQBBKCnMq8TU60Fw9jEsxrQoH9HsC77ACk0MD3KGh
        1ululAudHfm8ZLjCTJTqyTCuQHdO1D6A4aLcRchbWp5jW9D9
X-Google-Smtp-Source: ABdhPJzNbY0WJ1ddy/IzgNSh3jXyZ7Tb7yBJOPo/bGSEnkHyfjUQwv2ab67suz0C4/jMzrEg1C0jVflIRnlF51oxJbldySM7u0PI
MIME-Version: 1.0
X-Received: by 2002:a05:6602:185a:b0:641:56ac:32ee with SMTP id
 d26-20020a056602185a00b0064156ac32eemr6965344ioi.17.1645609208948; Wed, 23
 Feb 2022 01:40:08 -0800 (PST)
Date:   Wed, 23 Feb 2022 01:40:08 -0800
In-Reply-To: <2174944.iZASKD2KPV@leap>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056adde05d8ac400f@google.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
From:   syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
To:     fmdefrancesco@gmail.com, jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tonylu@linux.alibaba.com
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

Reported-and-tested-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com

Tested on:

commit:         5c1ee569 Merge branch 'for-5.17-fixes' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=15187fc11a461d83
dashboard link: https://syzkaller.appspot.com/bug?extid=4f322a6d84e991c38775
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15bc3696700000

Note: testing is done by a robot and is best-effort only.
