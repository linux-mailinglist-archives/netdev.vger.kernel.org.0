Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB7C2453E0
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgHOWGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgHOVut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:50:49 -0400
Received: from mail-io1-xd45.google.com (mail-io1-xd45.google.com [IPv6:2607:f8b0:4864:20::d45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E6EC061231
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 22:23:09 -0700 (PDT)
Received: by mail-io1-xd45.google.com with SMTP id 127so7381362iou.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 22:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+25FmT8dO4pWjXPGwlb17rDpAfTAbCr3FFkhBNcwuAs=;
        b=p2Am4xj1juCq9D+JuoNanz0nVgRaEl1mCfQ2yThJRMB7gQncD5AiwIkc6TT0jmsO7g
         kl9JTTMmXatvnLi1K2aL0woM4Waocke5gMtin8ZIMB2cbyyzBH/Ww5v0J3KONxPO+reP
         HZ3QgY25RFO0jd0X0Qv9e2IvT15XkEAVyXHg0jx1P5t7+tDj33rE7J+IaowcJa3wjldb
         rjltt2siZRWRwbtvczjx2jUAElcaK+RNKThLYeEfAHg/x7hbMF9yUbMzaHTncZrQTqGX
         WpNdJEjlfwCwzdlXy3dHDET4Jn3FdXzTu01yXFn0/xKTTCv3CVGhsfFDxiZzAE66A4r1
         uSGQ==
X-Gm-Message-State: AOAM532keitR3i8HEYMc4g9aZyXrVwN34pbUYES3Qbg8c4+//MWlh0kR
        J04B+IWEwzHRObQW0whfdDEI0CPLUnho9z6luS+o8actbKRn
X-Google-Smtp-Source: ABdhPJydlCxs/36cUc4UNHPK6M0HkLjuUhkbtL2IuaVgPgv4K8a6I+NSpBzJX7MWxkS2M/6tiP8RcVV1wSXKsNQxeGt/4EVo4FU6
MIME-Version: 1.0
X-Received: by 2002:a92:b712:: with SMTP id k18mr2432857ili.220.1597468988463;
 Fri, 14 Aug 2020 22:23:08 -0700 (PDT)
Date:   Fri, 14 Aug 2020 22:23:08 -0700
In-Reply-To: <000000000000eb6a8e057ab79f82@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098e02c05ace3bbfb@google.com>
Subject: Re: WARNING: refcount bug in p9_req_put
From:   syzbot <syzbot+edec7868af5997928fe9@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        hch@lst.de, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a39c46067c845a8a2d7144836e9468b7f072343e
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jul 10 08:57:22 2020 +0000

    net/9p: validate fds in p9_fd_open

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1015f012900000
start commit:   459e3a21 gcc-9: properly declare the {pv,hv}clock_page sto..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef1b87b455c397cf
dashboard link: https://syzkaller.appspot.com/bug?extid=edec7868af5997928fe9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1642ee48a00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net/9p: validate fds in p9_fd_open

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
