Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C4623D1E8
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgHEUHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:07:24 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:37434 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgHEQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:33:08 -0400
Received: by mail-io1-f70.google.com with SMTP id f6so17783514ioa.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 09:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xdDF8KAwPeDbsdN5hACSBVSNt3eeL93Vn3ZE06PW0ws=;
        b=lLPrkf0ijCeBYmxsRfF4Mf5AbEaScjCfROPN1P3ooznoqW1dUHRS2TmRXNaPPQmSTl
         kIjnsw5OUT1XPkyRCyXM1dGSGwYKBBdA0jtuX3sZzFDFTpTNUZ1KnFepSx3sslOFLuk+
         ESRZryxpOWzVKKyiigtNcNcdTfKFWFzPrcM7UjBADjhTkCeiLmazulSCUNCg4R/8Wu/N
         LPwKeuoar2zjziMohizjEKlnQRTfNKivDW06MaKVOzr2WPDZHp4D1IMluKTiCHfyt0Nz
         dng0OWSV8QfM+SAwTjo21czhyfum6bOS1aNxIW3w8H0EPWsqzuyDD7CL93oRyfLSHszz
         /BRw==
X-Gm-Message-State: AOAM533igLeKeSxXXcNYOq42f+oaaLcvHwwZm66ApcF1nvXGLaGaSaOd
        8vrmr7yJMwqGpXHxDMV5TObELI8gLqD3kNdO/kU0PDRFqxjM
X-Google-Smtp-Source: ABdhPJx1bzir56joK2ABAxtH0sKqUYFQk87L5ebinbPqcd6dHIycZoH3GBn4mZAYZSuRbVEjVUHzKuZ7t4g9wSnDVEVr5CKihhk0
MIME-Version: 1.0
X-Received: by 2002:a6b:ba06:: with SMTP id k6mr4243404iof.101.1596645187111;
 Wed, 05 Aug 2020 09:33:07 -0700 (PDT)
Date:   Wed, 05 Aug 2020 09:33:07 -0700
In-Reply-To: <00000000000023efa305ac1b5309@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035d35105ac23ed6d@google.com>
Subject: Re: WARNING: refcount bug in l2cap_global_chan_by_psm
From:   syzbot <syzbot+39ad9f042519082fcec9@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edubezval@gmail.com,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        marcel@holtmann.org, mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 3c1e300966d7edc380e405b3ab70b6e3c813a121
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Tue Oct 18 19:44:12 2016 +0000

    [media] si4713: don't break long lines

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108f4002900000
start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=128f4002900000
console output: https://syzkaller.appspot.com/x/log.txt?x=148f4002900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=76cacb0fe58c4a1e
dashboard link: https://syzkaller.appspot.com/bug?extid=39ad9f042519082fcec9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14491b04900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1188e392900000

Reported-by: syzbot+39ad9f042519082fcec9@syzkaller.appspotmail.com
Fixes: 3c1e300966d7 ("[media] si4713: don't break long lines")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
