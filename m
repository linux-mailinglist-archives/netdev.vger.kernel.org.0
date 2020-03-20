Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3E718C69A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgCTEmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:42:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54778 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTEmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:42:05 -0400
Received: by mail-io1-f72.google.com with SMTP id r8so3639275ioj.21
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 21:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+YoOMjO6luwEwwnQleJR7GJujX9qkW3ROR7gWbzVHTc=;
        b=pHNXJUcce0zhnTPUGyuxoh7ikED8KSaKMKNt7yO0GVJ+LZ8yuw98se3za358i4lNQd
         y4XrAq8jQ0zDLpyTDJyTUStVGe5y9BfO7TkU/4KQ4hcTlqqm61PeH4e+iltpoBKK/mv+
         Gur8FLez+YV5enVueKP5u3C+AJZGYfkPa1s1HjlYC7+lM5A7N8Rggb1C26ZBp++sOhk1
         Dibrv94ppYJ3ENcjCUGBhidb+aBVrpOFOk56tYrX5z2dzmOuBtiww6F+6yYEEHto2X+U
         jzx0KlP4cni19+0UQAVKgMiNrZkL05cUj+f4LmA2FB8Rxx/qLgnHUpcGUzuh9oYFR52t
         rhZQ==
X-Gm-Message-State: ANhLgQ2mKU8R1rCap08cZz/vFab74RhwN/4UgKQ0s6hJWQbrHjyoEwZl
        MLju/NmNLZuFEQtmA/bnya3ApRXmSKMYZDApQWxY+I2JK8Rm
X-Google-Smtp-Source: ADFU+vvvu8NLalP1cGxkvhKVN7qZ92RRR3QEjUcPEZNcU+YjcZP8wQ2QavDecLU7agqtV2mMBHcxyCFp2UUC8Pz/K3pBe5ExZNzs
MIME-Version: 1.0
X-Received: by 2002:a92:25d6:: with SMTP id l205mr5908567ill.35.1584679324596;
 Thu, 19 Mar 2020 21:42:04 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:42:04 -0700
In-Reply-To: <0000000000005eaea0059aa1dff6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039c12305a141e817@google.com>
Subject: Re: INFO: task hung in htable_put
From:   syzbot <syzbot+84936245a918e2cddb32@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, hannes@cmpxchg.org,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mhocko@suse.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 99b79c3900d4627672c85d9f344b5b0f06bc2a4d
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Feb 13 06:53:52 2020 +0000

    netfilter: xt_hashlimit: unregister proc file before releasing mutex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17446eb1e00000
start commit:   f2850dd5 Merge tag 'kbuild-fixes-v5.6' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=84936245a918e2cddb32
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a96c29e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fcc65ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: xt_hashlimit: unregister proc file before releasing mutex

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
