Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F18F3039
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbfKGNng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:43:36 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36467 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388983AbfKGNmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:07 -0500
Received: by mail-il1-f197.google.com with SMTP id y7so2681665ilb.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rGCeFvT/AQARxs+6mGwlebmAqlHglnh6rUP8Pgma5SE=;
        b=bHCUFyBLD2gXo4dRgwDVLvGPpwI44HLpNWfIKM97jczwk7ExlIuL5X5G9cdDYHwqS3
         yj8alKG9xbDp3rSCgRQ3ySxtWEaZlmpofn9fe7LTqWzdKK+yRJsdxCY6AlLnB/6/fXTf
         I6mLFpjp17PVkEQ3ub9FxJPCZ1di91HgDA9PZlFExHQrY2/fKowJtv+Fsv90nKF+WE/6
         lWIBPPahcfbKS3wj/NcqjgwMmpifvHLdZr+PtJSU0riAf4gmJ8n1hyyqYX0fkm/fbvO/
         FxnU8aG0EPTnVxYOD/H3nxtPDI/MQ0mk4BQk12rCzKwnVd4+3eaLY9FpjiRE6+xzKori
         /dgQ==
X-Gm-Message-State: APjAAAVgcRpApfza8vipOWX7SSTNo4pkg2/wn9d7M7AUccxROLWntwkA
        21rWl/FLbocVi/EsmkAJHJm4iKfvDl8h0ouE7yjT1g9QmtY6
X-Google-Smtp-Source: APXvYqxHTBWUBJD+8E1NyDqdkz7hV5BSqgFdxPIDCKCY0BxMuoog4ra33v5nSn+Kxh1U5HB1IkGWjlzMWRyONaT5JSDK+u98616Z
MIME-Version: 1.0
X-Received: by 2002:a5e:d917:: with SMTP id n23mr3702806iop.28.1573134124661;
 Thu, 07 Nov 2019 05:42:04 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:04 -0800
In-Reply-To: <001a113fe6d081698f0568a5dcac@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af44bb0596c1d4e8@google.com>
Subject: Re: KASAN: use-after-free Read in _decode_session4
From:   syzbot <syzbot+a7db9083ed4017ba4423@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sbrivio@redhat.com, sd@queasysnail.net,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit c6741fbed6dc0f183d26c4b6bca4517672f92e6c
Author: Stefano Brivio <sbrivio@redhat.com>
Date:   Thu Mar 15 16:17:11 2018 +0000

     vti6: Properly adjust vti6 MTU from MTU of lower device

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1710f0dc600000
start commit:   0b412605 Merge tag 'drm-fixes-for-v4.16-rc8' of git://peop..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8addcf4530d93e53
dashboard link: https://syzkaller.appspot.com/bug?extid=a7db9083ed4017ba4423
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bf273b800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117045d3800000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: vti6: Properly adjust vti6 MTU from MTU of lower device

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
