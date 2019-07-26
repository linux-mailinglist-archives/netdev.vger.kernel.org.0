Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA5774F2
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 01:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGZX0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 19:26:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36006 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGZX0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 19:26:01 -0400
Received: by mail-io1-f72.google.com with SMTP id k21so60393725ioj.3
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 16:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jU9fP+7H8MVZejaHdG74+bs1E1cZqrGALTWcbghPSM4=;
        b=s0u45fIGtJPuNps9HCuK5r1Cj1nGY89X3lNLeccCIBntFGUzh4605/Wh/9x3WpowrU
         JenVU0iJt0WML0EeVXAJvyYxcnCUZo8/iq2Kv7a+TVSxuqFqcAMU7AuYspIwXeUxWa5b
         qfHV+FCfbwa621dxZkOhf+yPVWLXluaFV/qqXSQ7jxoQDSgDp3jr0sEORCiVr8P9/+WH
         D0Pk4/zi/Ra4pPktMmrRDeQ4lhHdnUOOGwxLbqOW5ru1xCyBbx5Xcx4V3vqh2eC4Z1Os
         NtoGif0qZ6Z4g6mQBBZX2uYeuK7Qx7lmjczmmAMEg9HVgRvgRSa617BWyN68O1R/tfPD
         0XMQ==
X-Gm-Message-State: APjAAAXcrCbeeRBYfjQIssZCi6+5VYxMeLnOCVE4zcj0esUS1cZOvLeG
        mlf3NRQv4Ee6g2v74dZnArU98i3DEyL77EWzMIAPH1ifZqO5
X-Google-Smtp-Source: APXvYqxovLmXIv75laVrMtZvlr79yeQWRntZAt1hwL6RBmKRhi84q3dBc8vJmpG72hkv1CJ8iH3NYbDZi9CnPAFhes4c6TPcq2Lv
MIME-Version: 1.0
X-Received: by 2002:a5e:d611:: with SMTP id w17mr24902658iom.63.1564183560976;
 Fri, 26 Jul 2019 16:26:00 -0700 (PDT)
Date:   Fri, 26 Jul 2019 16:26:00 -0700
In-Reply-To: <000000000000edcb3c058e6143d5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083ffc4058e9dddf0@google.com>
Subject: Re: memory leak in kobject_set_name_vargs (2)
From:   syzbot <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net, dvyukov@google.com,
        herbert@gondor.apana.org.au, kuznet@ms2.inr.ac.ru,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, luciano.coelho@intel.com,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0e034f5c4bc408c943f9c4a06244415d75d7108c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 18 18:51:25 2016 +0000

     iwlwifi: fix mis-merge that breaks the driver

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f955f0600000
start commit:   3bfe1fc4 Merge tag 'for-5.3/dm-changes-2' of git://git.ker..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12f955f0600000
console output: https://syzkaller.appspot.com/x/log.txt?x=14f955f0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcfc65ee492509c6
dashboard link: https://syzkaller.appspot.com/bug?extid=ad8ca40ecd77896d51e2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135cbed0600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14dd4e34600000

Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
Fixes: 0e034f5c4bc4 ("iwlwifi: fix mis-merge that breaks the driver")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
