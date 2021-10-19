Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19B3433385
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhJSKdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:33:19 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42872 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhJSKdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:33:18 -0400
Received: by mail-io1-f70.google.com with SMTP id j7-20020a0566022cc700b005d65f61a95fso12980378iow.9
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hXd5vu2HVp+c/936Z+UfrXr6vwZDrrnzOmy4lULgqWc=;
        b=Fjwy9MSpUuS9H90aZehxViRYW7VUG0pIWfYqwq5i0Li7XbLGrb12SDKesV4hP4m58t
         OBnul38+34RIHkywBX8ybN7WpN1wHxtCZswAKVgJ/abdR/M6ahLq3jTHnRKFX6/ITsr0
         X4oCgsm03ac/+q8yrthLYZzvHvgsQ8KPeqjgWOPPep2VbKd2d5kZbnWb4LmibgXd4civ
         z+i+4aBQ5YQjb6oDaVbYQsu6h1b6mN5Oy7JmxV8MgkJKAOCs00vnWxvcuUTe6z0PcbHY
         oVuFITcq5B1OKWFd4IddYkmgDpDVXSi6VDDSS6lEKNXqhy8xofX+Uka5+TOUgCApoa12
         qRhg==
X-Gm-Message-State: AOAM5310+pZgpkfcqIFkAXyLWLhn+KABbh52lrf6gYzrU4c3oNiS32W3
        MsHKbJE4VvcY3qkIPx3jYWcLIfSDa5E+W9zyF3t/8o0llfVT
X-Google-Smtp-Source: ABdhPJyFNinPrD+dC0GJvpY6bw/xoDh7KcP4ullLmIObAIatN5O9PX8AXOag91eqZ/lVKAJcOTn1fWXsLcc8pv2b121jymSzmI1v
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1583:: with SMTP id m3mr17715899ilu.304.1634639466240;
 Tue, 19 Oct 2021 03:31:06 -0700 (PDT)
Date:   Tue, 19 Oct 2021 03:31:06 -0700
In-Reply-To: <28d9989c-4a80-daf7-d0e0-ae8e56b6e4d9@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b89ea805ceb228dd@google.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
From:   syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com

Tested on:

commit:         c03fb16b Merge 5.15-rc6 into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=c27d285bdb7457e2
dashboard link: https://syzkaller.appspot.com/bug?extid=a6ec4dd9d38cb9261a77
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10d634e8b00000

Note: testing is done by a robot and is best-effort only.
