Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E69018D0BF
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 15:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCTO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 10:28:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34273 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgCTO2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 10:28:05 -0400
Received: by mail-io1-f70.google.com with SMTP id n26so4733658iop.1
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 07:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=V3eZ0Q2sozWnNVeRof3nsCb56+obGL4I8lV01F1qBnw=;
        b=IU5UamHzsXdf0MUwIokmpFtQm42KA1yNtK+KQl15OzSqwsemkOowX8USz+szk47cA5
         EIvZB4aasJ3G8AxB5mDM7lYTINihoasE9M9PU8ZiVy2DGKV0V1IS18nArnoDL8Ozi+Ed
         Z7DDNhSzsqlUfNJYtxFwGuOc9Wvc+xAej6rf32bejjmvaQ1Ogqyzt7SV30fc4zF1heMP
         bFbbj6yQsz7h7qLk9vvhIKhBVC9wRlJ7FjZYJFneqSINKY6TKl7XpxMMXPRgrwSBT5SZ
         qk7bRQrI7XpbkBFuN8UKG4sVV0nixfbLEzqDbxhghQ1MNFZ1dCknfDxNyoKPK/VzSqPU
         3CAw==
X-Gm-Message-State: ANhLgQ3wEySj9T0evtxCXcveCqbeckggnPyaIKea9uAC1H4xkD9RneV8
        LdJFR1haAFhMFzRzkWoiaFxrDb7O+WL9kr6uagQVvHPAHuRQ
X-Google-Smtp-Source: ADFU+vs8Llim/P/NcDrRl0rA9xDffc9w+ks14520WpdyQ2KMPPDXKIdigsLz5Hd/lFxeKcOVJou3SzJdzLJ5COhOBHpYl/hSWQAs
MIME-Version: 1.0
X-Received: by 2002:a92:2911:: with SMTP id l17mr8982118ilg.166.1584714482967;
 Fri, 20 Mar 2020 07:28:02 -0700 (PDT)
Date:   Fri, 20 Mar 2020 07:28:02 -0700
In-Reply-To: <CADG63jAwaYMP+Q3WNqpOnf39_XZ3z5ZZu-ST-f5q2XM+kHgcgg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3ee8f05a14a17f4@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

Tested on:

commit:         a8a7ac16 sctp: fix refcount bug in sctp_wfree
git tree:       https://github.com/hqj/hqjagain_test.git sctp_wfree_refcount_bug
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
