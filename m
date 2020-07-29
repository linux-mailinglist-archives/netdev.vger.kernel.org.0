Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818A6231BBC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgG2I7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:59:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44468 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgG2I7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:59:06 -0400
Received: by mail-io1-f71.google.com with SMTP id m12so6212376iov.11
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gFBRlRWNk92oL6Fz7e42YwVu/c/ZEOEHHkd5Zj/UqNY=;
        b=Iiisc814CoPUvSmZKSEVrGQcOpSbpptzVfjn+509ThNZWYoZUAJp/uOFzxkZQWUGX2
         0s2kSqXtksQnPGSe+PQdeMXngmxbh3iHgOdKmX4IQ+cFPWK3cwSvjPaqm6f+kI1EYg2i
         FRjhRWQRmnZdi1Fs3TVVUumCWdBhBvUFqLlEDs3FE8Bq8M6AEJbnU5zj51aaFYe5jUF+
         eEWlMCbNzioMhhaywg225fiv/OYwfyTR7BPfPDGBMdb6cfoCMzvDukqjpwQCgcA/izYL
         I9k2R3VvXFZGv0SpkqWcg6GFFcZbggfxi8uLkBHCErFV060LpKT9M7+Mmwf9phr2LNll
         OqSA==
X-Gm-Message-State: AOAM533cLr86IYjuACiLhZMHLuv52LIzermxx1BdK15+aXhdyVchwHA2
        LfaRZa+l4RT46gxuqXUgbiG0y2c+Z27YyQCfu1uWquOiUoF+
X-Google-Smtp-Source: ABdhPJyvyX5E1smDObksgtmqLLMrzGTwPv5XpW2cLAchMk5lOO3bPvgvMcHEpqBPYAXEd1vldHGiYB5nuAwSxaE5cK9yKPxGFxaw
MIME-Version: 1.0
X-Received: by 2002:a92:48dd:: with SMTP id j90mr27158851ilg.75.1596013145206;
 Wed, 29 Jul 2020 01:59:05 -0700 (PDT)
Date:   Wed, 29 Jul 2020 01:59:05 -0700
In-Reply-To: <00000000000099052605aafb5923@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093b5dc05ab90c468@google.com>
Subject: Re: general protection fault in vsock_poll
From:   syzbot <syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com>
To:     davem@davemloft.net, decui@microsoft.com, jhansen@vmware.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 408624af4c89989117bb2c6517bd50b7708a2fcd
Author: Stefano Garzarella <sgarzare@redhat.com>
Date:   Tue Dec 10 10:43:06 2019 +0000

    vsock: use local transport when it is loaded

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6489b100000
start commit:   92ed3019 Linux 5.8-rc7
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1416489b100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1016489b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84f076779e989e69
dashboard link: https://syzkaller.appspot.com/bug?extid=a61bac2fcc1a7c6623fe
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15930b64900000

Reported-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
