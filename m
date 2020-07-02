Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C96212038
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgGBJoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:44:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34068 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGBJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:44:04 -0400
Received: by mail-io1-f71.google.com with SMTP id i5so8438081iow.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WAGEeWPrSaptqzW7yLUHgWJcljJ0RDXieWtaFOLwK8I=;
        b=uJlclNVC9laxbl+DaPbIrWQCcD4s/qm4sazm07p3KZVyAYInmpTNTKMhTCEIPyZamK
         9GMqTh2K5WksLQOeQorkAVYkotuFG/y7RGlnZmtvynqAswWEdot4KcWf3JcqH37YJuBG
         ZPmBqDNVrIBSYbHONeDZ7kp+lxhE/yLxOj9y1lZO1CDj6znCQdZlj7EKpEavyiS7/Yzn
         xrt4KlLwbZpOAD9p/gD/K9m/nzCb6mZ61Du7yMCD90Ra9mz9asrSoDiglTJgMstRHSZ9
         x9WOdXTw3SClORSQGGOS6pxyv+LTIjNSiiSPjRStwC0SIsiN6vK+6C6Z7ilLxtlyGdHf
         E1zw==
X-Gm-Message-State: AOAM531NfJ3bCl0qOw+WM3wE8TU1+Jz5Hf/oFPU6y2h9pRl4bwbcRcww
        dhPCED56UZkJt8FtEylHpzUg2pwsUsCqraWlvNEcvHt4jj6M
X-Google-Smtp-Source: ABdhPJwvaUUKgDGCjjnU0hGKeYaZG0U1RMrOv2um1OcV2qBfkIsnEkJXuKSw91FQIuKR1yDl7VlRG1dip2i6bT4m4jmzbSomUx1N
MIME-Version: 1.0
X-Received: by 2002:a02:3c08:: with SMTP id m8mr1134561jaa.107.1593683043766;
 Thu, 02 Jul 2020 02:44:03 -0700 (PDT)
Date:   Thu, 02 Jul 2020 02:44:03 -0700
In-Reply-To: <000000000000add83505a8e38c4c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b559df05a9723fcf@google.com>
Subject: Re: WARNING: suspicious RCU usage in ctrl_cmd_new_lookup
From:   syzbot <syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, colin.king@canonical.com,
        dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=131c54a7100000
start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=109c54a7100000
console output: https://syzkaller.appspot.com/x/log.txt?x=171c54a7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=3025b9294f8cb0ede850
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11802cf9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144acc03100000

Reported-by: syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
