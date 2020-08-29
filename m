Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01052569B3
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 20:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgH2SXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 14:23:14 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:33016 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbgH2SXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 14:23:09 -0400
Received: by mail-il1-f198.google.com with SMTP id b85so1816674ilg.0
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 11:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bPIxx1nU1y1vRAICXwgpqNsvENjqeAPVEB+JHRttykM=;
        b=UVWRCij4smxU41VeAZBqRwqL+XvmoxntQHCqRSEMrPQ6A07WBNxckRPCwG5La5BKRh
         dFqSql5LCk6bAu1dT7h047kbIETjRMqNVvGT4lf+EnAtZmN2afsoW5Swt2zRfwQTmpNR
         LnXhFvIXEvianJrU+EkS0K/AHW5ORpubaQxt09qNCIGXXWmMaHoQ/0arSro7x/aewtkR
         dlf+ZWt07n517lp9J+e6VI1p8qPw5WMg8MOl/Y0cFhXsAoHYUGuPzSRTaEtuvnPVsxW8
         u1/gkc0emUJ191hg9NW4kMkYZln5dXMv1TbJRV5qqYQvs3l5vpHbntuA+hZznmtcMOkl
         wYcg==
X-Gm-Message-State: AOAM530yM1cYfsc7MqnuWI4fjbmB90UylIETGwcyRiZLu0j+flP4zIPw
        y1Ffx8rIugtkQOg/apMakkSyZpHsfCcCMVL7HI2OCAN78nfH
X-Google-Smtp-Source: ABdhPJxEVVgA7Ub0bc+MvFmjZc1/RLEdJoez91edkd/s46zbbgIIdHjRz0Wm+HGP+LJ67kuMQWaAkopVRrwprhGvW720EhjW9N/v
MIME-Version: 1.0
X-Received: by 2002:a92:d1c4:: with SMTP id u4mr3401246ilg.295.1598725387974;
 Sat, 29 Aug 2020 11:23:07 -0700 (PDT)
Date:   Sat, 29 Aug 2020 11:23:07 -0700
In-Reply-To: <000000000000d3d67f05a20d2027@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8002705ae084273@google.com>
Subject: Re: INFO: task hung in tls_sk_proto_close
From:   syzbot <syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com>
To:     a@unstable.cc, aviadye@mellanox.com, aviadye@nvidia.com,
        b.a.t.m.a.n@lists.open-mesh.org, borisp@mellanox.com,
        borisp@nvidia.com, daniel@iogearbox.net, davem@davemloft.net,
        idosch@mellanox.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, petrm@mellanox.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 02d21b59d5cc4b4b395bbc2a29319b8a529ebeff
Author: Ido Schimmel <idosch@mellanox.com>
Date:   Wed Jan 23 14:32:59 2019 +0000

    mlxsw: spectrum_nve: Enable VXLAN on Spectrum-2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e89b05900000
start commit:   5438dd45 net_sched: fix error path in red_init()
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e89b05900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e89b05900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=ca1345cca66556f3d79b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14acdfe5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1792598e900000

Reported-by: syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com
Fixes: 02d21b59d5cc ("mlxsw: spectrum_nve: Enable VXLAN on Spectrum-2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
