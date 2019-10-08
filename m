Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E7AD029E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbfJHVGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:06:01 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36525 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730720AbfJHVGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:06:01 -0400
Received: by mail-io1-f72.google.com with SMTP id g126so360450iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5OZYjJeBjxMldAqDjmUv3YST3sHnUbSp1FVhq0/E4ug=;
        b=p9OUwZy1fVwF8ga/rJHBi/fReiMTWUjqBQW+v++jxMZK1NcueTtt/nXz9PYFAgftej
         W8eeO4rsAS72j7Nk3YBnYwUukUC2fj5njxpeJMIIiYQXux9JxpPQk+M0XCFCJKTmAVZm
         jImkyeVH100+8zRmL0wrQT/RGJN4BBaZtJxGvxKP9pN3sNT3s4Azdbvz5gH+xniUG/CH
         p0PnHzGFbOToBwT8LaL4JQ71fFzYTvbF5VElhPNhiHq/hJTM361qbi3jAHMhLlbs9iHz
         tunPrAtl2MXoqlpnm5f4Tsrph7aSHQr8BfCzMdKw9Lpkjl436F6DFW3uWt3vf0VhTxLB
         A0XA==
X-Gm-Message-State: APjAAAXxb3SuMzmdIWDiElOog3FZa1og6fKK1cQiszeUfz3vBMmGNzWB
        INxUnDoGyc9JTKpttFFizEJlG2SUMWlDw1wHj764Yizx7d5B
X-Google-Smtp-Source: APXvYqxkpDR9xlwVvue+X5tARQuOgfz8PB0tweOP1gQoq32F203J0Jk/tAMzCvPLWK9XR3S5tVTZLE+JHE1dUP0S2f4Zh+UiKYbr
MIME-Version: 1.0
X-Received: by 2002:a6b:5a09:: with SMTP id o9mr180937iob.241.1570568760396;
 Tue, 08 Oct 2019 14:06:00 -0700 (PDT)
Date:   Tue, 08 Oct 2019 14:06:00 -0700
In-Reply-To: <000000000000c1e5e8059456a5bf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f13e105946c89e9@google.com>
Subject: Re: KASAN: use-after-free Read in tipc_udp_nl_dump_remoteip
From:   syzbot <syzbot+dbe02e13bcce52bcf182@syzkaller.appspotmail.com>
To:     Ying.Xue@windriver.com, davem@davemloft.net, jiri@mellanox.com,
        jon.maloy@ericsson.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 057af70713445fad2459aa348c9c2c4ecf7db938
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Sat Oct 5 18:04:39 2019 +0000

     net: tipc: have genetlink code to parse the attrs during dumpit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11675620e00000
start commit:   056ddc38 Merge branch 'stmmac-next'
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13675620e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15675620e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=dbe02e13bcce52bcf182
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137ecdfb600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15dd0d0b600000

Reported-by: syzbot+dbe02e13bcce52bcf182@syzkaller.appspotmail.com
Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs  
during dumpit")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
