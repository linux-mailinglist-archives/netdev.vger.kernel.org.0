Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5C3803AB
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhENGeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:34:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50049 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhENGeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:34:16 -0400
Received: by mail-io1-f70.google.com with SMTP id z14-20020a6be20e0000b029043a04a24070so9817309ioc.16
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 23:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Tfm3BDGQJB3swh4qZdQjbFt+R0jWQ2xc2bAdJPlLjMk=;
        b=NhjS/BxxE93RKtrSh+aaKiI1If/lTqb6evobwbnQ5Btf0n0OZ5fisL4rOTtMUqVUPl
         a2xCXPYwRkrycA8HU3+3eMP83QYlDlftI5bXXx/fKPHpfLjkE42ySrumdFK5yndr30ls
         AebGSgekpQNdcR/SxaItPEqcW3d6SCnfy3RPKPIOrQATUegze5ixh30FNXbeY0QvVMJs
         LE02nLumY2w0ydmtatRdlbnSdAj5qM4/cyPbJu53MsmrcULwNe2bf9+Iqzymh5bY1Z0G
         HwlXlG5gASmuq0IeAiRnCVR5Zm7wvud8z0aR/gWT8/M3MZU/BxWO0JsAwOjfvGhB6c3e
         6dig==
X-Gm-Message-State: AOAM530Dsd0mPATwvMXZSKrgVzmfo+qXTviHf0yzQ1R0SDKCtglTNf1L
        FOOht8b832WgYZcUxjwcETA+Fh5ykH2jOJW5VZbnBpMnuVFL
X-Google-Smtp-Source: ABdhPJwtXPYhtcMcSW3eVJps1uhikmfwJvy+InnSNpH3TKxsBRU8SeJ8XdCnVu/PmmWUKSvnqzaA1P4MeP/HtRV2Vie9XP3mEYHP
MIME-Version: 1.0
X-Received: by 2002:a05:6602:158a:: with SMTP id e10mr33338426iow.137.1620973985495;
 Thu, 13 May 2021 23:33:05 -0700 (PDT)
Date:   Thu, 13 May 2021 23:33:05 -0700
In-Reply-To: <0000000000001d48cd05abebd088@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000987c8205c2446ac9@google.com>
Subject: Re: [syzbot] WARNING: ODEBUG bug in bt_host_release
From:   syzbot <syzbot+0ce8a29c6c6469b16632@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kuba@kernel.org, linma@zju.edu.cn,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, syzscope@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit e2cb6b891ad2b8caa9131e3be70f45243df82a80
Author: Lin Ma <linma@zju.edu.cn>
Date:   Mon Apr 12 11:17:57 2021 +0000

    bluetooth: eliminate the potential race condition when removing the HCI controller

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15427145d00000
start commit:   f873db9a Merge tag 'io_uring-5.9-2020-08-21' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb68b9e8a8cc842f
dashboard link: https://syzkaller.appspot.com/bug?extid=0ce8a29c6c6469b16632
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10310972900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bluetooth: eliminate the potential race condition when removing the HCI controller

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
