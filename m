Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744063EE4BB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 05:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhHQDDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 23:03:40 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:45805 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbhHQDDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 23:03:38 -0400
Received: by mail-il1-f198.google.com with SMTP id l4-20020a9270040000b02901bb78581beaso10853306ilc.12
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 20:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=r36cl7Dm93TI6Hk3w1gK1TcRtwvGhgvxUmk3P8QzyoA=;
        b=Q9t6WDqQ/r5OsS52lMuUB6F2EOieQjdc4Kjum3jwQnsTZkeP4nD4X/AzApAtJNleKX
         n44z1zMdg55h4SmJuB6A0bq0+qP9bZecp21JOKYwZWAo5wCSMXXEftZnWG8myNFUgXfn
         5Imu6y28T5isYgju2xtGacF6RucKWzG4JX9mLunNqNgaRwfO6dST41nt0foM1nObt0Rt
         Pl951alPoMWQ+MxgO0vFRM3ahGoArOHF9nf3sga8nPYiSJJxlcGaM382fDtpkHxAEdNz
         P4+rb1Nd+4GdEs0kxhzadbc9Y3lRUJATWm5Nhe6KNZYwaRrYSmhcy9sI53lL6kpfMmSX
         TVtw==
X-Gm-Message-State: AOAM532+Lx5Dl1pAYdWbGfepgEVW9txnDytjvnEISlBdf74SflpeAlRN
        pmXxe55ohdZaLo83I7MHvb6XLuoh56UmMM7ODN0dgXUkBrpQ
X-Google-Smtp-Source: ABdhPJzlctyr85a5kEj6HJpdeI+NV5Yxa//9wnjg7kk7US/j0HDD24qv9viEa0QuGVe26j6R8Cc5o192IS8pf+7WAvEoz9gD46GX
MIME-Version: 1.0
X-Received: by 2002:a6b:7106:: with SMTP id q6mr1173087iog.174.1629169385855;
 Mon, 16 Aug 2021 20:03:05 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:03:05 -0700
In-Reply-To: <04cbd217-21d2-c623-2d06-35d6040a3479@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085df3005c9b88ee0@google.com>
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
From:   syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com

Tested on:

commit:         794c7931 Merge branch 'linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=96f0602203250753
dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12c85965300000

Note: testing is done by a robot and is best-effort only.
