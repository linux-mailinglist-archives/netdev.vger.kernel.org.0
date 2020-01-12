Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313B013882B
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 21:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgALUNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 15:13:02 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36931 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733280AbgALUNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 15:13:01 -0500
Received: by mail-il1-f197.google.com with SMTP id l13so6432764ilj.4
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 12:13:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wSZwdREHh/ntl8Mv5tdng+7hV3BjjjHVSK0hr94al3E=;
        b=ltJn/J2LBceEseAq2CCe3416FGYGi2gM/Cghc08rYnvd+2JRT0Qjsf4uy/nwiw+/1O
         AHX3VbtrwaTaArfkn+nBgY2xIZGQwfs6Qn1JN3+p+IwnCR4AsKXqcwH++/qmV/3IJBnM
         ArBybozAnwFtKI1iwPegCRUWsIeHGhf24kLp3Q45QaYR3jMAsHpR9oU58L8BCSDFhl12
         sm1RiPcwDbiJ8Plddmw/KnlN8UoyYGKVohJy0O97K+21NOzBpQOQHMe9o+l+tmeeS1ad
         nWhjxtKOm+oJf7/z+FHG715F9ZcpNs2Gxhv9i3RzrEyY+PIuRc78/ciXBjemTOMu5HoP
         SRWA==
X-Gm-Message-State: APjAAAUtXUYbh5OwhGPV9Rhal61FY+Yyz7Vq9EAMETnan3v2+nknTimI
        F4fck6w+7zSQ1Fh5O6i11LpS/35hRFFDg7+vqqUJ4JbrnN7S
X-Google-Smtp-Source: APXvYqysv5E1t8WrfxtjWbC+uwQ/9OlRxhNSPyvPDsydc1sPB0QD741bCxjYAsJLKOy90RBDJm5/NfigIYFyDkKVs3CU0i6ItP1R
MIME-Version: 1.0
X-Received: by 2002:a92:da44:: with SMTP id p4mr12562216ilq.168.1578859980942;
 Sun, 12 Jan 2020 12:13:00 -0800 (PST)
Date:   Sun, 12 Jan 2020 12:13:00 -0800
In-Reply-To: <000000000000af1c5b059be111e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005073ea059bf6fce1@google.com>
Subject: Re: general protection fault in xt_rateest_put
From:   syzbot <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 3427b2ab63faccafe774ea997fc2da7faf690c5a
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri Mar 2 02:58:38 2018 +0000

     netfilter: make xt_rateest hash table per net

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129b9c35e00000
start commit:   e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=119b9c35e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=169b9c35e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=91bdd8eece0f6629ec8b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13dbd58ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15eff9e1e00000

Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
Fixes: 3427b2ab63fa ("netfilter: make xt_rateest hash table per net")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
