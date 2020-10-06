Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3188F284B69
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgJFMLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:11:07 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:55796 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgJFMLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:11:07 -0400
Received: by mail-il1-f205.google.com with SMTP id 9so9169114ile.22
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 05:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EhCOsm/XwK9KhdukuQOyPPhHwiTYn0fSo6dMXBzIANg=;
        b=bj2NOJchpyVsSG2YL1AucjrlfMtJNveJsWLz1SsPlKtMaxVHv964fUZVKlznZHIAWq
         JjX7YbeoEHQoeba1/yy10akb1aaGy4iD8l7/o8RXAFM3oIfOHDT6XVItQYiJLBNhq5Ne
         LbTJd5UvFt3nTZpq4ZMbQ/v/AxobdJRJDO/g8EOLEj60wP0zhBMpGqo6l4FtmkHcPKm0
         LKr3fbEFfWbbQ+pZK4hQEMf4cwhVhjWg2RG6Jk3w0iI2UYxo0BvFvhdPwxUF4HanGWca
         FmAJQ0z0RtK4nD2N1YTTWbDUUM+2ejrKzSxK95cVjRYu9VAa+4C0C/gZQQhXF2XhxcIM
         bBlg==
X-Gm-Message-State: AOAM530y2U8fIrbqaef471UVUjzmRERAT9eNSEsUhJRBxelEowutpsx7
        a1Xo77FQxaR7jyQVjz0f9Zmj3Pt7Z3u7Uain59vuaaFHqGXa
X-Google-Smtp-Source: ABdhPJw+2KHWj8oxMC2Me2es2RQkss+2IPVOYHE5N1uYrNZ/tX99ER7MjGnPIDOC6uyhLER6SZk8Yb5UPmwHtKfBCzr0BFKu+SWq
MIME-Version: 1.0
X-Received: by 2002:a92:9fcc:: with SMTP id z73mr3339261ilk.234.1601986266354;
 Tue, 06 Oct 2020 05:11:06 -0700 (PDT)
Date:   Tue, 06 Oct 2020 05:11:06 -0700
In-Reply-To: <0000000000005f92b905b0fc1a5d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000575a2e05b0ff7e79@google.com>
Subject: Re: WARNING in ieee80211_check_rate_mask
From:   syzbot <syzbot+be0e03ca215b06199629@syzkaller.appspotmail.com>
To:     blogic@openwrt.org, clang-built-linux@googlegroups.com,
        coreteam@netfilter.org, davem@davemloft.net,
        johannes@sipsolutions.net, kaber@trash.net,
        kadlec@blackhole.kfki.hu, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        matthias.bgg@gmail.com, natechancellor@gmail.com, nbd@openwrt.org,
        ndesaulniers@google.com, nelson.chang@mediatek.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 983e1a6c95abf8058d26149a928578b720c77bce
Author: Nelson Chang <nelson.chang@mediatek.com>
Date:   Thu Oct 6 11:44:02 2016 +0000

    net: ethernet: mediatek: get hw lro capability by the chip id instead of by the dtsi

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1639e0d0500000
start commit:   c2568c8c Merge branch 'net-Constify-struct-genl_small_ops'
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1539e0d0500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1139e0d0500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1e6c5266df853ae
dashboard link: https://syzkaller.appspot.com/bug?extid=be0e03ca215b06199629
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1790e83b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111a5bc7900000

Reported-by: syzbot+be0e03ca215b06199629@syzkaller.appspotmail.com
Fixes: 983e1a6c95ab ("net: ethernet: mediatek: get hw lro capability by the chip id instead of by the dtsi")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
