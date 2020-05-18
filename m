Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5D51D7898
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgERM2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:28:07 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36041 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgERM2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:28:06 -0400
Received: by mail-il1-f199.google.com with SMTP id m9so2707765ili.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 05:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/UaoSKuEg7BgmQIEUODx1VNqxB3FUarTMqVlwdmdwdQ=;
        b=PJI53+3/kEgxTDaJC0iGg3nKEeIuBR+JpoNH8/zkGOJJ/jX28tdo06mNyeD1dRaGXP
         2AW841k6dpfN2yHIPLQVG8Iy0I12Jc89Fv3vxH1NowVbPYNwa24yMfKdS+WobqyWJXrv
         UrmYa1BaKYxCo3lHG+VKyABQMxb+hc3KZiVgOj1NdpP/VkZEgwldAJjsOtiXlo58Ev2P
         xo9y9cF9t9o+VHpOCnXl79+kh9ym8/6ITp8fcVajceTEC/fVEESNnhZkisfSNqHO1w8Y
         odtzEu+gSpQWsrp2bJyepJb1NsJc7b5btk6WlbjX5Okt9nccm371Ro6ZkB92BbimB8MZ
         Oyxg==
X-Gm-Message-State: AOAM533u/6aPMSml9jj3fOZkXaRyhemYbvtY/cLjPOnzqpfG6KYi/E/t
        4VYalWq6+tyi4IiwdP0dibeY5HetxZNWKXsVXUspYH+UacP5
X-Google-Smtp-Source: ABdhPJxkBXNmIdsvsy/8YA3Op0IoHRuKNDhs6dRsom9/LIy6f2/gjKuMzC0g8/WxId+iZPkY72GepOClyDlw7dzo+ODBcds/NPKb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:bc4:: with SMTP id g4mr13605771jad.55.1589804885154;
 Mon, 18 May 2020 05:28:05 -0700 (PDT)
Date:   Mon, 18 May 2020 05:28:05 -0700
In-Reply-To: <000000000000ada39605a5e71711@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071203205a5eb4b43@google.com>
Subject: Re: BUG: Bad rss-counter state (4)
From:   syzbot <syzbot+347e2331d03d06ab0224@syzkaller.appspotmail.com>
To:     a@unstable.cc, akpm@linux-foundation.org, ast@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        dvyukov@google.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mareklindner@neomailbox.ch, mingo@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0d8dd67be013727ae57645ecd3ea2c36365d7da8
Author: Song Liu <songliubraving@fb.com>
Date:   Wed Dec 6 22:45:14 2017 +0000

    perf/headers: Sync new perf_event.h with the tools/include/uapi version

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13240a02100000
start commit:   ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10a40a02100000
console output: https://syzkaller.appspot.com/x/log.txt?x=17240a02100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=347e2331d03d06ab0224
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d18e6e100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104170d6100000

Reported-by: syzbot+347e2331d03d06ab0224@syzkaller.appspotmail.com
Fixes: 0d8dd67be013 ("perf/headers: Sync new perf_event.h with the tools/include/uapi version")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
