Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A908E185498
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgCNDwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:52:03 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54241 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgCNDwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:52:03 -0400
Received: by mail-il1-f200.google.com with SMTP id z19so6031562ils.20
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 20:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KCmAJDk94gn8lmzBp3+MaZXdfTJa9zfOjP1Al0kR+Bg=;
        b=eV9AyFjR1qltvq0GNylhagzXRm6jqbUgVt6SQS2vnSGzScIErSuSKVgLf4Z4bzCb/g
         MULg0XwUv837qt/y2zpPFVze/noj3C2F/YgmSjgIP+agb+DShMmViARxCmlACcBZHREq
         PhtsGUlR46ZVH0+ALSo2DcPQxxl8IJ3HMiM/ccPFvWY2rhjiYoHa/NLlED7DFFQLErJD
         vzyAvTEo+bJqlg0e8J2cD6YSgoFpaAXzpKENHv20wfWXzbrXr5xHL7/9bR9IjbZjJGpa
         dle7iPcwpKWhId0gmU8opO03p57Rq4yq9adT28z5LysCNQIMJ+VAhD9Np18lAQvHJHDO
         /0Ig==
X-Gm-Message-State: ANhLgQ3Jbe1vuWiBnPHu5e6sa9lUKh+PAOeG0kdfaEAdEQCzttuz2Dfg
        1/EhfSvd7CRXghVA2G5Sm9o9FcMmN6DJ2jDdj66MJrjqd5j2
X-Google-Smtp-Source: ADFU+vt7Mx2gi6kRYfnT0aEo7wr0TNid+UV7hnHce2sBBCczu7qzhEVpG7lpLM714nNqKTdMRjkbmYp6hIKUGEo84swpCtCVg24a
MIME-Version: 1.0
X-Received: by 2002:a6b:5a0c:: with SMTP id o12mr15083450iob.137.1584157922264;
 Fri, 13 Mar 2020 20:52:02 -0700 (PDT)
Date:   Fri, 13 Mar 2020 20:52:02 -0700
In-Reply-To: <CAM_iQpXM7daXmcEGjk+CuOFf3KDixDidWSDpUAk=RcpRehF+Ag@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000398bd005a0c882ab@google.com>
Subject: Re: WARNING in call_rcu
From:   syzbot <syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com

Tested on:

commit:         29311b74 cls_route: remove the old filter from hashtable
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=2f8c233f131943d6056d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
