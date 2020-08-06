Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F223D720
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHFHBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:01:30 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44213 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgHFHBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 03:01:05 -0400
Received: by mail-il1-f200.google.com with SMTP id y82so28141348ilk.11
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 00:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7dfgtw1iR3AjrQXBtDJPZWn65f38aLiV7OcURuGXSL4=;
        b=opQQo/e2jNuoiDR02T2a0Bzo4laK/fEMQkEkD03fKArP546DaPRKvmV8hN4h2qwrkh
         u035eWZp4TlLwhLw0U+Jm/2+SpNkIHEhU6/EfcQZQU8RBee2NF3Rv9pgjXIeLt9y0tBH
         DM0KZvk9RehxvXmQoczjh8nCsNzahn+a9MVtlnn8Kw7JVeBbkZCOE8nBaQh44dj//xDc
         9DQ/Mk70dfHSYknIc/lrKtrzXEdNQ83c2lxc8SJ+HkBdzc5R5qWqBBkyR4gD2ajZj0uR
         oHWkg2cCulw6D9jgeO8dlY914608tQIOVj5enHe1ynOx9vWQplrs7U9DpU50LyAl56MF
         pb1Q==
X-Gm-Message-State: AOAM532bpsRhYPozcxDvPMuzZ8Kq/aK5Qh/vCxbenE4TvgnF3Ni3lijk
        HQHQRdcU0l/p2I7qKwFk8x9re+IaWN2hqlGUbOD4MsLT6IH7
X-Google-Smtp-Source: ABdhPJy/NNkYLn1yvZCHE7rpwLkZOK8dRMoNBFkSPy7ou01r8UDVgYzQVGCO3tkNx8KwQ2h8PC7FmQF05vWr1AcJaPz7b8SR4Sxg
MIME-Version: 1.0
X-Received: by 2002:a92:c844:: with SMTP id b4mr8694995ilq.297.1596697205171;
 Thu, 06 Aug 2020 00:00:05 -0700 (PDT)
Date:   Thu, 06 Aug 2020 00:00:05 -0700
In-Reply-To: <00000000000053e07805a9b61e09@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba6a2d05ac300953@google.com>
Subject: Re: KASAN: use-after-free Read in __cfg8NUM_wpan_dev_from_attrs (2)
From:   syzbot <syzbot+14e0e4960091ffae7cf7@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit bf64ff4c2aac65d680dc639a511c781cf6b6ec08
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat Jun 27 07:12:24 2020 +0000

    genetlink: get rid of family->attrbuf

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12069494900000
start commit:   e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=14e0e4960091ffae7cf7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11818aa7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f997d3100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: genetlink: get rid of family->attrbuf

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
