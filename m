Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29EF13968F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAMQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:42:03 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41062 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMQmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:42:02 -0500
Received: by mail-il1-f199.google.com with SMTP id k9so8172254ili.8
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UggXgyDMOpX5GHDFThGPB3yVNMKWrTSHTCaDTJ6McXo=;
        b=VorIkgl5Owv4+EVfGMebkUxeoWk4VT6rIrRHg/OQ4eaUXh1uFFgYnG5gPQpgxve934
         zAJ1b7Uc+jgqxS3Dxs0BEoss/kLrA9ABDdEI6xSFAn5GBmpphMx0/Ls5kF7WblUnbVOV
         iMw9x6KjKT9TKSREODrKsJD4UMcKLPEHHlRQAohvXnOTpYUed8vGSqawQtqpPfFVqQkX
         OZJCIynvkxv2KfmQj48As2OvP/n6oiymS/k5TI+e8tdoJlBteVUuHCTtmmOTtMRCtr6k
         H2AFT2+AldEdVl124StvJ6P5P+QGZkMKM6O8S6HJgcT5zfieBxA2zNt/LUXJXnmPiVAB
         QMyg==
X-Gm-Message-State: APjAAAVDuHrSWWLPMsIJAl4kjlhqS6Pt5P9O8zCOECb0OVGDwbcTncPy
        AWTvhjDYhILbw4/SGm1VcRGOpwINeSOdPDmoJhhXhJZ8HCGh
X-Google-Smtp-Source: APXvYqy9CaTqUtRxm4JcRDeD0S3bogD6d4mwoiAZp6aBCI1DHZPoiOj+/Q+WaCE26zNZRvjut3aai5qER8Zl/wD9tSgZi30iB5tl
MIME-Version: 1.0
X-Received: by 2002:a5e:8516:: with SMTP id i22mr13810044ioj.130.1578933722080;
 Mon, 13 Jan 2020 08:42:02 -0800 (PST)
Date:   Mon, 13 Jan 2020 08:42:02 -0800
In-Reply-To: <0000000000005ed7710596937e86@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0ef18059c082789@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_xtp_rx_abort_one
From:   syzbot <syzbot+db4869ba599c0de9b13e@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit ddeeb7d4822ed06d79fc15e822b70dce3fa77e39
Author: Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Sat Nov 9 15:11:18 2019 +0000

     can: j1939: j1939_can_recv(): add priv refcounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a7ec76e00000
start commit:   de620fb9 Merge branch 'for-5.4-fixes' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9ff8f11e66c1fb1
dashboard link: https://syzkaller.appspot.com/bug?extid=db4869ba599c0de9b13e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113e0d72e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136aa6e8e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: can: j1939: j1939_can_recv(): add priv refcounting

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
