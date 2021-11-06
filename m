Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B9E446EDA
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhKFQLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 12:11:49 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48096 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhKFQLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 12:11:48 -0400
Received: by mail-io1-f70.google.com with SMTP id x15-20020a056602160f00b005e1888842d5so8497294iow.14
        for <netdev@vger.kernel.org>; Sat, 06 Nov 2021 09:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QqpG2ujyFdtX1D/IpoTYH2d0pbAXhtWvdOKz8yZlSqY=;
        b=cPjR9v/g0NCvkaAl5dllEvxRHG5dAKHz/z9Ce7EVsmdYPuPEL2mH6J5IIXdrpnl2Eh
         W8Mj4Zu2PeIvFK+SAYPnuI+glkFH+o6sNYIKfWwCYWFBgSBgzfTzK9g3giyjmCoHqrys
         X031Cf7j+W8UEuFrobiZtMkukBD6bCnZfwzMGcTjggA2QWmlKOVAav0HWnmLUh/RUn9J
         A2IIEjUEM5ibYzcz+jTo7wnG6Zh1wFhABmFPLtTldJV/0TPZMAKUwLh29NMKTUxyggcR
         KgK+gj2uPScPHBLGJW/I/d7++xgoyXKGFbrMFr5+OW8pnPJZH1Vcj+02VN7lKx3KeeZE
         /OhA==
X-Gm-Message-State: AOAM530g/RNkWKWKkmD1QMFrhPhwjMlqOi+/AmzJzJ0p1EMi40+c9uVD
        OajgacHoRieMAiTDUXX4zoBX3x8DHfhiwnFQgxAThWJ1boiy
X-Google-Smtp-Source: ABdhPJxHYBDMptvTT4I2qhDfgHiUdhddkrynfcSDI3B1z2AnakIJrFjxx4QPg+lHcVYgeQ5RFvXq9fvxL+F3GjIkgNzT9+NqGh1L
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c95:: with SMTP id i21mr4894708iow.60.1636214946868;
 Sat, 06 Nov 2021 09:09:06 -0700 (PDT)
Date:   Sat, 06 Nov 2021 09:09:06 -0700
In-Reply-To: <0000000000004d87c705b00bcb0a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af312005d020fa29@google.com>
Subject: Re: [syzbot] WARNING in sta_info_insert_rcu
From:   syzbot <syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com>
To:     davem@davemloft.net, expedicao@bandup.com.br, hdanton@sina.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a6555f844549cd190eb060daef595f94d3de1582
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Fri Aug 27 14:42:30 2021 +0000

    mac80211: Drop frames from invalid MAC address in ad-hoc mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=103db432b00000
start commit:   7266f2030eb0 Merge tag 'pm-5.13-rc8' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=533cb04fad26afdb
dashboard link: https://syzkaller.appspot.com/bug?extid=ef4ca92d9d6f5ba2f880
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11be2fd0300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d85b14300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mac80211: Drop frames from invalid MAC address in ad-hoc mode

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
