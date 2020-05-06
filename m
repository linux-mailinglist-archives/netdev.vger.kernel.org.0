Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155E31C6D59
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgEFJmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:42:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33518 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbgEFJmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:42:06 -0400
Received: by mail-io1-f72.google.com with SMTP id w4so1104507iol.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 02:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1duKq7szTDTyKaohCShGnT1dGsbqpgWG34qMl98tMGg=;
        b=Dsif15iqiciuMXHa4bMqA0Iyj+OhZLGVFVZtNsQ9eBLgcEsFlo1l1UfTCwHZAJUmuq
         Yp+ncLAY/lF0V6Jkzu/CVL+MnmJAk/t5CYjGtSbiMWIMJb6j9C9clI+jusurWE8OHPh7
         9LCdd2qptcrWEpn7MjClu0HmjW1R6+j34dpz/UpvUYf+uyPzCkHDAGawW8Q22CoNYDAY
         +6pMjDiOdwrxte02npjUbFzmomxCNT1K0Z1eRPQK87XdmY5XDAaKG5m1BqX9aTwyRMmA
         Ah7PYEUPcEgBMi03ZQSw8LVQhYfeUMdcDrlkB1JWcIvfDZVWkHw543kwIZAsw4+mRL6C
         LlrQ==
X-Gm-Message-State: AGi0PuarAGlIYvYgYaP+x7ZOzzldY+xgHLQx8DNjqXl57DZWQcm3EfrT
        uPeH53IYiGd9Qxd24ymTFVZq7ZKRceaH1RQm1zH3RFO+9rsf
X-Google-Smtp-Source: APiQypJdwS6IXvlDyKFYWvKC1sYkUXaqiXSGvXeFx1JBzzoNX6kOusu0ZBrpShP3tyhlc/K/ZMXCl6oWgZdHai1LkL1RSXAx1RFO
MIME-Version: 1.0
X-Received: by 2002:a92:5c57:: with SMTP id q84mr8119397ilb.203.1588758125215;
 Wed, 06 May 2020 02:42:05 -0700 (PDT)
Date:   Wed, 06 May 2020 02:42:05 -0700
In-Reply-To: <000000000000ea641705a350d2ee@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b0077705a4f79399@google.com>
Subject: Re: WARNING: proc registration bug in snmp6_register_dev
From:   syzbot <syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        hdanton@sina.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e0a4b99773d3d8d3fb40087805f8fd858a23e582
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Fri Feb 28 18:02:10 2020 +0000

    hsr: use upper/lower device infrastructure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14811182100000
start commit:   ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16811182100000
console output: https://syzkaller.appspot.com/x/log.txt?x=12811182100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=1d51c8b74efa4c44adeb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148e6150100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115c379c100000

Reported-by: syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com
Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
