Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122DA4BDC43
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378063AbiBUOhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:37:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350453AbiBUOha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:37:30 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461141FA42
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:37:07 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id y9-20020a927d09000000b002c24b428ff4so1088197ilc.18
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:37:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UXuZuAFf06AjNDv96AIjaTSOnvpwB56946KWBbv5zI8=;
        b=ShRncO+EjPxiB2O5toyMe2DuPPz2zdQ0y3R0/tWUylPR51syM6Q6FeE0KaunlUMgPt
         xxrYEQwSHZ9WpXgyNhUxiGwx9SrcAHfZwjvvVo7euhtWTOK8BMKzlLp6PKcSIlgr0vdg
         G2g5tHHfYn2uP3jvRgSEYYC+8cTqxmfcvX+bA7uJ9GgFgnqDMcQpAq1wb4vaWFtxqAR0
         Q1xYUuEHRqVxu5iQ8mTMKGEo4wK1L17hoH242EEa5Y5cZ1yeOnLKV4ijjtrFU5s89t0t
         6RUor2cp2fBfTWLOHcBawETJH8sJgvFdYNz/c8d3NUGvaiFiTWbRMCJCiQqVsuyN4o/4
         KyZg==
X-Gm-Message-State: AOAM533U/OzXljTfQtpRuByvtk9ssZd9H3K9NNdNtVwLHO2w8sHoBBg1
        +vvjwy000WWtsR40cOzBy7RCS3adAm8ePpqsXxk2W78b3lfI
X-Google-Smtp-Source: ABdhPJxI9n7981umWgxAkYi8nKTFYbbnjwZVOUXk22WmatR+LG0H0VtkRrDs5wSXcX4+ImWNsFu8NNEDe6+uhDX1c+HlQGRQyJSt
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d86:b0:2bd:ef9f:cfa6 with SMTP id
 h6-20020a056e021d8600b002bdef9fcfa6mr16231349ila.314.1645454226686; Mon, 21
 Feb 2022 06:37:06 -0800 (PST)
Date:   Mon, 21 Feb 2022 06:37:06 -0800
In-Reply-To: <CAGxU2F4nGWxG0wymrDZzd8Hwhm2=8syuEB3fLMd+t7bbN7qWrQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad0c4005d8882aa8@google.com>
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
From:   syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, sgarzare@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com

Tested on:

commit:         f71077a4 Merge tag 'mmc-v5.17-rc1-2' of git://git.kern..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
dashboard link: https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1502488e700000

Note: testing is done by a robot and is best-effort only.
