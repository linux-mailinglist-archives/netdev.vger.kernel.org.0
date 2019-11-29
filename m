Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D561910D4C3
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfK2L1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 06:27:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51687 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfK2L1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 06:27:01 -0500
Received: by mail-il1-f198.google.com with SMTP id x2so24419125ilk.18
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 03:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1R/eyR91b2qzrd9oYXwpA7kVnLlS3eW/CPo2xuZ2tZs=;
        b=ccxgzbGFvK4cOKKHDmPe8eDBhLSU3/OT8xnuIqf5nCsuCVSHBdatYKSgc9yfGVmSqm
         tskia/ZRCdwY6ZeTzO4VUCLiySY3DA367Kmblb/FlxMVr5bBo5HIsLz/WvWRClDVDCY9
         BWQxXvGmSbkJoyDnM+0dY5U52W9O0TLwAUDCZJJz26aIU5OjCBDXttDWPM6PBybeiHKB
         6Hju8xZG7wsWlaDbr2VYFWx7lOqQ+T0oGPZgYyLU4n4F2mzxwy+bUSV9sI62dHBCKVv9
         kTDDg4qzjHFA1fC0jcS8VQOQ0SeLV3od9CAi3w7lAtBcURA5EPO+W4BUkEODzvMcsQgh
         KxuA==
X-Gm-Message-State: APjAAAXi7XCh96Bw0ufzNvta0BxUo/02aBc06Mv7s+fF2nI/+cpalisQ
        npI1MTpfENXW6reSaS/m6YEjSFun2dCgyosbUa4947uItptH
X-Google-Smtp-Source: APXvYqx2WOuve6jGICcXm51Pk+hIsPcOb1OO3yj2Zia1Hs0+ZR99DkvW/INJgLvPm6G6NaW5WS+Y11Kyq0HaFv6HhYvElj2iUAAo
MIME-Version: 1.0
X-Received: by 2002:a92:c525:: with SMTP id m5mr52192194ili.91.1575026820788;
 Fri, 29 Nov 2019 03:27:00 -0800 (PST)
Date:   Fri, 29 Nov 2019 03:27:00 -0800
In-Reply-To: <20191129104156.GH29518@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002a380f05987a8239@google.com>
Subject: Re: WARNING: ODEBUG bug in rsi_probe
From:   syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        siva8118@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com

Tested on:

commit:         d34f9519 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=122808a6e00000

Note: testing is done by a robot and is best-effort only.
