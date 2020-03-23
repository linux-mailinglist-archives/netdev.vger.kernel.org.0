Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E102C18F2F4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgCWKjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:39:04 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48496 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbgCWKjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:39:04 -0400
Received: by mail-io1-f71.google.com with SMTP id b136so11297429iof.15
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=E3FbehYY8mAkOJJQcLvCMQ904m/hZIJiIkOCeXRTCwQ=;
        b=KbvBp9661kN7zENfommZkBQaxbhEfBbP6PLV5s6d9378q1dVmPV2RD79JSuQZePGbt
         ABaL4Dnh4UgnBfQCTvXt2wMGzMrfn6xelvdY3Dq6IM6BoEUhuNKKFlThSRneyb6AW+/W
         oUGclMtRS0muzpX/MMQP+Q0tZ0Paswl1BW5S8C15mJkwlP+rb866fYXkaaPh5qoMaUKo
         UOzzLMt9ulCg372HMECXv0naJ0n4TxdXJzes/ZOGP9SBN9aoroEXp+snaW21oqwMjurp
         gY8t7cpuS9YwoBauTioGq/Hf4yR2CsRVkzYX3CdweIfHwXQ71GuHvr0oAbPTg+RPRRb2
         RZ5w==
X-Gm-Message-State: ANhLgQ1/QyjI2gArZQJnHePhPvuueZu1DZpIjUMOHvKnHUxsVowE8Q1a
        o5MFWQrYiNiq2dJ/1i1+M7Eob6LXbUPZ+1oipPGHF+VcW/zj
X-Google-Smtp-Source: ADFU+vuCV647OHMwnKb02Ze7RBGdSa3A1fMxiZF+p+y1+XffxMam6T5V6B/LWpW4eBuh5XQ284LGQv6ZKqYyY6/0QzvRHGijREZz
MIME-Version: 1.0
X-Received: by 2002:a02:c85a:: with SMTP id r26mr20323367jao.74.1584959942803;
 Mon, 23 Mar 2020 03:39:02 -0700 (PDT)
Date:   Mon, 23 Mar 2020 03:39:02 -0700
In-Reply-To: <000000000000b6da7b059c8110c4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fc4c505a1833ed3@google.com>
Subject: Re: general protection fault in nf_flow_table_offload_setup
From:   syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit a7da92c2c8a1faf253a3b3e292fda6910deba540
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Feb 3 12:06:18 2020 +0000

    netfilter: flowtable: skip offload setup if disabled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1522646be00000
start commit:   0a44cac8 Merge tag 'dma-mapping-5.6' of git://git.infradea..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=31018567b8f0fc70
dashboard link: https://syzkaller.appspot.com/bug?extid=e93c1d9ae19a0236289c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126c7e09e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1208fdd9e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: flowtable: skip offload setup if disabled

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
