Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6C3CBF95
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 01:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbhGPXKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 19:10:03 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46908 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhGPXKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 19:10:02 -0400
Received: by mail-io1-f69.google.com with SMTP id a24-20020a5d95580000b029044cbcdddd23so7019294ios.13
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 16:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qaMOIh2upbMs9hOM1Tz4AOxQSYOvrsMlI718rr6A6Is=;
        b=e0l9OBEZN+Od8xKR+mDyiZTT4vykUCuwggstfi+g0/9PDoW7QZvPFQKhd98QCvR4er
         8Kh4BAInxfgLvk2Eb04mHdqTOgzmExWiucMpfKAX8PWe3OjHMv8xadoTkNoELJYAWqDL
         rXXZW8YTo0+0r9XJmH33pfJKEdFOMX/D9MJErjhnQxBiNF4uKMEnP3oyS6xVoO5LTdcn
         KFdYTIIli2oZC2se/h7bQ7uDbA2GkPa/CFkp36XN2eMH9HrbaD7fLAvLZcMM2qCmjhZg
         K0moCvX6+0JCY5Pa/bAIrfZqeVm8DJ5wKA6A9GnN4SpFzBHaTLRSLH94xCoWH+h1Gxbc
         qa7w==
X-Gm-Message-State: AOAM53266+Ys71K7NIdNvcsdKmvn9xMtS9AZBq24JJoYxIdZj5bOengV
        k7D/MiWUaDjocJ8kqOLRsPVZCWwcO0rBrHr1nq/OjVoGjwsj
X-Google-Smtp-Source: ABdhPJxsZhI0CdLIY+rzWPN0HYQv81ux+PuPu2AjkvxwV5y7JgLfQU6oiuU1IVzcs8ebcrTDjOTOzG9MGTpliCM3OpXNwjB3HeBm
MIME-Version: 1.0
X-Received: by 2002:a92:d943:: with SMTP id l3mr8182316ilq.37.1626476826637;
 Fri, 16 Jul 2021 16:07:06 -0700 (PDT)
Date:   Fri, 16 Jul 2021 16:07:06 -0700
In-Reply-To: <00000000000055e16405b0fc1a90@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007cbbcd05c745a560@google.com>
Subject: Re: [syzbot] WARNING in sta_info_alloc
From:   syzbot <syzbot+45d7c243c006f39dc55a@syzkaller.appspotmail.com>
To:     a@unstable.cc, anand.jain@oracle.com,
        b.a.t.m.a.n@lists.open-mesh.org, catalin.marinas@arm.com,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com,
        johannes@sipsolutions.net, josef@toxicpanda.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        will.deacon@arm.com, will@kernel.org, zlim.lnx@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 282ab3ff16120ec670fe3330e85f8ebf13092f21
Author: David Sterba <dsterba@suse.com>
Date:   Mon Oct 14 12:38:33 2019 +0000

    btrfs: reduce compressed_bio members' types

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d5f6f2300000
start commit:   7f75285ca572 Merge tag 'for-5.12/dm-fixes-3' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
dashboard link: https://syzkaller.appspot.com/bug?extid=45d7c243c006f39dc55a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164f385ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1427af9ad00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: btrfs: reduce compressed_bio members' types

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
