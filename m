Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044F3F3046
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389632AbfKGNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:44:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51681 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388913AbfKGNmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:06 -0500
Received: by mail-il1-f198.google.com with SMTP id x2so2614417ilk.18
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CZJgdUC1TpRcETObVUB558+pxazKYw5Wn3n/HURXADI=;
        b=DD975K0p5zZlqRoDntKf6DG+RSZMR9sOiZjE3kv2AxvcHoNMRqFc2KYgSE82gfFSiO
         zCRKXVszR0dALYSydMntJN5fAHYQP5CAB+Ftlk1Gbpa0SFCGtk5tBTrCgzCLwbp+Hcwy
         PqXNpVZhYHtxRatc3DMAMuy3OmMKyHY/bZiRwU9Bi4w+6FKnSzF8tZGq3hEsI14BFvNb
         fYpu5/0x2Pj7tbbeSMBzrsX5oL7su9WUbup9j9RxMI9g0ZRrYUanTzS3ItAVv2rJ5WOW
         6/zbtWoqtScdkDVtXLDV8Kn1x1VxVBKRoBlL9rlywkFRa1yhXGNgdegV6y3XHMZUikMY
         Uk7w==
X-Gm-Message-State: APjAAAV5R56Kek7LYMcKR/oT4lc3XYVJnmg6HjABd/DqvFRMzJZbRyP+
        ivqfSuOhNij3C/vzJ9SPHHccquVLChndYgkR5Bs1kM+1K5pN
X-Google-Smtp-Source: APXvYqynOcIaT2y3jyHS10UgIJT51zZMfk/18yGsgEM4vujcLU66FRilTI2odarVdOVEi2iPozlH+L82DAgMEg7NmWA/wsb0TRhw
MIME-Version: 1.0
X-Received: by 2002:a6b:ed1a:: with SMTP id n26mr3703846iog.112.1573134125729;
 Thu, 07 Nov 2019 05:42:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:05 -0800
In-Reply-To: <0000000000002a2fdf0573107004@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bfa1ab0596c1d403@google.com>
Subject: Re: BUG: corrupted list in p9_write_work
From:   syzbot <syzbot+1788bd5d4e051da6ec08@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net,
        dominique.martinet@cea.fr, ericvh@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 728356dedeff8ef999cb436c71333ef4ac51a81c
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Tue Aug 14 17:43:42 2018 +0000

     9p: Add refcount to p9_req_t

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f2258a600000
start commit:   050cdc6c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=49927b422dcf0b29
dashboard link: https://syzkaller.appspot.com/bug?extid=1788bd5d4e051da6ec08
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1196b7ba400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1022391e400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: 9p: Add refcount to p9_req_t

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
