Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1E25C11
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 05:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfEVDQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 23:16:02 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:37302 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbfEVDQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 23:16:02 -0400
Received: by mail-it1-f198.google.com with SMTP id n10so828035ita.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 20:16:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3nIzlGw+4wszd7mCGI8udFQIKx5mXZuEZdlx7TUEr8s=;
        b=nxDHLa46zr7nlDsoQ4fKguI+jTRBdptr1djV5+TTW7PEXJf+hQm9TVPfloJdV1KPQ4
         01kQyy5aeHoat7FUgjXChRVonAsPP0ScwMSzyLw3GjkAVEDaqwBSoJAcoAQGDPQRyNSP
         t2BQskslYq87VauXgvRaWsAqz1/5+iz9thRodu3lZ5QxtqdUwUxyMJQiU9p0+jxP9Prm
         0ER9h3uqMnacur/hl9Ccch7F1dZonDiM7KnIXENmrnsW0EUg9ekeX4CR0bY1N0x4bn4o
         n4ZEAM57jT63jm4a1bqCVFTdj233I8OjtgSBCeBr18BrPRT7QGppduBsCJYrUEX1IZeM
         wCkA==
X-Gm-Message-State: APjAAAWEQRhIBlnrLHZqiM8B7p6Ccn2q9R+NIG9A50mFPhdYd3U0I0zv
        1FdqsqfA5+LJeBkksnDev9voiKnA56OAkJA9U9/aEA7QgFEb
X-Google-Smtp-Source: APXvYqxp+o+WQM7bTF4SCjOC36sALTlwx1QmJGZsN4sPxGpKCkBFjyv3EMuUBqqVKn8wzyZnUI3z37a7vKmMtQ7mfrLWFQqBAHmU
MIME-Version: 1.0
X-Received: by 2002:a5d:9d4f:: with SMTP id k15mr7079076iok.100.1558494961163;
 Tue, 21 May 2019 20:16:01 -0700 (PDT)
Date:   Tue, 21 May 2019 20:16:01 -0700
In-Reply-To: <00000000000033a0120588fac894@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008b645c058971629b@google.com>
Subject: Re: WARNING: locking bug in inet_autobind
From:   syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>
To:     Yong.Zhao@amd.com, airlied@linux.ie, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.koenig@amd.com, daniel@ffwll.ch, daniel@iogearbox.net,
        davem@davemloft.net, david1.zhou@amd.com,
        dri-devel@lists.freedesktop.org, evan.quan@amd.com,
        felix.kuehling@amd.com, harry.wentland@amd.com, kafai@fb.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ozeng@amd.com, ray.huang@amd.com,
        rex.zhu@amd.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yong.zhao@amd.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit c0d9271ecbd891cdeb0fad1edcdd99ee717a655f
Author: Yong Zhao <Yong.Zhao@amd.com>
Date:   Fri Feb 1 23:36:21 2019 +0000

     drm/amdgpu: Delete user queue doorbell variables

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1433ece4a00000
start commit:   f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1633ece4a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1233ece4a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163731f8a00000

Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
Fixes: c0d9271ecbd8 ("drm/amdgpu: Delete user queue doorbell variables")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
