Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC671643A5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 12:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgBSLsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 06:48:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:35022 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgBSLsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 06:48:04 -0500
Received: by mail-io1-f72.google.com with SMTP id x10so16046971iob.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 03:48:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iFEJQOMtOjLaubYnrYBmTyyXPvifqApU2+AIOGRL/ps=;
        b=nz4qDJliP6Pzw4ki8cIKW7pBCpmhr12e+qdSahc5UC3RFPfjnFm2vU6yRNpuW18sZI
         jgSobphRj38l1H7R5/4e2gCjeOjX4oJAmrpMEmWips0atBLnhOenRsDuArH4eAzA9nAW
         3VByZUAq+V/21rHBzdJNCvbBMe02yCuO6ldpW2siHFJ53Xj9+M309z4yiiR7WCHTD70H
         up0xmWFR2poFjwdEXuJ8xKS+te9IfMnv+OIBOU0LyjA7zwNuSaGLLiB8bnIZu4PTJim9
         sbH7mxL4vjIyNbCL0eb370ORN6qx3PD2ART9RXNu5wSGVUAAAweRO4nSwj7ydNA8U+yz
         Oujg==
X-Gm-Message-State: APjAAAXUMlQcvM+C3AeatYBW8o44tcoKLdW3UXeHp6ZMGYmaKNCMCsO0
        mSbYi648cjCga90M17J+do90bsBuPC8EFLXvSDxQ1JfMJjC0
X-Google-Smtp-Source: APXvYqxh7CarR15T4+m7VXrE/hcg2w1fTkfp5+A8SYllXe1zZAmarJXWxG7Hr5Ioc75rV2X82K/lHy+Ydq55ycG0YTdRd8Xlj6tD
MIME-Version: 1.0
X-Received: by 2002:a92:601:: with SMTP id x1mr21808045ilg.35.1582112883122;
 Wed, 19 Feb 2020 03:48:03 -0800 (PST)
Date:   Wed, 19 Feb 2020 03:48:03 -0800
In-Reply-To: <000000000000ca89a80598db0ae5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064ab40059eec5c3e@google.com>
Subject: Re: general protection fault in gcmaes_crypt_by_sg (2)
From:   syzbot <syzbot+675c45cea768b3819803@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        hpa@zytor.com, jakub.kicinski@netronome.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit db885e66d268884dc72967279b7e84f522556abc
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Fri Jan 10 12:38:32 2020 +0000

    net/tls: fix async operation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16871de9e00000
start commit:   07c4b9e9 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=675c45cea768b3819803
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cb0056e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1374f5dee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/tls: fix async operation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
