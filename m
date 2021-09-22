Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F25414729
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhIVK7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:59:37 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37632 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbhIVK7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:59:36 -0400
Received: by mail-il1-f199.google.com with SMTP id f10-20020a92b50a000000b002412aa49d44so2209932ile.4
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sIEI9uk0jXLPg5tRngu0deQrqbcmRIPtQjNY17o0nVQ=;
        b=yPK2DbqPON+5BZbtzV1aPWISMbdwZdYKvlQh/rKg01M55c+ZENzK+EowCwzqv6n84+
         TODP1D4qPVSdFxa7xUIjcD/z4uZQal1kwPL9SzEdA9u7oKp3yKhZqwArCM74+GRe+GTu
         l2SPcTB175gg/WOpb++xhHY7ap91B7+iPbmOk5VO13OyrdvYtw7QEO9CQGJ3yvhkNYyT
         hb8BIH/HpDED1DcCTORw8xbkUUNEdhgHT1PsJpYPX1miX0WN0vrcBFwFXd/l5Wqd62Yh
         SS/CpPVV+WPokeY1NgnH3qIGrENpWPOtLHwGbH84aWJ/0A9aNF6HCcjNLuY6Ltsb4y0Q
         yGmA==
X-Gm-Message-State: AOAM530EGvlU5lfr9xGwQzp/auJ57/tWQT5fJ+2e1mh3VaRrQ4WTUKyh
        NJVsBXU98SY7R+rv4YK98QcsPLVaGN6LA+GZrqVvmu+k6IJj
X-Google-Smtp-Source: ABdhPJzrupLFuHWEUbPmU68bVPECDv0uWyy/kVwXi6sss4UKhYlFnfSOJL8EuF/CcQqBBCx0RPY2ctH++ZBK03DFe9VBkJalyAc3
MIME-Version: 1.0
X-Received: by 2002:a5d:9958:: with SMTP id v24mr3929152ios.201.1632308286875;
 Wed, 22 Sep 2021 03:58:06 -0700 (PDT)
Date:   Wed, 22 Sep 2021 03:58:06 -0700
In-Reply-To: <7de92627f85522bf5640defe16eee6c8825f5c55.camel@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a729905cc93635a@google.com>
Subject: Re: [syzbot] WARNING in mptcp_sendmsg_frag
From:   syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com

Tested on:

commit:         92477dd1 Merge tag 's390-5.15-ebpf-jit-fixes' of git:/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=263a248eec3e875baa7b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=142df1ab300000

Note: testing is done by a robot and is best-effort only.
