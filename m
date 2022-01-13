Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF71248DDFF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 20:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbiAMTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 14:04:08 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:33484 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiAMTEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 14:04:08 -0500
Received: by mail-io1-f70.google.com with SMTP id 1-20020a6b1401000000b00606855cff36so2604227iou.0
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 11:04:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YnXlPLzLOeSu5XTDUNqCJDVyX7wesve914JTiyKl2c4=;
        b=ZX6+b5fN1wtN4Tj30yDcP3/IiUbUN69/wu5RorjnVTor8ctJdyzNOti5JeKteREeLD
         t8361fzxljMuZl9XQwYpZpCfOtnRR+mvdvvVjkj3cLzRHO7v6q9Y4NBQPEqHzlEbcf9m
         q9ft32ISMkdW0wR7wKaUgzHM4dsgrtP1TSYvV3IBvhg3ZXmOfjO3Y6qsCMZ//kDFfHXN
         1fuWg+vyOjNTZEp1i24LDmBA4/v9ELxpT4knN/6aaZ0UbHQQCMIdzGrAFHOcjmhmfoWh
         b5e/aobve0nmyHbeMrQbcCQhb7eNpmMPj282sUNJR1ksEoPrMK3PDKv+FUSs1LnT4tNy
         F8lg==
X-Gm-Message-State: AOAM531462RwpPXith9W+PeKSC45woW8weYIOTEnZ3kdsNUhwOPdSpI/
        xeMg0AejKlBcfoQHn29hnXSbV34qIvvJaUnUSj1zSYpzGmMg
X-Google-Smtp-Source: ABdhPJwzwAgBJut9x8nUk1XqzpsbqJ8B/iN04mKahNLszI9mA7kZUC437wbqHYrvmU0vdte769zywTMaAUDIiNFjNKyGoNX0UYW1
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d08:: with SMTP id c8mr2857216iow.199.1642100647552;
 Thu, 13 Jan 2022 11:04:07 -0800 (PST)
Date:   Thu, 13 Jan 2022 11:04:07 -0800
In-Reply-To: <00000000000086205205b0fff8b2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c86f9d05d57b594d@google.com>
Subject: Re: [syzbot] general protection fault in ieee80211_chanctx_num_assigned
From:   syzbot <syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com>
To:     arunkumar@space-mep.com, davem@davemloft.net,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2
Author: Nguyen Dinh Phi <phind.uet@gmail.com>
Date:   Wed Oct 27 17:37:22 2021 +0000

    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16afe84bb00000
start commit:   7f75285ca572 Merge tag 'for-5.12/dm-fixes-3' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
dashboard link: https://syzkaller.appspot.com/bug?extid=00ce7332120071df39b1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1393cbf9d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1238ba29d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
