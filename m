Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4868514114B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgAQS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:57:40 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40513 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbgAQS5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:57:39 -0500
Received: by mail-il1-f199.google.com with SMTP id e4so19577406ilm.7
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 10:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0XaH1mXR999mQNU6K6YWrbLPoIkTydrY/Z5TzvdEIoo=;
        b=CVuOGJnlomihNMBYz0CEpfSaxR3oh0jTPVja0D+fL1CEh5kdUqmE3YiXBp571ZoayU
         AvIswjJps7NyFSguXZBpIpYFKlt+4xHW2rKMcDyiBFVA4UzXfmAzY8VlrytX9h73nwAO
         9hWpaIwMJj6N8D41j5HA31LFeR7fugmMwH4L6ZZ1trfrsgwTY1JhVz9npfd2lJ+twewP
         D6D47TEvEKaWvU+Dn95AeKI4cxT0/UO0klB2YStMH5svboU/2ffyfEoSNviuKseeN2gK
         mATYjkyBhjqYPyv+5/9nzzOlL0ZX8i9fuwhUHUgREuuvV79KyF+Rv2QfT50rMfI2oS+M
         xzPQ==
X-Gm-Message-State: APjAAAUbD6CmwhTCLurNh+oSmpmIArspj27OxpivQIns64Un2Fw4zldX
        RiG2EGyd5BvHhrGL2Y+PPC/3WE3l95cujve50McusvcGcgSF
X-Google-Smtp-Source: APXvYqwdJblA4HS+sQAcyDnaZpEyamvRHPNZVLzTjCRJ1fUtjR6kwtPkrmKO+XSfDHOH8bobb3s8OKTAC0ffD9Ym4OsrWFyRFSsI
MIME-Version: 1.0
X-Received: by 2002:a92:2907:: with SMTP id l7mr4151886ilg.140.1579287458817;
 Fri, 17 Jan 2020 10:57:38 -0800 (PST)
Date:   Fri, 17 Jan 2020 10:57:38 -0800
In-Reply-To: <00000000000074ed27059c33dedc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb2c4f059c5a8309@google.com>
Subject: Re: general protection fault in nft_chain_parse_hook
From:   syzbot <syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 98319cb9089844d76e65a6cce5bfbd165e698735
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jan 9 01:48:47 2018 +0000

     netfilter: nf_tables: get rid of struct nft_af_info abstraction

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d38159e00000
start commit:   f5ae2ea6 Fix built-in early-load Intel microcode alignment
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10338159e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d38159e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=156a04714799b1d480bc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a7e669e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11102356e00000

Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Fixes: 98319cb90898 ("netfilter: nf_tables: get rid of struct nft_af_info  
abstraction")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
