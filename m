Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2BBF3025
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389436AbfKGNmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:53 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:51703 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbfKGNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:09 -0500
Received: by mail-il1-f200.google.com with SMTP id x2so2614530ilk.18
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=plVVKO/TiA9qEadFaudHEttDM/umSvqIdncqMChXxEU=;
        b=Skekl2Il+5KEUazfPXYr5UvzeARF4jJnvlC71uLCvOdlNx2fZCIWaty8Kdougga/Bd
         kOgB8J2K3kxkUbcrIRbIGiJ3a82v5nrtb/VVrI7Le0XyCRNdS2v9FI7E8RbKa3WXobcu
         te1BfMoBlcl4+PR4KGnbAN1l3LCuTPFQpKmyJJ3JCqi0LAGU/++plvFiQYS67uqv2ok1
         pgkEr9wr171Ks5WOAW854LDq7D7Uhzi/cXRg1i4kFjiyJA9aeGC9VmjRxVP+knZwQips
         6BxJ/eBPG4okp29bzv8EsNMHV/C3dEIJhER7YSj68UJL1wDhJbWdH5xMmPrIKV71ESyr
         ew8w==
X-Gm-Message-State: APjAAAWmJ2ng8NOVpHZzI/hF4tebC3Kh5msXJ4a2Hlck1qHtSd/VZ/nn
        uERoYrlrkiG9IeeRUVAV/ai9X4pDRyW7xMI07DDdId2rmELm
X-Google-Smtp-Source: APXvYqz89Y/yuNQA4WzBGuScF8zNVGHvJlrs0FJ9K6h7EcNx1xXc2GImTi/JmclT7DQJhjOdTsD9CyLEIgow8UlTrEVxqU48Kbux
MIME-Version: 1.0
X-Received: by 2002:a92:ce0d:: with SMTP id b13mr4719390ilo.26.1573134128397;
 Thu, 07 Nov 2019 05:42:08 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:08 -0800
In-Reply-To: <000000000000a5390a0568d7508a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8435e0596c1d44f@google.com>
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_state_find (5)
From:   syzbot <syzbot+d90468452f685a0b28eb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, stranche@codeaurora.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32bf94fb5c2ec4ec842152d0e5937cd4bb6738fa
Author: Sean Tranchetti <stranche@codeaurora.org>
Date:   Wed Sep 19 19:54:56 2018 +0000

     xfrm: validate template mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1090f0a6600000
start commit:   10b84dad Merge branch 'perf-urgent-for-linus' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9b0d91297e224bc
dashboard link: https://syzkaller.appspot.com/bug?extid=d90468452f685a0b28eb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1231c30b800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17c1c37b800000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: xfrm: validate template mode

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
