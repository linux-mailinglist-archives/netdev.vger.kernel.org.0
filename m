Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38120BEE1
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 07:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgF0FiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 01:38:06 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:40990 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgF0FiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 01:38:04 -0400
Received: by mail-il1-f197.google.com with SMTP id k6so7898528ilg.8
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 22:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=u9P2EE/S87kAn+TJjavtmwObTBtoebe5eiDhz57fLfc=;
        b=Uhz8jTbThponVdW17X+D4G7ysZvRfugsQgIiOqm5mnYAb9/SGUyffyV4a+dXximIYL
         FhA5tr3Vs8EnLu1DaYHPLTzSbftIbLIZbIQT0YJJAs4s+yWuWb4kKNKsuqb8Csf94tlU
         vbCiELm4UY8zYgT5QBb6PCpoExEX4Ccchy70BmSxvdmLJ7FU6CCPnLXUeQvj0Vki2e2l
         2z/11hQxQGFNoSAp5EclcWgS3PzYeFQYpC5umyXSyYKAosgVuDhYThRPmydrC1j/qGL7
         HkH75LEjy7JZBnEmufaRr+ur61IQMUv3pEpyaKBLjdVllUv4KzXsuLnhfo6ruQZxo8m0
         ULaw==
X-Gm-Message-State: AOAM532YQ1zr30IMtwAjHc9u7xdLCjHs0q3kR3eOxPPJMb28mRDL6pl7
        EtsrerwMeX1yD6XHXlFkgEnBD5li4JLCDcOx89DBudxaOerJ
X-Google-Smtp-Source: ABdhPJzpnDkAp15KnEECPp6xwF/eVMiqJE7Rm/uBR99//bOgu9a1bSEAuZM/ifHXEU678lXhmIQB1koTWBBxMkem4QkFc/IVdVFD
MIME-Version: 1.0
X-Received: by 2002:a92:5898:: with SMTP id z24mr6561879ilf.242.1593236283469;
 Fri, 26 Jun 2020 22:38:03 -0700 (PDT)
Date:   Fri, 26 Jun 2020 22:38:03 -0700
In-Reply-To: <CAM_iQpVtv0Ut8nwwLYtKgMpQV2WknQJF9t35Ew4RewBYBvQ2wQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b835a205a90a3a11@google.com>
Subject: Re: KASAN: use-after-free Read in tipc_nl_node_dump_monitor_peer (2)
From:   syzbot <syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, xiyou.wangcong@gmail.com,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com

Tested on:

commit:         152c6a4d genetlink: get rid of family->attrbuf
git tree:       https://github.com/congwang/linux.git net
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=c96e4dfb32f8987fdeed
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
