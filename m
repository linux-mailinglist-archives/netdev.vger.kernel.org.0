Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E2584F4D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfHGO6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:58:02 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:51378 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387915AbfHGO6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:58:01 -0400
Received: by mail-ot1-f71.google.com with SMTP id h12so55153978otn.18
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 07:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WeWUyZi7VCNLtsnaaTiz91GIAA++Rddp6QtWItBqJfk=;
        b=casOq15lmxELkNBgYfBlLCOWkqRcYKL8Aqiya07ZLeGW5hEUsqIGsryAxPvigXL0x4
         F/BdVTy5IdVWJGVEcKKopQzjSiL+d37z7i4CBW+pTMvgoaAErosHceyfLnAUg/3FOj6h
         ChyFq3qDlD7j+ouJ8NM2QTLIqjgaBPfMLm3b55QjLOGIfgOTINN7pCbsGXhPMZuDKbE/
         8DMd/nzD1FcyNyXUT5Fk/rlQvbNZwatbuVvU05B6lpCQJaCmrK5mnlkis9W+ZC8IX5Vf
         vl3pIdGRsM5gxqwmQ5q4KXn7qb7ppJ6aughBZZxCw10AAlU+7G2i/JE9noHQpByckuGG
         nvSg==
X-Gm-Message-State: APjAAAV1o7oxhCKtDl5cGkbgjH0koAiRJwCBv25eyxHrUKsr9zjcZyBO
        jBfNEFBq26/4DtZzAt83Q7jJKQINcmYWKvPa1al2NXmQPj/y
X-Google-Smtp-Source: APXvYqw99ZvGdJtrUfS8mJEwMciCjDs8w83xYn0jXYpAXZuw/cI0KvMd7vubohbBpqBJpfJV+utLREol6sQoZxVKwDY/RnvUoBr+
MIME-Version: 1.0
X-Received: by 2002:a5d:994b:: with SMTP id v11mr9744404ios.165.1565189881077;
 Wed, 07 Aug 2019 07:58:01 -0700 (PDT)
Date:   Wed, 07 Aug 2019 07:58:01 -0700
In-Reply-To: <1565187539.15973.6.camel@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de260b058f882ae7@google.com>
Subject: Re: WARNING in zd_mac_clear
From:   syzbot <syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, dsd@gentoo.org,
        kune@deine-taler.de, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com

Tested on:

commit:         9a33b369 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10d8c03c600000

Note: testing is done by a robot and is best-effort only.
