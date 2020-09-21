Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22F327269B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgIUOGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:06:10 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:55541 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgIUOGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:06:10 -0400
Received: by mail-il1-f206.google.com with SMTP id i12so4518020ill.22
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zoLX7gky58ekszpTA+zctgvOnx7l72/YhY5l3/zaOH0=;
        b=ltifCkePUH0aSdA9YRkOSwOD/8qE0fNteNbeAwnEBg2fPaMSsgvEyl86M4TMgpj704
         gyRTzKSm/4U+ZCsPHs8KF4FzhIafjLnNJjA/YslMzvgvuf1aw/PWcPl4pw2P+rpCci7R
         OEy7fSBnQWnbnuEA4OQxXqhclbFIDfq6z5q2ywNkNAHauIw2adlovrprQjnu3xZs5fQd
         TIrdg+cYIalZdHCLGb/JEWxcFUvh2WPRng0x1mzQdkA2jzCOWTZp4t857JW+w4UFOPE8
         JeJ/bxY9sbFckeaUVvq6W2li1T5cyEVLpx+qLNliXSNTfFgOtyKcCYvGe6MFlRNj+/Wn
         9p8w==
X-Gm-Message-State: AOAM533Ju649mkPNIf4W76TMsuJJqaSCdIUqf9lZ+Dr6UvdzK4EZjAli
        /kglGl4BeDdvFCfFV8wb2MNzoqJMk/m72FOFJqh65maV3YMZ
X-Google-Smtp-Source: ABdhPJzzJPaQez24SwlyAPkieJHMX5Z4SiJLFgIX2+OPmF1xDAkrJvu+v6xUaCJUP2uWBpFFF3tZRQ/AEtmSH3wHuyRVeCRHglGh
MIME-Version: 1.0
X-Received: by 2002:a92:c7a2:: with SMTP id f2mr17628ilk.171.1600697169599;
 Mon, 21 Sep 2020 07:06:09 -0700 (PDT)
Date:   Mon, 21 Sep 2020 07:06:09 -0700
In-Reply-To: <000000000000fb6bf305afcfca61@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fe19f05afd35a45@google.com>
Subject: Re: WARNING: suspicious RCU usage in bond_ipsec_add_sa (2)
From:   syzbot <syzbot+11dcfe6879155fbb6a4e@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        jarod@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit a3b658cfb66497525278cbf852913a04dbaae992
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jun 30 18:49:41 2020 +0000

    bonding: allow xfrm offload setup post-module-load

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11eb70d3900000
start commit:   f13d783a MAINTAINERS: Update ibmveth maintainer
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13eb70d3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15eb70d3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=11dcfe6879155fbb6a4e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17588ec5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13db3281900000

Reported-by: syzbot+11dcfe6879155fbb6a4e@syzkaller.appspotmail.com
Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
