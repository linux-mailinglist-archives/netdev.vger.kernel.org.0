Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE11EF136
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 08:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFEGJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 02:09:06 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45831 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFEGJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 02:09:06 -0400
Received: by mail-il1-f199.google.com with SMTP id q24so5659928ili.12
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 23:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zfMfzlBlpd3qWkpJFKroTeMQT3G8z4wtkn9pQpVcdFM=;
        b=rNvvYYuSTjf/qiezMg1ExHRRjWUYkceGFYSRMBwXLo1jqqtPCtoYPTGlVtFSSn8G3t
         OKj/6n/Yl0VIFC2eC64tylOx6LTL45KPfgqGOh6Xh1tnPY5WWaGnMVVmRWYrNIPslg2w
         3YlnT3Kr7u8OKCQsALlvOClGRKraKfdjRCdjAU/r0e/D+ek107zv1aun0tU2OXmd+QTy
         sEXnb+Mq44gYzrWfpqkAfZiKLUk4W5gtXBxTfLETDz/XEsUQzONIcm6YZG8Leq+WK4Wc
         Wn36ZzdOe2ZTO23mF4TQyoVKTpn60Ww8a8YceTP/U3Y7OSa6jioY7nJNcmn0QnVTsw1m
         Nokw==
X-Gm-Message-State: AOAM532mBn05F4JZCXpfIDMI4DGvKCN4bLrOuWdPK86XFxd9tywhHpxv
        1NidDaVYfUZ9fmBlEsgG9RD2yDUrO44sKmCrpuAAkqBYK9mU
X-Google-Smtp-Source: ABdhPJwAkYKDZuKJ3kL67cziO2fZITVmB5aBx55QUMPXRpbP4Pme2q99pelZ8TGD+wxZ2eem8686PfvQe7n18DFSv54D+fOIMPXJ
MIME-Version: 1.0
X-Received: by 2002:a92:c9ce:: with SMTP id k14mr7131158ilq.250.1591337343956;
 Thu, 04 Jun 2020 23:09:03 -0700 (PDT)
Date:   Thu, 04 Jun 2020 23:09:03 -0700
In-Reply-To: <000000000000a363b205a74ca6a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ac18b05a75019ab@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible code in radix_tree_node_alloc
From:   syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net,
        ebiggers@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e42671084361302141a09284fde9bbc14fdd16bf
Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date:   Thu May 7 12:53:06 2020 +0000

    net: qrtr: Do not depend on ARCH_QCOM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e22212100000
start commit:   acf25aa6 Merge tag 'Smack-for-5.8' of git://github.com/csc..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14122212100000
console output: https://syzkaller.appspot.com/x/log.txt?x=10122212100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5263d9b5bce03c67
dashboard link: https://syzkaller.appspot.com/bug?extid=3eec59e770685e3dc879
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd4c1e100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1520c9de100000

Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
