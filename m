Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B048A54E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfHLSGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:06:02 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:35792 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHLSGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:06:01 -0400
Received: by mail-ot1-f72.google.com with SMTP id d14so46218366otf.2
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iH/156rgMT4fJuQS0nAy3Ez5veVeDUxUwLRyEyTI9H8=;
        b=KaH4oH/FlRYpg+AcLM6uuRADrqeJeSSko8nsg/UVv5nVydeOj3zpE452d8zn4oNlIh
         ZXyIsNxZ6BjmmFmYBJBGBgcnym0/VpCj5ocaRbETk/BAbK4Idu+iiQ8E+KWZWKLgPXc2
         HO2bNf7eGxEIHuOSpaPDAGHLV8eEZ2peaWf0YE8S5cy2kSaCVZn0UyJ4UAX7y95N2Z+h
         E6VhfQnAAU2o8niYwpFElKf+XFKIJLWmRBzPjjchAQhkKrKRmpoS7gybWNiGxia6CwUH
         iDPyPPp2IyCuI34Y7memOjmMXyXPNZQErzS1jnaBkZ1VwyVGc+L/0RPYdFgy4qnatgHx
         sqBw==
X-Gm-Message-State: APjAAAVvf21KnFCxQ+BNnf2D09P7WOVVZH7awnqriqcfFq/n5/P+9UxV
        g9ywfDH8/W6a9ilja4F/hD6zkZu/DtE+JSk7bGacav+hvxYb
X-Google-Smtp-Source: APXvYqwuMjKnkHlImBDK/Uqqq5JTnDh9EQ7P5bcsypbrgVf6mLj8vhU+JGvuhxpJikQONeVKnmVPfbXgiZemqDb4ZclS/LuIRawB
MIME-Version: 1.0
X-Received: by 2002:a5d:860e:: with SMTP id f14mr25026723iol.242.1565633161044;
 Mon, 12 Aug 2019 11:06:01 -0700 (PDT)
Date:   Mon, 12 Aug 2019 11:06:01 -0700
In-Reply-To: <0000000000007593f4058fea60d8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069a89f058fef604a@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_queue_local
From:   syzbot <syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

     hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10b4ebce600000
start commit:   125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12b4ebce600000
console output: https://syzkaller.appspot.com/x/log.txt?x=14b4ebce600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=78e71c5bab4f76a6a719
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165ec172600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119d4eba600000

Reported-by: syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
