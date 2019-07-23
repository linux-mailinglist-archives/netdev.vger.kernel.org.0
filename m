Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F2771DA6
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391077AbfGWR0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:26:31 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38929 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391066AbfGWR03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:26:29 -0400
Received: by mail-io1-f69.google.com with SMTP id y13so47916290iol.6
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 10:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=18dpD/naihNOjoNrgGIrjwwIJhV9RriEpPtRMJT/ORo=;
        b=PCDfDOQA7dofeBdhiQIgMYLPEVQIRLyl0k4De3LKdqp+25rbE2u7AbFpKrwOR5POq8
         x3whRguYvXV5vwaHdo9mDT3Ddgke6VuJdQbelWmoyOC2Cw2PWm5LqFVdnrmRYVkS0VQn
         EeHnUGlQdhqJOmMUe2sDxWuJs9CHaO9TBPcbI1lggoLPC2V37zyi/FQPiCd5i+invzyE
         3QXAYa40/i7j5fIEzpFK8DmVkng5LkuLsQXlxd8yPoErtotJEzDYJ6lfRpbk28wMJkSV
         zK79DjoHC5kqpXzApEGoX4c6zXW7m9WJyL5H5kHVF1b8qQD3gyfQpMVikFI2aQzbuPZp
         jiFQ==
X-Gm-Message-State: APjAAAW3RHfnVi1/OgHpgVcXJjQStdZQNZKY+L7X6DnE5te2g6WKyJLH
        YZJuGqF+4oOcnQ5eXmQIj9qHSQNxAocCu+aEaM0l7Zkam/NN
X-Google-Smtp-Source: APXvYqyCe7AfPrluXBIbZlQzVEeh9JxvWJ4U1jT02MrsCAmY9jj6X4SXKsEfnTom19bvNkP5FIZFgnFlrHkpQva5F/PA/CCuwooO
MIME-Version: 1.0
X-Received: by 2002:a5d:9acf:: with SMTP id x15mr44816852ion.190.1563902788559;
 Tue, 23 Jul 2019 10:26:28 -0700 (PDT)
Date:   Tue, 23 Jul 2019 10:26:28 -0700
In-Reply-To: <5d37433a832d_3aba2ae4f6ec05bc3a@john-XPS-13-9370.notmuch>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002cec2e058e5c7e63@google.com>
Subject: Re: Re: kernel panic: stack is corrupted in pointer
From:   syzbot <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     airlied@linux.ie, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.koenig@amd.com, daniel@iogearbox.net,
        david1.zhou@amd.com, dri-devel@lists.freedesktop.org,
        dvyukov@google.com, john.fastabend@gmail.com, leo.liu@amd.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Dmitry Vyukov wrote:
>> On Wed, Jul 17, 2019 at 10:58 AM syzbot
>> <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com> wrote:
>> >
>> > Hello,
>> >
>> > syzbot found the following crash on:
>> >
>> > HEAD commit:    1438cde7 Add linux-next specific files for 20190716
>> > git tree:       linux-next
>> > console output:  
>> https://syzkaller.appspot.com/x/log.txt?x=13988058600000
>> > kernel config:   
>> https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
>> > dashboard link:  
>> https://syzkaller.appspot.com/bug?extid=79f5f028005a77ecb6bb
>> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> > syz repro:       
>> https://syzkaller.appspot.com/x/repro.syz?x=111fc8afa00000

>>  From the repro it looks like the same bpf stack overflow bug. +John
>> We need to dup them onto some canonical report for this bug, or this
>> becomes unmanageable.

> Fixes in bpf tree should fix this. Hopefully, we will squash this once  
> fixes
> percolate up.

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

">" does not look like a valid git branch or commit.



>> #syz dup: kernel panic: corrupted stack end in dput

>> > The bug was bisected to:
>> >
>> > commit 96a5d8d4915f3e241ebb48d5decdd110ab9c7dcf
>> > Author: Leo Liu <leo.liu@amd.com>
>> > Date:   Fri Jul 13 15:26:28 2018 +0000
>> >
>> >      drm/amdgpu: Make sure IB tests flushed after IP resume
>> >
>> > bisection log:   
>> https://syzkaller.appspot.com/x/bisect.txt?x=14a46200600000
>> > final crash:     
>> https://syzkaller.appspot.com/x/report.txt?x=16a46200600000
>> > console output:  
>> https://syzkaller.appspot.com/x/log.txt?x=12a46200600000
>> >
>> > IMPORTANT: if you fix the bug, please add the following tag to the  
>> commit:
>> > Reported-by: syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com
>> > Fixes: 96a5d8d4915f ("drm/amdgpu: Make sure IB tests flushed after IP
>> > resume")
>> >
>> > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted  
>> in:
>> > pointer+0x702/0x750 lib/vsprintf.c:2187
>> > Shutting down cpus with NMI
>> > Kernel Offset: disabled
>> >
>> >
>> > ---
>> > This bug is generated by a bot. It may contain errors.
>> > See https://goo.gl/tpsmEJ for more information about syzbot.
>> > syzbot engineers can be reached at syzkaller@googlegroups.com.
>> >
>> > syzbot will keep track of this bug report. See:
>> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> > For information about bisection process see:  
>> https://goo.gl/tpsmEJ#bisection
>> > syzbot can test patches for this bug, for details see:
>> > https://goo.gl/tpsmEJ#testing-patches


