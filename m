Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DAE1477C1
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 05:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgAXEzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 23:55:02 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:33979 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgAXEzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 23:55:01 -0500
Received: by mail-il1-f197.google.com with SMTP id l13so672210ils.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 20:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wqIW1GSh96dKBLUXIwcBCdzQGnE7BxtkVO3LYYJlVQE=;
        b=cNyKUMYd1pTa5K6+I5NgaRR87bacM51d4DDTLT9M3sabOLawNY4n2uJeJQT5nMhKrV
         TobdL0DiyN3d6AdwDfvvHh3sBsASxmEfmf8irNJSWiwppofR6tMOLCp7Rgtme42Zbak+
         nnsOwb4EJIydDVf2qoM6s494bT3dFsf4gvNhwKcNsBjlFzLh9aMaMEaoTxyMfE37S341
         VJcOvtm2Lo+CTWvLte7BNPKgq+ioI3/lnPd7NylGQsR0F18Pkq8z32UtNOJhAC7W6W88
         SE/V4p/T4X6S8Qn9kodP9+ultLEDcTt5bVFNGu1NIqfmwvr/NrHIdH/8l+ZwJfuMx1G1
         iIXg==
X-Gm-Message-State: APjAAAXYoa/mqB+iprApQYdTYkHjW93Jf2kpJhK8zeZsTye/BHFv0z+T
        /IjRArmx+xtEtqSobeXHRSdCbzRC/utrlsN5FUZqhw1ybq3g
X-Google-Smtp-Source: APXvYqxrBcPP1lod4jQ5x9Z+3r0zQv4PBuVpX/irM3rH1cFEkIinSrYxZh5p5QiT0thS8XZ7XZ8TETunB7YSrXzC5GGeknq9swin
MIME-Version: 1.0
X-Received: by 2002:a92:7903:: with SMTP id u3mr1546730ilc.254.1579841700988;
 Thu, 23 Jan 2020 20:55:00 -0800 (PST)
Date:   Thu, 23 Jan 2020 20:55:00 -0800
In-Reply-To: <000000000000204b4d059cd6d766@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000638fae059cdb8fe8@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_destroy
From:   syzbot <syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17d0c611e00000
start commit:   131701c6 Merge tag 'leds-5.5-rc8' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1430c611e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1030c611e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=b96275fd6ad891076ced
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fba721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1339726ee00000

Reported-by: syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
