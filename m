Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A475F132FAF
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgAGTnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:43:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45741 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbgAGTnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 14:43:02 -0500
Received: by mail-il1-f199.google.com with SMTP id w6so382993ill.12
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 11:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zJNitKAgVyD6L05mimG8VM/c6DYKBTWRutBYb9hJfsg=;
        b=XQAnKPeeU5QB2UpPl6QEYFbZ5xzlq3GURDfMOGGTv3qUpZP+k5eCM9kXPRM0Oiw8Km
         CMbZctorf89Q8WyGXQrZGvstPkympO4sOcLST7dWvCEq+PguonDqi0BlzP5sEW11q5Mz
         OOnlaFN3mjdmirTGrSt3DW3GTtXO0u66uqtScSvtrPbUN15RCP5u4KJLNB+I4tp8Gj/o
         aOAbrXVuu2/Lfz5eQPqYtFOa9nNB8Joo0oWzdnAtJAY6aUizWFsldHVJG1E0K5nVVznx
         0RX8xnrCFlkWUe/B0l81VFfpbh5kpcWsYVnAqG5HNPTY+6142uLVP0EZMwyM5WV1ydPX
         3o7A==
X-Gm-Message-State: APjAAAWTbKmlLx/IDbQIQn0xa/Tjr8WKv3UkFVUDNIierZ/AWKLNH+Nj
        dJq10BR0nW/CSQCflvj+NUF8x5oCWGAn8aJLaHFRxJ0/pD3g
X-Google-Smtp-Source: APXvYqxzHYUUKPkOmQcPvEfIBx0vVL1cBuV0YQ2jq2bdAO99TQxTbcUhwD9QCib5JPi2GrYjV7Q7faGDMF0Lr3JsMKGszJFwr3Zv
MIME-Version: 1.0
X-Received: by 2002:a92:c9cc:: with SMTP id k12mr674567ilq.269.1578426181701;
 Tue, 07 Jan 2020 11:43:01 -0800 (PST)
Date:   Tue, 07 Jan 2020 11:43:01 -0800
In-Reply-To: <0000000000001483d7059b8eed67@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd593e059b91fbff@google.com>
Subject: Re: general protection fault in hash_mac4_uadt
From:   syzbot <syzbot+cabfabc5c6bf63369d04@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

     netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b9d5fee00000
start commit:   c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15b9d5fee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11b9d5fee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=cabfabc5c6bf63369d04
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14896eb9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139ed115e00000

Reported-by: syzbot+cabfabc5c6bf63369d04@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and  
protocol version 7")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
