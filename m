Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482B5185FFA
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 22:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgCOV0H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 15 Mar 2020 17:26:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48897 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgCOV0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 17:26:06 -0400
Received: by mail-il1-f197.google.com with SMTP id c12so12170462ilo.15
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 14:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=ObBVExDwk8OBYjYRj5UK3XQ8zrdTqTo9rbmRyh92cU0=;
        b=dYYun+pn9/Ec351+RLNgmUurV82MGMXq6Fow3jTFVdiPDwXcCHljp3/L2AWj03aoI8
         DJv8Elaz6UKq8iaIo2nTmJBcHd3pajZo9Im8PwoTIuq+Thxm44kLP9QQ7AXdoIySbac3
         r/JoPOo6M3b8zhh6YQt4knPk2s5gUcaQv00oF/Bekxhx8h8Iw4zgERy7exmRLifBJfuf
         U3uF/CW+7Tue/VP2b0KSLoggfA0HJYLV2DHfI8S32xt4u5BV+QDk4FVytqZ2zOs56NVb
         yaEe083u5oOzn5DSX+u+jnFPZfAq6oz5E+tO8ESjPTULWkV19w6XP1dcgJDeSU9+elib
         Rusw==
X-Gm-Message-State: ANhLgQ0qNMBduxCh+k0GdY+BDQwpVonSlUz1a0qT+2vtsgSL7Q9T5jV5
        apzE8+I8kS6rDcGCCRVrxy8+36waGP+3aAG5XUTeSkuWgyf2
X-Google-Smtp-Source: ADFU+vt4qJpj1JeI/CaGL1tH5qCsGjqSAlUF9zulnGe3k9qHg++O02+OAtSyUOSf2fVU7oTjSCFWtWERadBsDt0XUmGXBPeoxU6S
MIME-Version: 1.0
X-Received: by 2002:a92:d112:: with SMTP id a18mr12650691ilb.259.1584307564141;
 Sun, 15 Mar 2020 14:26:04 -0700 (PDT)
Date:   Sun, 15 Mar 2020 14:26:04 -0700
In-Reply-To: <000000000000f96400059c8ca8cd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009363ac05a0eb5940@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+c400f7b04cadb5df6ea7@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1163e0d3e00000
start commit:   4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=c400f7b04cadb5df6ea7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155af721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cfb79ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
