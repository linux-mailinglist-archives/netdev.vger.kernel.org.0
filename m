Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D586F29FC36
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 04:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgJ3DcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 23:32:11 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33360 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJ3DcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 23:32:11 -0400
Received: by mail-io1-f70.google.com with SMTP id f128so3401149ioa.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 20:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0gWbIpsSTzXNygO6c58tnJifaEc8ywsuOsx2ut44wuA=;
        b=hP8bh8/PymJ6//X3NJnwSx21BOIgl99hiDNRWIIgkMjBTTyxaKPFkaP8KReiXMI5wW
         bjVgUFrwuTAHv0mIC2OJWP1Ac30BXG3Xhu3QlbJhwdVW2eZjOXdtw1vky81c20f+5EkG
         nPAT5FcINShZd4tDJ80x0XWoDBnf4Y0giGvX7tXFgAEw4PlXaLN9xe8H0Ox0wsqlT4Z1
         0PJP/F3ZUGc1a9A7de9ped0tl4lltYLN4eQI0xw+xCMbpiDE6LtEUmGk0ENgZbmDHo2o
         fHq+kQhFgjMcXcPgk9bYdq84HbZPs0cc0WQDFbBWYA70/jQKoJWYa8XRsK66bzj3J9Oc
         hE4w==
X-Gm-Message-State: AOAM530oxH5qT5GH3yJsmUKmBBjFO9O/06ixnMjCSSWUth5Ih+Fx+WuU
        BB3CzxkfSwkAprgz3/wGK5H+yuHwarOWyz+dw6H5bCAT6pvJ
X-Google-Smtp-Source: ABdhPJw5c2LMOPMt3I+nORNDZdoQ3e2XlV4FSnmtPJRE9wFruGS49tCYvqy3C/365WdkMfsHYBkhNSW5PQrQfSsySZwedRCk+cHv
MIME-Version: 1.0
X-Received: by 2002:a92:d5d0:: with SMTP id d16mr465346ilq.223.1604028730168;
 Thu, 29 Oct 2020 20:32:10 -0700 (PDT)
Date:   Thu, 29 Oct 2020 20:32:10 -0700
In-Reply-To: <000000000000addbdd05ae6b39e8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000abdde905b2db0a11@google.com>
Subject: Re: INFO: rcu detected stall in ip_list_rcv
From:   syzbot <syzbot+14189f93c40e0e6b19cd@syzkaller.appspotmail.com>
To:     dhowells@redhat.com, fweisbec@gmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 16 12:21:14 2020 +0000

    afs: Fix cell removal

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164fdca8500000
start commit:   fb0155a0 Merge tag 'nfs-for-5.9-3' of git://git.linux-nfs...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=41b736b7ce1b3ea4
dashboard link: https://syzkaller.appspot.com/bug?extid=14189f93c40e0e6b19cd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12baea37900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172f27cf900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: afs: Fix cell removal

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
