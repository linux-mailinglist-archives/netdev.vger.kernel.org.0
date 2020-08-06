Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C008B23D5C1
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 05:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgHFDZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 23:25:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50791 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgHFDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 23:25:05 -0400
Received: by mail-io1-f69.google.com with SMTP id k5so7454973ion.17
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 20:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PGyhv+RRFzosio5aiRxqPTJSOPnLEgYHzjRgxNcNcJM=;
        b=bdpZ8XbFE6ed7j5HZTMMhlvNt6Cd/IAQDKnQTe2+r5yhGQpDvLbgcvB/Y+89OnlNiB
         QtGUQYUTueVbxwEzP4ThQYbxn77qrqQ1d+nR/XijrbUZN+owQCbyv2TN0pUocremVetr
         /0zFFyIKMJGmXfpsEbhcZ/M+yXKviBA4OD348r2bdg8ll11AfAy12evFGdYgZSvaoBni
         PhlLHJ/tJA/F2yK5/YQq2Biq/i6Bpa/DduNLhITLxOjwjPtt4MSCllzsWEyGQR/FwT2I
         quZPHBcEwX63Hxea3IHQrLOeaomAk8264fL1WjGQLrLLTysTGXWjVPHS6SCMexilAvqs
         weRQ==
X-Gm-Message-State: AOAM530JMEIGZaQ1Yy9zVr/EUnyFWGLIupBiGGp3+8EqOgNBo5fufZKQ
        hb2y+GZ/EIvFypsjQrzbZ7yu8Vwp0OPVYjO9+C9fH4pv72Bb
X-Google-Smtp-Source: ABdhPJxN9h7tsirIK4Go1MLKweo1tMD2JSQJduOjcZJ6N2j9EP6Wauz92Wl+rQLa9pUMa4RjoLIkOxE0iMTpUzONhZC22w+m4MJZ
MIME-Version: 1.0
X-Received: by 2002:a02:234c:: with SMTP id u73mr6578278jau.141.1596684304793;
 Wed, 05 Aug 2020 20:25:04 -0700 (PDT)
Date:   Wed, 05 Aug 2020 20:25:04 -0700
In-Reply-To: <00000000000039638605a991eca7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce496c05ac2d0857@google.com>
Subject: Re: WARNING in rxrpc_recvmsg
From:   syzbot <syzbot+1a68d5c4e74edea44294@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 65550098c1c4db528400c73acf3e46bfa78d9264
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jul 28 23:03:56 2020 +0000

    rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10bd3bcc900000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=1a68d5c4e74edea44294
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a5022f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150932a7100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
