Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F828208C
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgJCCdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:33:06 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:41482 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJCCdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:33:06 -0400
Received: by mail-il1-f207.google.com with SMTP id f10so2578397ilj.8
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 19:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=huAQ2XNxNk0+JP0caungu+yrhrmWz2OAWIUz9RtSlI4=;
        b=RHxggjXh/gX6ebbd2Du3NGogqUrRjDkh7kDCK2sGhrJnRNy6XcnGhEKa0nfv50/0QD
         f9AUQHj4MWQwNGLSGhC8s0QLvxQNXPYIVB+nCLwK72kmKMgKgqfctqiNGjBcxVu8c8pP
         MFgXMy0cBGMbOFQgAM1ZxOIliNCGPWK5ReJ7CGoIAM0ilFd6XSzS3L9QanJBuNtUQgy7
         mr0mJuNk9fLHXH4uFMMDkM/SYeBgsiUbE5futITiMciO3eFjNNTpv853QTVCu7whNDie
         dZQaOd3LU63XYYqlj/xcsIpphhiaaOH7NfD/t3ye5oxi1+tIsNkpmrdPiSLu6bKgVXp1
         WRzg==
X-Gm-Message-State: AOAM532F+W5/DIMFKz4ADO0w2rvv82NdFyjvaTFSyXHO5Yr74eV6L75T
        D2En4v7b4rAveiHxEmH4gP5wkMrboh7atPS+Tmz2dZwlcpR3
X-Google-Smtp-Source: ABdhPJzrlAP5imDWEPKyVGiLnhg0plpe3Pjdz0K8YSADKul87MvIbS1OPbnv7c/HZQJfp1argFlx9wEiLJU/BiWVN/BRncyNJ03n
MIME-Version: 1.0
X-Received: by 2002:a02:5d85:: with SMTP id w127mr4693509jaa.76.1601692385603;
 Fri, 02 Oct 2020 19:33:05 -0700 (PDT)
Date:   Fri, 02 Oct 2020 19:33:05 -0700
In-Reply-To: <000000000000ed022605b0b1efaa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aef3fc05b0bb11ce@google.com>
Subject: Re: WARNING in ieee80211_bss_info_change_notify
From:   syzbot <syzbot+09d1cd2f71e6dd3bfd2c@syzkaller.appspotmail.com>
To:     airlied@linux.ie, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, christian.koenig@amd.com,
        davem@davemloft.net, dieter@nuetzel-hh.de,
        dri-devel@lists.freedesktop.org, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 135f971181d779c96ff3725c1a350a721785cc66
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Mon Nov 20 22:49:53 2017 +0000

    drm/amdgpu: don't skip attributes when powerplay is enabled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=120f55bd900000
start commit:   fcadab74 Merge tag 'drm-fixes-2020-10-01-1' of git://anong..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=110f55bd900000
console output: https://syzkaller.appspot.com/x/log.txt?x=160f55bd900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e672827d2ffab1f
dashboard link: https://syzkaller.appspot.com/bug?extid=09d1cd2f71e6dd3bfd2c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161112eb900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124fc533900000

Reported-by: syzbot+09d1cd2f71e6dd3bfd2c@syzkaller.appspotmail.com
Fixes: 135f971181d7 ("drm/amdgpu: don't skip attributes when powerplay is enabled")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
