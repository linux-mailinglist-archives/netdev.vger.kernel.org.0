Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933D81E0B92
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbgEYKTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:19:05 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45590 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389373AbgEYKTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 06:19:05 -0400
Received: by mail-il1-f199.google.com with SMTP id g19so14797256ila.12
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 03:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=whoLZ/cMcXb882oZ1pDdASgEN3wOLkDsAb0kfev0mIU=;
        b=dVq50jVPJ9SESUzBUtQ6nw9di/YH8xewI3tr/h9t7URGoMadlgd3zF45TkKZpLTeUr
         NabvINshmtn8mC6S3xlSBr5utCj5UfAxCyRWJg01PObWpgDvT/KQIl4ERRvoAMnnlfcB
         CDnnhdB22ciJq6DQG+R0KTzndPoq/N8wYyZVdKiWQOKJy4O933hGcCe0TQ9iWo7MA00O
         hT1xcLgs3TqrHkMKudLzgJafz97M3XDwvH8ApAcsql8eKyAVqg93AodLExsk2tVz2kTl
         KseWCisbCi0GY0ZctJR7mGhfD2lGv7tgOgL+nLDxiQ6CBZH/d3guBagCL/VIP+t6Xf7q
         8oOA==
X-Gm-Message-State: AOAM5339hiXdA34o0eaADCFIFphiXnHiTnFw+OjJB9+1iwDuoCQzPHnY
        4qhywIZ/LhXDgPqf4VI4WpKrJILVeNne8ds0Kcnqk4o1VgL2
X-Google-Smtp-Source: ABdhPJx+tnjOlgCi02g4SUjSWTWYNC0Cv4sVgDVr14y8LKntAXEIw1aJC8Vk3mNbVow1S6zjJQ4Lbgs7vJILAN2bfDVXV1/HhbNz
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:965:: with SMTP id q5mr23266428ilt.272.1590401944546;
 Mon, 25 May 2020 03:19:04 -0700 (PDT)
Date:   Mon, 25 May 2020 03:19:04 -0700
In-Reply-To: <0000000000000a9cca057cd141bd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f472ee05a6764e46@google.com>
Subject: Re: inconsistent lock state in icmp_send
From:   syzbot <syzbot+251ec6887ada6eac4921@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        jon.maloy@ericsson.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 1378817486d6860f6a927f573491afe65287abf1
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu May 21 18:29:58 2020 +0000

    tipc: block BH before using dst_cache

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10cbef06100000
start commit:   f5d58277 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
dashboard link: https://syzkaller.appspot.com/bug?extid=251ec6887ada6eac4921
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ab6ba3400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: tipc: block BH before using dst_cache

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
