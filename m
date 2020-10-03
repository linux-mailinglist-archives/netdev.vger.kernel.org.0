Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADBB28241E
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 14:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgJCMpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 08:45:09 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:35969 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgJCMpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 08:45:08 -0400
Received: by mail-io1-f78.google.com with SMTP id q126so2668584iof.3
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 05:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=O/u2fqyXLK0YS4cdPeK1MlCoIRulDbI3uMHYLDBM+gE=;
        b=lBcWN/E68MGsLc7EVgNM0NymzlI6AyRSIerK7Vx5QwxG6PAwdTqKB9yJmU8X0xTrSm
         9Dr/qNhj3xikCwB0GucKoJSCHru8V4ZH8vEDT0XW1SIt56hZ9yPedngLHNnrD1BMck5o
         PmHnIm/NTb6M/NDqwyMaCDkYA7X6x204qlsLAcB2o3Md48vxeCJq07FV9ELUmEU7IqBR
         I2l+vqFmncBTr8nmiORVSUlAahEOerBg8VkfFSAqhLsoLlYgV0lPIUOfxCywkDSFXcEm
         /61MkXeTTlM4sMKBGzKn4JndSNzN5/bQWNSxTvdX4h6BtkwCNwypEWS5jAFmvNhAh5Ct
         crDg==
X-Gm-Message-State: AOAM532u+tRzHcE18P3rpmCxU7M7HcmtAVfQLeHVxfOngoEJN77xDrN6
        iBZeDrJaRfQoRj2qZet6euxS0CJsvdws4YfN0sN+Lki2sT5V
X-Google-Smtp-Source: ABdhPJyRz/A5CvPNMT52s8+m2dfKNAHR+kvMHdTA8FDr9QHOAF5bCyv1hMFXDVTQUR3nCvvebSNewG0c6aM/CU6AfigENWeZaUPi
MIME-Version: 1.0
X-Received: by 2002:a5e:8516:: with SMTP id i22mr2945386ioj.93.1601729107907;
 Sat, 03 Oct 2020 05:45:07 -0700 (PDT)
Date:   Sat, 03 Oct 2020 05:45:07 -0700
In-Reply-To: <000000000000fa10d905b0b1eb89@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080daf705b0c39e95@google.com>
Subject: Re: WARNING in drv_bss_info_changed
From:   syzbot <syzbot+4cf3e4e092f2f4120a52@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, g.nault@alphalink.fr,
        johannes@sipsolutions.net, ktkhai@virtuozzo.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 489b30b53f0540b9f8e391cbb2839cea48b5d1c1
Author: Kirill Tkhai <ktkhai@virtuozzo.com>
Date:   Thu Mar 15 09:10:57 2018 +0000

    net: Convert l2tp_net_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175b598f900000
start commit:   fcadab74 Merge tag 'drm-fixes-2020-10-01-1' of git://anong..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14db598f900000
console output: https://syzkaller.appspot.com/x/log.txt?x=10db598f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=4cf3e4e092f2f4120a52
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145eb667900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15422c1f900000

Reported-by: syzbot+4cf3e4e092f2f4120a52@syzkaller.appspotmail.com
Fixes: 489b30b53f05 ("net: Convert l2tp_net_ops")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
