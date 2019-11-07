Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51FF301D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbfKGNmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:33 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55200 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389170AbfKGNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:09 -0500
Received: by mail-io1-f72.google.com with SMTP id i15so1835247ion.21
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jkaowxwkOkoiRTHl/PiXUNv+cs8YRuoJfUzBEAMk5lc=;
        b=tyD0XMER3bdNZUbwg01+cazAVgy0ncssTRuALqBZK2bSWwh1GiM2UIXZPTA+WRYvpd
         oiuOKbixjuPVnK3lY+fKFOQ6epSFFDOJn/ISHad/KN/D2bz+nvaLmbCh8Cu+5A9EZnQQ
         vIs6GPT97LEmMVBxzKwQCXJidasvD3ezCW9IOnQI8YR7ML34MsJY6W/m9SKrP/Z+7bAJ
         yqtynKri13ghTuNXq2rW7ZFeWeD+9WsivOv+XWhLKpEvfGGAMsaYJg6UG+yRiWs5EcjR
         01Q70/EbgliiWxwdLIUHxgat9nCs5PQ2EkRoCRCBbsB+NmN5X1/rr6HCU5oFBkXmzLRJ
         DpWg==
X-Gm-Message-State: APjAAAWwf8IvBzTCLQOUH6eaqrsyosFtJAKX8odjBNn0FIXXQBUIKTjj
        i/CbdwC6ERXHIAOQJrW3gwvlHbaijz89IL6RJh+bPHGLDVac
X-Google-Smtp-Source: APXvYqz9hJt5ZMGmb626jkP8Il0OisxxpfMRJk1y6Nf0DXo/5VYPvSczXypuhhynVt4UcMLYKdDWNzeKnfIo2dtS1aP9V/BZ0ldP
MIME-Version: 1.0
X-Received: by 2002:a92:84d4:: with SMTP id y81mr4570955ilk.136.1573134127699;
 Thu, 07 Nov 2019 05:42:07 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:07 -0800
In-Reply-To: <00000000000060e0ae057a092be8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd9f160596c1d465@google.com>
Subject: Re: KASAN: use-after-free Read in crypto_gcm_init_common
From:   syzbot <syzbot+e736399a2c4054612307@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, ard.biesheuvel@linaro.org, aviadye@mellanox.com,
        borisp@mellanox.com, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, dhowells@redhat.com,
        dirk.vandermerwe@netronome.com, ebiggers3@gmail.com,
        herbert@gondor.apana.org.au, jakub.kicinski@netronome.com,
        jason@zx2c4.com, john.fastabend@gmail.com, k.marinushkin@gmail.com,
        keescook@chromium.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 9354544cbccf68da1b047f8fb7b47630e3c8a59d
Author: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Date:   Mon Jun 24 04:26:58 2019 +0000

     net/tls: fix page double free on TX cleanup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=168ad3c2600000
start commit:   4710e789 Merge tag 'nfs-for-4.20-2' of git://git.linux-nfs..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9384ecb1c973baed
dashboard link: https://syzkaller.appspot.com/bug?extid=e736399a2c4054612307
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17902f5b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111377e5400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/tls: fix page double free on TX cleanup

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
