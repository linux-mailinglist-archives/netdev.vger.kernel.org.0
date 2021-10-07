Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04E4253E8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbhJGNWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:22:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40465 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhJGNWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:22:00 -0400
Received: by mail-io1-f71.google.com with SMTP id r12-20020a5d96cc000000b005dc1dcac76eso4734265iol.7
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ta8TFCyBY1gpWCj21ajzUB9frfUQOUQio86Er8sxqeo=;
        b=wNErFoaQowL4fbrf7m9MQ0I4JOs34O4dnScOp5cPOS5gTmTD3Z+R04PpK/dtzYJ6lp
         5NXNLab1uLmvBGvaISrP6uUU03begqcKv7apnVNIlnaMFbBX7Pce3wQuJ0LMLylcH3W/
         V0GAMYnPayXrWj+yXd9egt/r21+cWtxs04ntEEWAjQ4E77k2IUM+6HPSgUXeVRJnPZc/
         yZ9w6weP2tAe5mR181pkrN8vKbjesNAz07Qhj4D02Vc0RqJOjD79igfDTs68tVrkEf2X
         SdKqUOmFeiLpZSZ+XA2HwTWEjKmVz+s6AUMe63mHm/7HlJniaiw3O4xTwiOH98f6aF8q
         piZQ==
X-Gm-Message-State: AOAM532bEA2QxQvG7UHiVTuE0Mp+58TT8OKVs1gbKAUcc+SIiA2vMY1G
        r7r0Kw0NcmKj2oSqJPGa63HQq/dwPMY45dHUnEbkJtR9pRkt
X-Google-Smtp-Source: ABdhPJxX+LmOXMIhLmy2MtMP/zvk5EDCKJa7XQPxqftj0hiiK6+wuzEnrRmw2/+EERMeZYDiNCg0lWg48DkTd7v/EVqDJLrP+z0T
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c2e:: with SMTP id q14mr3187493ilg.109.1633612806720;
 Thu, 07 Oct 2021 06:20:06 -0700 (PDT)
Date:   Thu, 07 Oct 2021 06:20:06 -0700
In-Reply-To: <0000000000000845ce05c9222d57@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b920e05cdc31f01@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
From:   syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 13 12:42:33 2021 +0000

    netfilter: nf_tables: unlink table before deleting it

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13018e98b00000
start commit:   f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: nf_tables: unlink table before deleting it

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
