Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288D613D82F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 05:49:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:54443 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgAPKtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 05:49:02 -0500
Received: by mail-il1-f200.google.com with SMTP id t4so15676831ili.21
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 02:49:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vXf7A0NOmOYnzFvw+i/lGTeJq016329/QakV55aUcG0=;
        b=i7pqX6V4TW/4qGB+nJnhVWBitVx0xKQDnCOH9FB91GtYgX4BV7jeSTFsluXedM/rh8
         Wd1o+BHtk51720PQlocF0s/UWPD8FI6r78wBFb92W2O0yMSYVXey8Rlj8A7as1S8uf0/
         nGVVXWq2BYvDPG561eO+o3MT2r5cLeGQpPhrXB7eWp0W1bsyIkF7rRw+VPOV+j68BhO2
         oEN9Q8scyD9a1miBK9xBZyeC3XSs1kOm/G8iGjKfMn5hfpDjJ3vbu5xwenPh2PTzFeNV
         axXZ3R495OxD4UZrQDLjshUHInmuP4sy928GxbrCvdTuqjtR8aHU5hKaYSHGx4OlVLkw
         Mgag==
X-Gm-Message-State: APjAAAXvQ8SG/ne1J374ktYGBiKQJw3zrWEv3KFYShWIQDBqTk5HdyEb
        14YkR7qZ2KkLC2cW4UP/qHi4QgGNUYckFHCVjQZJc3ZqKWWp
X-Google-Smtp-Source: APXvYqxopJ/jpk1yIg/I62PmVhs8FXVnSYmF1TfUZ9VNvmnmuoElsGzQesNp8GprKQ9VNUmhiQEqsoJLXz2GyBosz3vGAuYabDoY
MIME-Version: 1.0
X-Received: by 2002:a92:3cd4:: with SMTP id j81mr3015923ilf.77.1579171741688;
 Thu, 16 Jan 2020 02:49:01 -0800 (PST)
Date:   Thu, 16 Jan 2020 02:49:01 -0800
In-Reply-To: <000000000000b9fc96059c36db9e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3ea0f059c3f9203@google.com>
Subject: Re: WARNING in nft_request_module
From:   syzbot <syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 452238e8d5ffd8b77f92387519513839d4ca7379
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Jul 11 11:45:10 2018 +0000

     netfilter: nf_tables: add and use helper for module autoload

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17bb83e1e00000
start commit:   51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=147b83e1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=107b83e1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=0e63ae76d117ae1c3a01
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b14421e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138473fee00000

Reported-by: syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Fixes: 452238e8d5ff ("netfilter: nf_tables: add and use helper for module  
autoload")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
