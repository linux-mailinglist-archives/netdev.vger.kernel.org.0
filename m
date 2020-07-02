Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1642124EE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgGBNjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:39:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39019 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbgGBNjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:39:08 -0400
Received: by mail-io1-f69.google.com with SMTP id r19so17564918iod.6
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 06:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WpKkuPCbjM9qHybSEs/eO4ohp9+DmrsOe+ROlXOZsfw=;
        b=oik8xp08zQwPEQHypXHuUAQb6KP7jA3zHj26KFqiIik/hb93vRXNSxzxo48eJZ6beq
         T9SklwMde5QzsfaDZr6kyjGCTHV//vD1cQGHFXIY48Da8TlATfiC9tLjqedKIRXhuDbn
         iqWeV44BXAYofmbh7d8lk0J8tsuP5F8TsiUDwEy8Xgq7JP18GeldNS2XPI5wAOG0ZBzs
         jpae/pB6Z1lCqdHEhhX/TGMdKfHgko1ZA55/hfMtF5eAqi/3jL5QxiB7Tz6j8cTDIg0v
         RAyvydPt9j5QF1Uv0QNe2MUX+mdTmAdOzXJcGb+NVyz/i7blrRbCL0XphKVu3xit0aH5
         Z8IQ==
X-Gm-Message-State: AOAM530uWoVY5cwJvCIEjvwyTb+oTTE0UmQbiHc3kQZMARyXhoq8RdAE
        EWAqoVduYhWaq8C/dTK4x2Ham6TexeIClhMqiyR3lC0kKvMo
X-Google-Smtp-Source: ABdhPJzabNnQL2nbQZLXYYBaeQiPct0MWGQOc2ZsbarBu3vWY2R3VqBxT6Ux5jgC1ao6rItmynuh00qwZq7qfK301tZVPk00HE/2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:e93:: with SMTP id p19mr16903757jas.67.1593697147104;
 Thu, 02 Jul 2020 06:39:07 -0700 (PDT)
Date:   Thu, 02 Jul 2020 06:39:07 -0700
In-Reply-To: <000000000000ea237605a8e368a9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055323705a9758823@google.com>
Subject: Re: WARNING in idr_alloc
From:   syzbot <syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17325ad5100000
start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14b25ad5100000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b25ad5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=f31428628ef672716ea8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15252c4b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10159291100000

Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
