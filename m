Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F603A0506
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 22:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhFHUTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 16:19:00 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42913 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhFHUS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 16:18:58 -0400
Received: by mail-il1-f200.google.com with SMTP id d17-20020a9236110000b02901cf25fcfdcdso15969419ila.9
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 13:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ezcyOkSc0C4ne5wy7XpBhvdu2J9JnoNW6BAbB6EkXRc=;
        b=MZKZNyqWHsEqOw1HRDZ+wg7XMJhwpYy7oq/M0C8CmEt3kf5jMi/25POR7Ooq8AgEXE
         /0xAZJHt/jBANeInQCbA+TSoD/VDlj+Fhgcc+z8kyrA/QOcvhZc54g6QrbYhW6+QlJES
         IvRtBhTniNXs2G2GZS5vSBRPMfeui/g59a0cZJA/Jw44It2/ABSNxWEpLaYUsxl+sUbV
         gC55cyScUBKf+XP4j0BJPhrRBCcn7YvD8RuO41vEIAXNouTQVxO8iT2D6rfVk42ohv8A
         yhmmEHQTTnfClzM6zaE6VvkCsB5E/I3FILRB6kJ3S8BW1bmUoVd6AnwjUfI8zJDL5Mvc
         vXpg==
X-Gm-Message-State: AOAM532ayAmIy3KX1AHu0UneMmNaBTq1sJbDnC4UKGJvvfKr7dfPo1Nn
        xyiKovWLipN+MK2xQ1sH+R1e90Qjyn+Dd2mX1ORGKrPklIhZ
X-Google-Smtp-Source: ABdhPJxlFMepmJqj21LizbIi4meiP0zBRDHteG4KDW9m2NIZ7zZsorrU0kycxV5pId0oKOs6apRSk7sZWFPXjDKQYU6iZDZS5LBV
MIME-Version: 1.0
X-Received: by 2002:a92:d1c3:: with SMTP id u3mr22045702ilg.190.1623183425148;
 Tue, 08 Jun 2021 13:17:05 -0700 (PDT)
Date:   Tue, 08 Jun 2021 13:17:05 -0700
In-Reply-To: <000000000000f6d80505abb42b60@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000761c0e05c446d750@google.com>
Subject: Re: [syzbot] WARNING in cancel_delayed_work
From:   syzbot <syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, johan.hedberg@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kadlec@netfilter.org, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140478ffd00000
start commit:   c3d8f220 Merge tag 'kbuild-fixes-v5.9' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb68b9e8a8cc842f
dashboard link: https://syzkaller.appspot.com/bug?extid=35e70efb794757d7e175
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f6602e900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1203cc61900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
