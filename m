Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4013B740F
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhF2OSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:18:33 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39774 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhF2OSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:18:32 -0400
Received: by mail-il1-f197.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so13111836ilc.6
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Kg5nOcsBqEKYMddrauP1mweIcVDvq/YayRMorfAz0/k=;
        b=swwztBbradRVAjpEHSJpi3i6AE/4GwBZWKLfxEJw5yGuG/fUEz/QpYp6g72OqAROaj
         Ek01vpjMPPVn7ohreKiUnTpicdj/Ik6flnqj1PwQQghn/qW2ZGSS0/dzrpxpYxHeYDjD
         y7a7A68WluJRdAAjZK02rfelnQMXNJFzHjaoYCr3qca5LYuedQkCU55rw18Y1K1tD9WH
         9amfraz4nNsVRsgH7vJ2uacwqmcGXQ+XwU2IX9BFIl8i1AiQ2h71Z7VapNO7liI3s90h
         Zttvdl43c+FKq8tSLNG6doRrcHb8BH0FDg0+tlDc69AljFbiVz5oM3IoQ6v47X4XVsnR
         Pr2g==
X-Gm-Message-State: AOAM5331s6vi8BxVPXwmZhWjc2HmTDtu2e7N533VbPau8XqLFeI0dat1
        OEaGUFgU7lwpAz666m5xovOZhoyUn3W+84z/59W9xoOsvtek
X-Google-Smtp-Source: ABdhPJzJJf9qa4qerHgm/jHnJPF8RRfdFjLMgduFLh5UyYNe4icnAd2Po5OJYIXgHcUJm5omlKixZQuHnfviK/tbAWnI/76uJhaY
MIME-Version: 1.0
X-Received: by 2002:a05:6602:140e:: with SMTP id t14mr4119513iov.42.1624976165142;
 Tue, 29 Jun 2021 07:16:05 -0700 (PDT)
Date:   Tue, 29 Jun 2021 07:16:05 -0700
In-Reply-To: <20210629095543.391ac606@oasis.local.home>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001785c005c5e83fac@google.com>
Subject: Re: [syzbot] WARNING in tracepoint_add_func
From:   syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, mingo@kernel.org,
        netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+721aa903751db87aa244@syzkaller.appspotmail.com

Tested on:

commit:         c54b245d Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b55ee8fdb0113c34
dashboard link: https://syzkaller.appspot.com/bug?extid=721aa903751db87aa244
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17938e5fd00000

Note: testing is done by a robot and is best-effort only.
