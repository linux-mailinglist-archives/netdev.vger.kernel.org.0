Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E6B245003
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 00:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgHNW7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 18:59:07 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34039 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgHNW7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 18:59:07 -0400
Received: by mail-il1-f199.google.com with SMTP id w86so6830354ilk.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 15:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=26hWQC191k0LtuaZdSkVmfh/7oglcND6lOLk0CrAyjg=;
        b=khCOCwCWWzeKKqqnX2hRDiIHUmnK4ydTNe+HhjqvqGXvfW7TiAm9IXOGGrqa6B7Jbj
         myaXCXf79sq26SKkffz6KJRIO5GW7AhT1S16TqVpM93KcvtDXxwGimP64SDTItSNKKlO
         bT/fC4ZjnaVKXeWB230oxG7BMRTblIuWIZBPxRShPMDU6Dp1qoiQ0jj/XG4SkOcGpAMO
         oixWdG65gxkA41s0PCqpVVDKxAO1yRi2Y065B+uDw4dl80OHGjF6kr85BbOkAkQPuMG/
         kFTwtpfjgKLK3+bK8hllhWsr9QzwuxeXpGF7VSC8Fdlv6i2FZWvzP+NaRHFlJpqVHz6l
         0NuQ==
X-Gm-Message-State: AOAM531cvhCeepKl+Hk+gi2CZm+oiTzJF/oLoC9czGPbpiwK3qCFnIMC
        /ApMgzsLe+c6Rg4mkRxeZK8bYzudZZ3NpZx8zhkKJVNOyxtE
X-Google-Smtp-Source: ABdhPJypLHX9dDgEVGPD3bwTWaZvyk4HCc9VC0CCoMFtyaW6XMVYLFWi6Q4yAOt+dOK2FInhgOit9VdtS0K9OXDQNFwAB7SvoEdS
MIME-Version: 1.0
X-Received: by 2002:a02:6903:: with SMTP id e3mr4870665jac.142.1597445946590;
 Fri, 14 Aug 2020 15:59:06 -0700 (PDT)
Date:   Fri, 14 Aug 2020 15:59:06 -0700
In-Reply-To: <000000000000c770710586c6fc92@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000031c95f05acde5eda@google.com>
Subject: Re: BUG: unable to handle kernel paging request in free_block (5)
From:   syzbot <syzbot+438a5abd4f53adb1c073@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        jon.maloy@ericsson.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1378817486d6860f6a927f573491afe65287abf1
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu May 21 18:29:58 2020 +0000

    tipc: block BH before using dst_cache

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1537694a900000
start commit:   e6986423 socket: fix compat SO_RCVTIMEO_NEW/SO_SNDTIMEO_NEW
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=4fb64439e07a1ec0
dashboard link: https://syzkaller.appspot.com/bug?extid=438a5abd4f53adb1c073
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12adddbf200000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: tipc: block BH before using dst_cache

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
