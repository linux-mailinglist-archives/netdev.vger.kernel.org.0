Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73B1439080
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 09:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhJYHoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 03:44:30 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:46968 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhJYHo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 03:44:29 -0400
Received: by mail-il1-f199.google.com with SMTP id x18-20020a92cc92000000b00259b4330356so6109474ilo.13
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 00:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FRp5DFjNkB5DYili8ZiV7kEXz8tHdesF7it/j+y3PY0=;
        b=OykthaNx7IQV5pTcCllaoysemD1sgd85KA8nd+67ShgpTpe2wnLKjrwmngT+mbqNar
         91s8gOTQI7oOGWcqtPu6oACbDkFDLtMvuV6xhOab0OT1jtYvg46p0hFYQmfrNY67LDAa
         DMrcM6EX9wnN3v6E0U7hX6MvFq7QvV9klmzzvJJ47kztPXSLBcyJ5rGbIGIOMF4P4Vb/
         z9rbj9EgY981XlY6u6Z4Jb3xTcPCm4tbW2+bHrZK8W0W1bJUKDDXpb4dBlQRbsajWGWB
         rYy+NN8GCox9RbyD8+mAk4iSnNnXFTnh0nqQrRn0BiZuAzrkcM5Nl5A36mLAaYNrrqdI
         761A==
X-Gm-Message-State: AOAM531dd6GLRXr6z7Ig4A70E8s2gaboMY8f0OaSRd24EbP/qMGc9OCV
        NeKt0uSEDzVy+tcl4ItAQHwVTThlXun3F8q0gFOS8PZ5jen/
X-Google-Smtp-Source: ABdhPJyY3BE6Hexn4GAHUITeNQNHgSQLr4zZ1XijU4QpLsYOvdQlTqckWVWab9qr7zgTSAsIBnAEP48S7JkF97KWJ3GsV36XpeUH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1607:: with SMTP id t7mr9303589ilu.296.1635147727196;
 Mon, 25 Oct 2021 00:42:07 -0700 (PDT)
Date:   Mon, 25 Oct 2021 00:42:07 -0700
In-Reply-To: <000000000000d5efd605ccc6a5df@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f55c405cf287f25@google.com>
Subject: Re: [syzbot] general protection fault in nf_tables_dump_tables
From:   syzbot <syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 13 12:42:33 2021 +0000

    netfilter: nf_tables: unlink table before deleting it

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13efcb0cb00000
start commit:   9bc62afe03af Merge tag 'net-5.15-rc3' of git://git.kernel...
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=0e3358e5ebb1956c271d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14374e5f300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: nf_tables: unlink table before deleting it

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
