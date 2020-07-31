Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4882423416B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 10:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbgGaIoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 04:44:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40078 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730268AbgGaIoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 04:44:06 -0400
Received: by mail-io1-f71.google.com with SMTP id t22so11268156iob.7
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 01:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2MiWhebPAZEwNHbE02ggeQmHTDlIjaaAtS5l21f1BPw=;
        b=FU6igk66uYvtVpTHBjtuymKBRhdOqqGyEmHQP+5skP/hNmC0b9Z5eel0n7WfsSLqwT
         yT71FA/clGMFVmlbJ+vWPfnk39nr48gKw6JHFVKWTGjnED9LIrqsgdNL/VFq/NZ0ayZS
         STrd2veXdfFSrrnRKWhD706kL0I+d4IcZGXzQAPHFG/clpOHj4yEYZhiGyVW5f8w0YrC
         AzRZihyVaiIFLrVUHdC/ddAL0qZiQV4wWy8ob5TdADBBbVWMTmEcLWkqQGwOFcwtSSHx
         hOnmEcmyC9NVSXci1UUcrd9RknI/dkQVszsOS31e4hpJeljnbZZTBndZgKTVDGRQJOdK
         i5Hg==
X-Gm-Message-State: AOAM530d1G/TGJUmyj4jzuFN/uTnoq+MBPrhHcW38IG3+ywKEkECcnrx
        YzSLKsP7OxKPxmXD3zDu9XAlzBuI3/xfux4DCZcw8rjAosPN
X-Google-Smtp-Source: ABdhPJy4Rj2LLEiAspTEtCegum11hHhIEmst76GFNZjb8ziE/nZyOIvy4zdOy45COS+BYVrIBbRSJc0ymQWmZ3YMzOpl0u7SggRq
MIME-Version: 1.0
X-Received: by 2002:a6b:7416:: with SMTP id s22mr2545374iog.160.1596185045466;
 Fri, 31 Jul 2020 01:44:05 -0700 (PDT)
Date:   Fri, 31 Jul 2020 01:44:05 -0700
In-Reply-To: <000000000000f6d80505abb42b60@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1816805abb8caa1@google.com>
Subject: Re: WARNING in cancel_delayed_work
From:   syzbot <syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit fbd05e4a6e82fd573d3aa79e284e424b8d78c149
Author: Luca Coelho <luciano.coelho@intel.com>
Date:   Thu Sep 15 15:15:09 2016 +0000

    cfg80211: add helper to find an IE that matches a byte-array

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1790af82900000
start commit:   83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1050af82900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=35e70efb794757d7e175
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1160faa2900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11816098900000

Reported-by: syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com
Fixes: fbd05e4a6e82 ("cfg80211: add helper to find an IE that matches a byte-array")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
