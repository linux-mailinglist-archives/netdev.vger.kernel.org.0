Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22381859C1
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCODi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:38:57 -0400
Received: from mail-qv1-f70.google.com ([209.85.219.70]:34177 "EHLO
        mail-qv1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCODi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:38:57 -0400
Received: by mail-qv1-f70.google.com with SMTP id ev8so4597866qvb.1
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 20:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=H5UL55Jt0P8+lhekSBof6CJMLz8v0e26Cnd2rcAgXuU=;
        b=UguPWAqtrey1T5gEcC/DgasN+azRtuX/tZuNuOHTkzoo7jgqip381bw+i1MFXbhnZ4
         7cf3LJK1LH/4wy4aDNUfkWiGxB+lICWMJAysra6AzDX8VGdn1/JBwIu1Jnf7zByosXNQ
         lTiKE+h+o4md/s2MqFJ5NGgDQiQ/feVuODPbIlGhTFzJM9HZwZPuemqV3m9D1gVO56hj
         TzFk1Q4oPu/BWyQ6KmxLDbtExaRiB9n+Zfc4UPVetk/DYuySgBTR3D6zoUIF+tDx/SMy
         6IBIVWhI+3xwp4pJGOzYOKLwkpF1AzheUiJ0v0ppn6mLwm2eBDGVfybj/rLkjEAUIO2Z
         e5Kg==
X-Gm-Message-State: ANhLgQ2AADSrrNhan9MRcndXCHiFE82k/D4LutRltJtMAQCcyMJWqR8Y
        BlG72DnQ7poLqqgdY9ffJSiYBp3kPP4cvdhIfjetVS1nddvE
X-Google-Smtp-Source: ADFU+vuMuZRQB4plQWTVVNLqwBcbrFI1SQwYA3uqfRjAyzEhpvXcwloMBXgVy/yGvQ7oZDstiPZt9V3wkVKoQhD/DqzkLaxTcBBW
MIME-Version: 1.0
X-Received: by 2002:a05:6638:266:: with SMTP id x6mr15874404jaq.46.1584159902975;
 Fri, 13 Mar 2020 21:25:02 -0700 (PDT)
Date:   Fri, 13 Mar 2020 21:25:02 -0700
In-Reply-To: <CAM_iQpUo0L0+J7aGTvUsBWZ=A8cGxyN7oJVjqyent+9OCbJ_Jg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048ca0c05a0c8f8a8@google.com>
Subject: Re: WARNING: ODEBUG bug in tcf_queue_work
From:   syzbot <syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com

Tested on:

commit:         29311b74 cls_route: remove the old filter from hashtable
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e8e51c36c1e1ca7
dashboard link: https://syzkaller.appspot.com/bug?extid=9c2df9fd5e9445b74e01
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
