Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915891CE4EC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgEKUBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:01:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52517 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728613AbgEKUBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:01:05 -0400
Received: by mail-io1-f69.google.com with SMTP id m5so3589622ioq.19
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=r3rvLS/7OSymcywLi3ykqp9cMo+6POjxD+uKb7XeVJ4=;
        b=lR7N/nSqhGkiljo/DqFr33Bw7ajkmUHevu9lb/uGs1VtSnLjbrFiWdK75vlaflHrfS
         bc12IPzfePJXqZlsjmM2eqvE7tHFlkdbfl9EmWIMKvHh4457xOSizTdeKi/VAm2drmLE
         7+ugLdSbFf7ufFX0iOfD33BruDgbv5qTQ07lW2NO/MC7o2UVGuXLydVzM3AvlH0aUjLs
         Jn2DlFJqbbVgh1/xG4SGpdhgCmnTTZvJWcco4rXo8tmwBaReYdcV8IVfc/rsQo/J6Hue
         15TyiuWt9Tn4ojsKMdohkShl2XFzdMNRuY9tYE5wcJM8Qd9N2Mrl+wOfyXKhobpAB1a1
         9C4A==
X-Gm-Message-State: AGi0PuYu57tu9OkTzGO2383EFWMvRnpEjUCd7uwEkgDTZ++ofu8N+Np2
        Vk/5zavF2gfLG4jhNIX7trP1EoinqmcXy4As4E6Rv99oTW/Z
X-Google-Smtp-Source: APiQypL8PyCi7XJoh3MlvMhOulxVo8dgsO7rD64GpEBtis3OCHtOopeofe3eSf9kphlB30gqo6BxhKHD7PAx9eQlxJ1F6mlQVttq
MIME-Version: 1.0
X-Received: by 2002:a02:245:: with SMTP id 66mr17192352jau.69.1589227264250;
 Mon, 11 May 2020 13:01:04 -0700 (PDT)
Date:   Mon, 11 May 2020 13:01:04 -0700
In-Reply-To: <000000000000dd891a05a56369b8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008da02c05a564ce24@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in fl6_update_dst
From:   syzbot <syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com>
To:     ahabdels@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0cb7498f234e4e7d75187a8cae6c7c2053f2488a
Author: Ahmed Abdelsalam <ahabdels@gmail.com>
Date:   Mon May 4 14:42:11 2020 +0000

    seg6: fix SRH processing to comply with RFC8754

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1154da84100000
start commit:   2ef96a5b Linux 5.7-rc5
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1354da84100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1554da84100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=efdde85c3af536b5
dashboard link: https://syzkaller.appspot.com/bug?extid=e8c028b62439eac42073
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102bfda2100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f8510c100000

Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
