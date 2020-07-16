Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3F221BB4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgGPFAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:00:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42899 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgGPFAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 01:00:06 -0400
Received: by mail-io1-f70.google.com with SMTP id l18so2850504ion.9
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 22:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=cE1hhRVuLf2gZer2Ucpnx9HKI06D31CoZ/RNlVo8Pe0=;
        b=hLEimdIo9svgA3zaiLAzN8Rj0071NsdtFVfCf/Fb6tJS/GRk+BNdTW2xXJdqR/X5AK
         KWj3ePjaghqVXBPaZX63qcyOAX63Pml79944NdSlmZz6hRPWxV/H1IKTEQI0aiB02hPy
         YbD7+IKecUsvzx0c2jSaH9ROGD0JFKYr5JTuv+bOjqf7MNeRAMG/Bae34aLhJ9YI72Kh
         cT6zGVBzldKOzzfHzuPO0nJu4yn7TmSxxPWmC9JovWVcCb785H4UO94bYV+9YbDEyk1d
         RTKl0GsSneDxiWauhx6ftshP5/tkAPsvhh4IMAa6ShGgRdb4CbskVJtbo/FkAS3EY7xe
         rXQw==
X-Gm-Message-State: AOAM532sNJei53defMBSjKUdtk0B9ugiCMX+v4ZjgEH3Ll3xBCUDNyGk
        mLXan5IBPjd1OPwIKo0ZSwtBNbud/o4tD/OG4ZE6D1kYWFct
X-Google-Smtp-Source: ABdhPJwrtEU1PwKJDwMkynoxse8GDaDxlNH/e4aaSkK3f5Z72MwWHALTn6uAryXSscOV5ZuIi1/gjdhbEGKyVnlXGRdUASMWb0gi
MIME-Version: 1.0
X-Received: by 2002:a6b:7c02:: with SMTP id m2mr2790747iok.49.1594875605629;
 Wed, 15 Jul 2020 22:00:05 -0700 (PDT)
Date:   Wed, 15 Jul 2020 22:00:05 -0700
In-Reply-To: <00000000000029663005aa23cff4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef406d05aa87e9ba@google.com>
Subject: Re: WARNING in submit_bio_checks
From:   syzbot <syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, axboe@kernel.dk,
        bkkarthik@pesu.pes.edu, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, ebiggers@kernel.org, hch@infradead.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 449325b52b7a6208f65ed67d3484fd7b7184477b
Author: Alexei Starovoitov <ast@kernel.org>
Date:   Tue May 22 02:22:29 2018 +0000

    umh: introduce fork_usermode_blob() helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fc4b00900000
start commit:   9e50b94b Add linux-next specific files for 20200703
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fc4b00900000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fc4b00900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f99cc0faa1476ed6
dashboard link: https://syzkaller.appspot.com/bug?extid=4c50ac32e5b10e4133e1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1111fb6d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1218fa1f100000

Reported-by: syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com
Fixes: 449325b52b7a ("umh: introduce fork_usermode_blob() helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
