Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA54A6EB6
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245211AbiBBK3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:29:09 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:33386 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiBBK3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:29:08 -0500
Received: by mail-il1-f200.google.com with SMTP id h9-20020a92d849000000b002bc4b7993fbso5722821ilq.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 02:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nEulIPpIJ+MIKD14q/kortqxkpNWNggKXQtSolinqdw=;
        b=3knwVjohTBw4tcv55MirVMXeHkayRp4LuVHM7f1qTTNfXoD31zptmoQpDLWu4Ra7Oe
         EvZYf2YOARSy8YOhUIikn0bvQ1g8DVUh3/UBgqLPzAWFaGsEtNwxk83H+ijRXvC9Rrpk
         k0003LdAcBcJXNdfFW2FqwzuJYuEDf6cHrlLU8sNazFJzdTKOXJgLYaYH5xEQQw665+u
         swR2V+EVcN0MXlftuHSrUlgeweWeDX7R8JWTunjIsXopIUmytXhIfLHD/oa23LQHPnL2
         fFtvhbzW+7MdGEngguMbU0QLs4wU5pioIV7qsVep2i2wtJN84C0qffr5ZKdXjADy6W7W
         G3Nw==
X-Gm-Message-State: AOAM533QVHEvYd3GZ91/iUt8LJhpmRxvBQCfJMEX/FMmnMgqiZWNsbpR
        D99aI5gGL/VRK3tubcHe7Qz1y3AiHAaqaSylSNy779xvLUyk
X-Google-Smtp-Source: ABdhPJzkYKK7JWamarEhzKL/vOzo/telIDI1MWTjw59pYJDk7c8XLo1kA18YrsLryANpisSQxWWE+eViXhx+8NgcJcbf+FdgRNEC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c23:: with SMTP id m3mr16967384ilh.258.1643797748172;
 Wed, 02 Feb 2022 02:29:08 -0800 (PST)
Date:   Wed, 02 Feb 2022 02:29:08 -0800
In-Reply-To: <eb631eb1-b7e1-bfb5-0027-1577445ce39a@iogearbox.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dccb0305d7067cae@google.com>
Subject: Re: [syzbot] possible deadlock in ___neigh_create
From:   syzbot <syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com>
To:     daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com

Tested on:

commit:         4b48392c net, neigh: Do not trigger immediate probes o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/dborkman/bpf.git pr/neigh-probe
kernel config:  https://syzkaller.appspot.com/x/.config?x=5044676c290190f2
dashboard link: https://syzkaller.appspot.com/bug?extid=5239d0e1778a500d477a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
