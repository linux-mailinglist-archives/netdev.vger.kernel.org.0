Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B831467F7
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 13:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAWMaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 07:30:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47358 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWMaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 07:30:01 -0500
Received: by mail-io1-f69.google.com with SMTP id 13so1874571iof.14
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 04:30:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4SmMbABkY6ThQPONYy6cypBPBR0TLA6ap0ik5lnKxP8=;
        b=CtIzHU0gHz6+hili1PnHRqLLH6WzWgAG6h2Br+eAw+Y7SmVk3VazwF1vh019R0ZviR
         44TsWmRNH7jiaozqlpNQ+zHILYkbJAKVl10XXf7S20vlqTweaRAyStiAYIht/UACNeX9
         LvInTglKKxmwdKUdFygGdED7RIxYdnFBG+y5yjRLqmy1ZuIBxGeTbJpvmC+gnVx49UHh
         31jYlSlRzeJZzpr+v86lXsBE45CRZk3I41ywpep+7LBarCdfl6AgeyK9Qulj0nRgUmlw
         C49Td7tNYvRkG57i6u9PO4F1Hk/HhCzLGTcqQWwSHSi+1ybPgzproF7lT73eyN9LoLti
         mlSQ==
X-Gm-Message-State: APjAAAXW1/U9AvXGJXfGaFlhEfzZ1L+HXeb7kWiwM0CEuO9beRGpHuRb
        bZFnUwo4sSGPYtiDBDJVT37kZPenTe9sKbotHZNEycaFMbGU
X-Google-Smtp-Source: APXvYqxSAwAGR1DUOhT8OmC+2lHPf8M7QnvokXyKxJl/MwEFN5SFQHJSUSrgtfrCq2Tq9CKYo7cWSjIffVV6IYpiJW39NHXvxpk0
MIME-Version: 1.0
X-Received: by 2002:a5e:aa12:: with SMTP id s18mr10205269ioe.182.1579782600551;
 Thu, 23 Jan 2020 04:30:00 -0800 (PST)
Date:   Thu, 23 Jan 2020 04:30:00 -0800
In-Reply-To: <00000000000014b040059c654481@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba7772059ccdcc7b@google.com>
Subject: Re: WARNING in nf_tables_table_destroy
From:   syzbot <syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 17:09:58 2020 +0000

    netfilter: nf_tables: store transaction list locally while requesting module

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c2ef59e00000
start commit:   5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11c2ef59e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c2ef59e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=2a3b1b28cad90c608e20
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15338966e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1667d8d6e00000

Reported-by: syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com
Fixes: ec7470b834fe ("netfilter: nf_tables: store transaction list locally while requesting module")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
