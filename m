Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3C82B89FD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 03:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgKSCHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 21:07:09 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:40207 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgKSCHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 21:07:08 -0500
Received: by mail-io1-f71.google.com with SMTP id c2so3164438ioq.7
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 18:07:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=C3VJue3RGqKKiz/dey+cwbB/cJZLcFnQvx6oQYKE/kA=;
        b=HKLGr6LSffenqYxV4S4ByRE++2RtARKkn3Tt6uL3dMq70jPcdhvaOG43BMU0dqwv4/
         APsKYzeBme8WmQKVRgPeZ1Plg8FRvGiu6DPm810hnlI/uoUZTkbr9SwhiPkyOz6y4Yr7
         ST/6M8XR5yfUWQ3sMSJo0uqLvoxZp8qshZN6o+gvgsoccsZXr97RFLpkqytkGdx0sxvb
         zg1yAqedYiR2+nXo9/IxAZACFVuUWcO8xIHeOUtxY/6eWcLj95CWik7plW489PKY51Tg
         IhaWoITg2tLGGUhnkL/j/E/QOj6ByMLYeR/pkhRgfc9FDKq0hs1iBVUCum/0dNzJFHYV
         VCmA==
X-Gm-Message-State: AOAM5337/qRjxyeX0KZkwU0ryfvJotQ+Yp6n+fKDvaEQbIhjNJjlt6dk
        K1LZYUvNBgjXe+JqyFwogAsZ4QGLobjimuqG/aGQaBD2OP1p
X-Google-Smtp-Source: ABdhPJwGnfqYhdSrWrWlFmOilVg/nbpNsCCtVfqEKKfBbwvtt+AtVgNH1kqI3lh4iC2puEfZ8izsr5iBAXYRKFBDRtB9wzApLcos
MIME-Version: 1.0
X-Received: by 2002:a92:6e0a:: with SMTP id j10mr3269284ilc.272.1605751627741;
 Wed, 18 Nov 2020 18:07:07 -0800 (PST)
Date:   Wed, 18 Nov 2020 18:07:07 -0800
In-Reply-To: <00000000000055348705b43c701d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e834e05b46c2f37@google.com>
Subject: Re: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+03110230a11411024147@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100c9c16500000
start commit:   0fa8ee0d Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=120c9c16500000
console output: https://syzkaller.appspot.com/x/log.txt?x=140c9c16500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75292221eb79ace2
dashboard link: https://syzkaller.appspot.com/bug?extid=03110230a11411024147
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1587f841500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ec0fe6500000

Reported-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
