Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C97185939
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCOCjU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 14 Mar 2020 22:39:20 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55011 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgCOCjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:39:19 -0400
Received: by mail-il1-f200.google.com with SMTP id m2so1456871ilb.21
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 19:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=j2SmXJOFlNVNX3IBInWb2HEJ3kFsGIlnIYBHVv47Fmg=;
        b=fFVdS3eQuW/sROR3R8Tdw1liVUvS/qBYRhkRIePoguHoZvGmt3EiVA09wtyGsFm+K9
         q00XBSptMKEm8iv9asuEWAgHLsR/iXzVIWyHkcwcvj4IlgZ35+Z3hm6ZvW1IF6387Lvz
         rAGUjdtV6EeO2+z+Q2KyCIGrEIwDJRjfhV5u7q1VlT56aClYSDyqa3/yCBeLx9B5Ms3r
         txqqtoel4zmih/4GM5/ZMLFK6sW46sAn5Id848ZTnfF4E0OVm4NqtnOudGkQ5QZz8H2G
         2io7BYR0Gcp+EqsTvl7rsvOoFJ3+z53VcXa8KJdxtKK+rTSyAxxsGwZAq/NmN+zZ3ZfQ
         a6lw==
X-Gm-Message-State: ANhLgQ1qfX3myhWNvnQYiim70QUsSUUdfC4a8eEFJxVXZiCbzDyC7wh0
        NizcVb2GZx44wOmLfU5p1zZxFHL+CojyUM9wIHpH+TmPgIO+
X-Google-Smtp-Source: ADFU+vuJBPZ1PMOOzQo98cA9c5gJcvaAaQ6f/LSVIdRh9X4dB9T+eheUju1sRb7NyyPU97BKERRNFdBNpuxA4sPOAFveN366df7X
MIME-Version: 1.0
X-Received: by 2002:a92:d842:: with SMTP id h2mr17075595ilq.34.1584191402876;
 Sat, 14 Mar 2020 06:10:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 06:10:02 -0700
In-Reply-To: <000000000000204b4d059cd6d766@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3278d05a0d04d97@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_destroy
From:   syzbot <syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org,
        dan.carpenter@oracle.com, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, hdanton@sina.com,
        jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106f42a9e00000
start commit:   131701c6 Merge tag 'leds-5.5-rc8' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=b96275fd6ad891076ced
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fba721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1339726ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
