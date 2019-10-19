Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1A4DD664
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 06:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfJSEAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 00:00:02 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:49161 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfJSEAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 00:00:02 -0400
Received: by mail-il1-f197.google.com with SMTP id v8so2788966ill.16
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 21:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=enssZdcGZr8zBgaRgbTlKFGqiCX/YdzbT8JMhjDRm00=;
        b=XwHJqMOZuS8s4TlGPUBQKc3mkae4QXmmxGneK/RthA48iByVa70yl5R/l5McTkjCO9
         2D4Bt8idhMiJjVM8at5LqXXCLeUTZXIIlJ4yoMLKLe3S1DndZp0h1Rkn/z/yhkpuuGd1
         wM5U3oBj9W6sOuvZjoaVMa3KC14Ja4wJ6G8GPgSuMnYXGY/CZPGwb11ItmkVbni6/v0Y
         OEgDth0kf5ubz9M7ksUK8/igXtUFvBKNfedP8ljg+11gqASDgHNIbuICpLBG77p6orQv
         yqzEWMMcqKvB1jvj7zihuKnA06BJixwqHrDkayrpt5OFcF3HmkF+mRX0g6r6YsXZfZc/
         ojvA==
X-Gm-Message-State: APjAAAWfJ9W22+aSq32l6S9A5x7JHc/MpESN3cJ0x3ROPQtA1hhCULFR
        e/rpLI14AufQaYuiplP+8jFn4SUkw/rJUPwkx2JXqtMbBLWu
X-Google-Smtp-Source: APXvYqz8lqgBFyZx30Xm89H2jN8QiEn0zBJRqpi9o4I5jqUpUIaAtrg8GgpM0+0dlymC4KEkM4dpnR6YmFV5vqWhd5Z8b7RZzrfp
MIME-Version: 1.0
X-Received: by 2002:a92:cb84:: with SMTP id z4mr14774857ilo.78.1571457601324;
 Fri, 18 Oct 2019 21:00:01 -0700 (PDT)
Date:   Fri, 18 Oct 2019 21:00:01 -0700
In-Reply-To: <CAKK_rcj55g8WPCLrrLdT+8zWLXXOMVf0jhMyYQj9jndy_+i8qw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001b4f0b05953b7c13@google.com>
Subject: Re: memory leak in copy_net_ns
From:   syzbot <syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com>
To:     a.p.zijlstra@chello.nl, acme@redhat.com, andi@firstfloor.org,
        davem@davemloft.net, dhowells@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, jeliantsurux@gmail.com,
        johannes.berg@intel.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com, tyhicks@canonical.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com

Tested on:

commit:         43b815c6 Merge tag 'armsoc-fixes' of git://git.kernel.org/..
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9ba1b8c7fca2c71
dashboard link: https://syzkaller.appspot.com/bug?extid=3b3296d032353c33184b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=118f59e8e00000

Note: testing is done by a robot and is best-effort only.
