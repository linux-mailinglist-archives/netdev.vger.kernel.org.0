Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFB441191
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 01:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhKAAMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 20:12:41 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:45758 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhKAAMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 20:12:40 -0400
Received: by mail-io1-f72.google.com with SMTP id 22-20020a5d9c16000000b005e185a8a968so3245060ioe.12
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 17:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Afp5EW5NkKvo/CTFXhPj0ythG6Ja27sM8OR5KgU1Xu8=;
        b=l8NuNZdDRQpaqsjwN1bjULAF3dA2MS/1zZ06yrYpeQEjdEHD7Z/LjEY8sSAnc94lEH
         cTzA/uyQKQ+yVVfiEXadJH2/zXvivab7SoSaU7h0qR0zbGwQfdRkHZKHR6u2HTO53Nhr
         CgxQVI56rvBfxFWD841BLAKQRUSUfRlDGuV12VqnrePd61F5XVu2w3o2ZK+TNo05GLt5
         ESU9hoJ3OLKZSX7Ww69irqw9LdVyODKbNnfaGXZ1IKJWe8zSPlexpiASpIkZdxApSQ+N
         QkaJmgZKFJRpkBhoBUTWG+tWlJCvQUrxRlR5MvGK+zDdqm0nMbbKIq9tT2Q6bfOkUqpI
         Wk2Q==
X-Gm-Message-State: AOAM530PTifRmRGOia3LBjXdpt3ymxMYQ9L5O9cNiCn0AIyGFDZgWe2r
        IIlhPCqL8T0E0HMHZGe7I1Bu2vmpYuaUq7wX1TkHpjkKmrfM
X-Google-Smtp-Source: ABdhPJzvDiSWpENrfpgFn60q4qjm7mMvncZKK3Plr617y0m1LtDCp5/53EwucWc1koNxoVvq4ESrYzdTCQ+mYziVq0qcr6T4SxXP
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3488:: with SMTP id t8mr4452286jal.139.1635725408206;
 Sun, 31 Oct 2021 17:10:08 -0700 (PDT)
Date:   Sun, 31 Oct 2021 17:10:08 -0700
In-Reply-To: <4b2b9c55-e2e0-a149-7dfe-ca36244d2245@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e805e605cfaefff1@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in hci_le_meta_evt (2)
From:   syzbot <syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com

Tested on:

commit:         8bb7eca9 Linux 5.15
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=afe4479d781b5f2b
dashboard link: https://syzkaller.appspot.com/bug?extid=e3fcb9c4f3c2a931dc40
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15bd0e6ab00000

Note: testing is done by a robot and is best-effort only.
