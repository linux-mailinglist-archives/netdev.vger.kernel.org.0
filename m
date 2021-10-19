Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487F343312A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhJSIjc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 04:39:32 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56895 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbhJSIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:39:31 -0400
Received: by mail-io1-f71.google.com with SMTP id d7-20020a056602228700b005ddba37de42so12682728iod.23
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 01:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc:content-transfer-encoding;
        bh=PFI/xvIX6dAhXFtBNV+Jg9qJIg4WEZhFXiwnbN51eZw=;
        b=4BSWk+0JnMAA7bdarG0JDhOYquQzUDmEm1P97BEnux7h+0SkGdU7BPppmM8juZUUoD
         u6WsOmDIZliWvHbv6kAweGbaTPhxdLxbAJgRS0dLMmS1l3h43lzIpf2uze0Yr5ngTA2v
         2Mm/ICLJsxNoANG+hACWHA5JpNwpM5g/H62w9rwwhM3Sk7l4jwbOXnqO5xDfRqJWl6EC
         zVcMmSMZoSy1Mxgkmw9EhHcSypNryi0a2Uj89A51c94Rl6AilKi0ZM0KE8zS1nADVL4v
         mw8nhxJPTR4J4tjvnh2V2aouE9l6A+bEp+UF3wbkA9g+zQ4l6SpBjy35rNrc1AnAGTu6
         JRXw==
X-Gm-Message-State: AOAM530ENtli/+hAa6MbjvmtriZESXh8b2H8oXPkLMdHXUxi0C80t0yf
        E9iXMhn19KGnX4dM84uzhah59zkCOdsGqsPs3i3SdjU2jKNg
X-Google-Smtp-Source: ABdhPJyFlPlQBhnI+xQAZw+JXYUDFdiLClcZtVlG70fa05SRXDQ4ulT8GrK9c38R3l7MM3n4mM7M87XLk5F6WnNtES4lFS7MxtJt
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2a:: with SMTP id e10mr16785350ilu.53.1634632638959;
 Tue, 19 Oct 2021 01:37:18 -0700 (PDT)
Date:   Tue, 19 Oct 2021 01:37:18 -0700
In-Reply-To: <370f6719-b2db-20f8-9a3d-0e1927931b06@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8965005ceb09116@google.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
From:   syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On 18.10.21 20:55, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    660a92a59b9e usb: xhci: Enable runtime-pm by default on AM..
>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1506ccf0b00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5016916cdc0a4a84
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a6ec4dd9d38cb9261a77
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11308734b00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f56f68b00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com
>
> #syz test  

unknown command "test\u00a0\u00a0"

> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf
>
>
>
>
