Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC0762A94
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405043AbfGHUuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:50:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50512 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732159AbfGHUuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:50:02 -0400
Received: by mail-io1-f69.google.com with SMTP id m26so20361478ioh.17
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vS8SIynIAO1niTjX4OQUTnBY4wnYj3RxM6IVuk/LaD0=;
        b=e6xpkyMEKs+byRD31b/3lUpvMgbnalh87Fr0zfBfsk9emeUUag6i1XcR7ymG2Ru5dP
         HMjA7ZPh8Lyh5V0EXPVN8I+Bfh2OAZ0cvs3X7LoBRYuHt5BmUjco9wMIpwc061S7PjL9
         /cPs/NmviTE9SKeI7qC2bb/sWBwhTqvAEby6ZtADbBbhMNdiC1cj2J+Bh8p3sU/2t7ZL
         sUAeqPW4AsOHx0zURXyI4wNJ6+QSWsD3rXpUCowmVCMeo53yW3ITx6a5QC4SfIq2jEcV
         Uk812YZ1TJ6c7a4/squ9kbmOUvQqTaL2VinZ5g/8ybzvOwD77Gn5yGkm3gHTXNiR4HEe
         0UyA==
X-Gm-Message-State: APjAAAXgBAAd6LqkpeRNk4+ol3zL9i6Kg+wzUc2wbnKzvp9KF+TtJDhR
        wmR6QqeUwx1MoRHByjeR/fLG8iugTaFHg223PJuJQGZZ163b
X-Google-Smtp-Source: APXvYqz7Mex/eD2OdoHL8oINO6gsJGtHoTjt54wV5yzwa/nG4sene7Zkk4Wf8u8nfN+cT0C1boueLV+OkMcBcFefNswglCuyyAnW
MIME-Version: 1.0
X-Received: by 2002:a5d:96cc:: with SMTP id r12mr18877749iol.99.1562619001197;
 Mon, 08 Jul 2019 13:50:01 -0700 (PDT)
Date:   Mon, 08 Jul 2019 13:50:01 -0700
In-Reply-To: <000000000000b519af058d3091d1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c5b83058d3196cd@google.com>
Subject: Re: kernel BUG at lib/lockref.c:LINE!
From:   syzbot <syzbot+f70e9b00f8c7d4187bd0@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, darrick.wong@oracle.com,
        davem@davemloft.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 867c90eeea9d81ad1336881b61a4dcf692fc5d50
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Jul 8 00:22:38 2019 +0000

     Merge remote-tracking branch 'xfs/for-next'

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16c69bc3a00000
start commit:   d58b5ab9 Add linux-next specific files for 20190708
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15c69bc3a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11c69bc3a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf9882946ecc11d9
dashboard link: https://syzkaller.appspot.com/bug?extid=f70e9b00f8c7d4187bd0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173375c7a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1536f9bfa00000

Reported-by: syzbot+f70e9b00f8c7d4187bd0@syzkaller.appspotmail.com
Fixes: 867c90eeea9d ("Merge remote-tracking branch 'xfs/for-next'")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
