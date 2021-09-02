Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7713FE77C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 04:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhIBCQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 22:16:15 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55047 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240725AbhIBCQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 22:16:05 -0400
Received: by mail-io1-f70.google.com with SMTP id o5-20020a6bf8050000b02905b026202a6fso316392ioh.21
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 19:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0JUwZXH8tXwg/Y0mzczq64iCoCbtgnTNDv2GYMyLZD4=;
        b=uTdVDLS2XsB7byvzKpCq5XV/VBntlvZKInGdxGeSoiJ5vUpdDC47UcwoEeel17AYy1
         IpBVL2Y6PXoCLtsjqK1W7xJOBfuU1t58jEPubnHE0dlMPvO+nKyMy6QbNLQyBKF2jhLw
         3eA1wolnH76F+jMf4UKrO8ezzXSfXlWqOQkG0uSi6gQ1r8rpcw8qEgCYE3MQR+EYZzkc
         y8n1sCxjaGBcOzspA4PLufye9eRn3QJNSGYFD1WVybs7TZhC/Z9ED7frf3XKeVu1Hcxw
         kodtycypBUPZpbHattXgDh39NLVLk8fDgw1cxyDwmg6WGp2ysDrb5I7u03+szyf5cryg
         3Aqg==
X-Gm-Message-State: AOAM530Gc1pqvjAE/GnZ03IgLiTRd+Zfl6ayPG1uiQycLGnaIIwFkEYy
        eK1/oJkhEnkAOahcyrmvgwlk9lbgWgdZNtjvjgLCt9ttds3W
X-Google-Smtp-Source: ABdhPJzvo2XBa5Xt8glOx7p+H6enrDvMxXqgaVoutT9Y28986VCjR6HokMFItWtv9YD2/QfiZ32Yg5pL0uuNQzqyuUXRiLagRd+N
MIME-Version: 1.0
X-Received: by 2002:a5d:9617:: with SMTP id w23mr739002iol.115.1630548907681;
 Wed, 01 Sep 2021 19:15:07 -0700 (PDT)
Date:   Wed, 01 Sep 2021 19:15:07 -0700
In-Reply-To: <983049ea-3023-8dbe-cbb4-51fb5661d2cb@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006e715f05caf9c044@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
From:   syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>
To:     antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com

Tested on:

commit:         9e9fb765 Merge tag 'net-next-5.15' of git://git.kernel..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd61edfef9fa14b1
dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12546ba9300000

Note: testing is done by a robot and is best-effort only.
