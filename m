Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F38811F6B5
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 07:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 01:52:05 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:42889 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfLOGwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 01:52:03 -0500
Received: by mail-il1-f200.google.com with SMTP id n79so3601745ilh.9
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 22:52:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=u5G1wrWjpZdsvluOyjyhr3hFBI3eS6YddfcUNsAZMTM=;
        b=LiQQ8f6Hx0RGkiA2T114O5T3neL0C3vYYra5ggEB7GrZG2EUbMOAztesdfZOH5+yiD
         XnfSSWvksJPqg4/g2ewVLvujdSkY+x+UThxJHKOG65+z7nqVO8oGCdfTlhiW2+5eDVmE
         6gAoFx0BEKp+TjKwBLKIbF34f5Td6KzGFCZexDPIz7PDlZ9aZCizTm39NAJypTBaYxJU
         ok3Zf5HjuP4/8OqsMeuRr+OInFj1eTxupY9MhgQl1QHOzxbETqBuCSxk08dGr4+JJm3k
         pWXXjInVE7GtFQLrE4DUBSOgd8CT78lQl/hVnLNegNHb5qpZazAvwNWPBKpp9LRL58p5
         DJBA==
X-Gm-Message-State: APjAAAX43tkJrqQQq5Il5DYJK9qqyLxd8UZGWeuivge8gFR+xU7nk+7S
        6FHuIgKhuUC1CG+DIYoqjNaPlR6iXj137xdrkenHdZ1yNQuf
X-Google-Smtp-Source: APXvYqxyLGjpjTN0mObYvpOtmBDQtr6uJ7PwrSM6L61lcM5UPHprWuZJancgeOdVtUb3P1pj0JRYbD3+nDwIa7kKTYXjQFKUuwTE
MIME-Version: 1.0
X-Received: by 2002:a92:3b98:: with SMTP id n24mr7262387ilh.189.1576392721076;
 Sat, 14 Dec 2019 22:52:01 -0800 (PST)
Date:   Sat, 14 Dec 2019 22:52:01 -0800
In-Reply-To: <20191215063020.GA11512@mit.edu>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002a99070599b888dd@google.com>
Subject: Re: KASAN: use-after-free Read in ext4_xattr_set_entry (2)
From:   syzbot <syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com>
To:     a@unstable.cc, adilger.kernel@dilger.ca, afd@ti.com,
        b.a.t.m.a.n@lists.open-mesh.org, chris@lapa.com.au,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pali.rohar@gmail.com, sre@kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com

Tested on:

commit:         dfdeeb41 Merge branch 'tt/misc' into dev
git tree:        
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=be3b077056d26622
dashboard link: https://syzkaller.appspot.com/bug?extid=4a39a025912b265cacef
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11b02546e00000

Note: testing is done by a robot and is best-effort only.
