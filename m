Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9204141A0E
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 23:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgARWaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 17:30:01 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:51238 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgARWaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 17:30:01 -0500
Received: by mail-io1-f70.google.com with SMTP id t18so17454315iob.18
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 14:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yYySPTzXjesI6rMbrrYCnEOoWQeyP6zwNDoBKllcD6s=;
        b=iYNEe6YkU+fWxRXgB9xPBjGxWp6cb5/y2HL7eM9nhFFKBXk4uiv5qg5OAB1I5HRxv8
         VqqO5dU2mOlHDm8um2lhi/DqeGtCiMSnHFITe21Y5MWuTj+VD7UgsO7jImv55jUupzrZ
         6KhKuqKvvjweX5lkqdEepudA+GGNFOMwVNWUcahwWhUkj6R1LxqaZXGyBY5JAkXrq7Rr
         dJexZqzw/UcBouvoca1LJb3t9iUTiAdrlffGz2vG9Rx9OHuOS3VWnfcrv8NHWRfM3s27
         nAnqyLNpXm3sxoMecRl4dJKI4KVrKQX6JMgzPyAud9JUkYUmffKmNyGmuFIJWzYLQTKL
         pljg==
X-Gm-Message-State: APjAAAWh0pm0N1hLVKo71UzrGn8VYJaPSN/pzBGIbTinsY8MufZSDxAv
        PrLMdfo4oc2OsfUxHLVAwppsajoJVjSUhtnO+CAcS/9t09ii
X-Google-Smtp-Source: APXvYqx1pd31epsuW/G1/6eX4XtJtvHwMaQ8qI1MCUim2ZtcFsWE4ZOYVf2vl7dBgVGnmVgzwNIdSp63LSgF0NEjWlUwyEVcpUX/
MIME-Version: 1.0
X-Received: by 2002:a6b:d214:: with SMTP id q20mr29420477iob.298.1579386600669;
 Sat, 18 Jan 2020 14:30:00 -0800 (PST)
Date:   Sat, 18 Jan 2020 14:30:00 -0800
In-Reply-To: <0000000000006de432059c6cabb1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004bc94b059c71994f@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_gc
From:   syzbot <syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170438d6e00000
start commit:   25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=148438d6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=108438d6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=53cdd0ec0bbabd53370a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eb74c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14db11d1e00000

Reported-by: syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
