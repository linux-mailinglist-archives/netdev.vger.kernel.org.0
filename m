Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3E4A8245
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiBCKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:25:13 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:35743 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiBCKZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:25:12 -0500
Received: by mail-io1-f69.google.com with SMTP id y124-20020a6bc882000000b0060fbfe14d03so1615522iof.2
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 02:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Rxhq5+VXSIrIwj7a/GsrEywPOO2yQbABshUuuSgeFDs=;
        b=idwWYsZiBhy/eqbBlPdK3iGUYJm/zCDdha+4zDpZusNknvbGNOBzRv7cqwHIlj8UVo
         hOmrs8D/+uaCFz/j6DTvBT/R9TngQWyMy220IW/1+OEe/TupS5FL6/buLlIYg+INPomt
         FICgfqOpX2Hx8gGLLHd2HerpLkjtRwzsbqojohvumfx3w+seSsPv019qpnsFXc2Fb7WE
         fRHWz9UXX3uFdOEownh5WMSLGoFWm5ss8+MRHIVyenjeUFROmuIaoj9SWLXcGm61xglp
         +xWShYaBySQUFxJgPxvdi0RNYqc+yqy0aMuJjQZkxrmlKtgRR2hFDVHmkQnxY+sx0lse
         To+g==
X-Gm-Message-State: AOAM531iGoT/Y2JmlvzF/x8LKuBISTFcb6je2N98hRlCxZNgckPdx2d4
        RIUVK1TJcyAwL4iThORxq+dshWBQAhqPNx/ygspYZbN8909l
X-Google-Smtp-Source: ABdhPJwciDKQal6Z8tQiBUOtqqjZ9Z10+I25ua2fg40YZSw5o6TjWWvTvcWi43d589ZwucSUE+At081HdhPPiDtRhfgxGm6Iv0ds
MIME-Version: 1.0
X-Received: by 2002:a6b:f218:: with SMTP id q24mr17682264ioh.55.1643883911669;
 Thu, 03 Feb 2022 02:25:11 -0800 (PST)
Date:   Thu, 03 Feb 2022 02:25:11 -0800
In-Reply-To: <00000000000079a24b05d714d69f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b6eaa05d71a8c06@google.com>
Subject: Re: [syzbot] general protection fault in btf_decl_tag_resolve
From:   syzbot <syzbot+53619be9444215e785ed@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit b5ea834dde6b6e7f75e51d5f66dac8cd7c97b5ef
Author: Yonghong Song <yhs@fb.com>
Date:   Tue Sep 14 22:30:15 2021 +0000

    bpf: Support for new btf kind BTF_KIND_TAG

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12183484700000
start commit:   b7892f7d5cb2 tools: Ignore errors from `which' when search..
git tree:       bpf
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11183484700000
console output: https://syzkaller.appspot.com/x/log.txt?x=16183484700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5044676c290190f2
dashboard link: https://syzkaller.appspot.com/bug?extid=53619be9444215e785ed
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16454914700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceb884700000

Reported-by: syzbot+53619be9444215e785ed@syzkaller.appspotmail.com
Fixes: b5ea834dde6b ("bpf: Support for new btf kind BTF_KIND_TAG")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
