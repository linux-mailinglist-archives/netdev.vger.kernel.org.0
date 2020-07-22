Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBE229B2C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbgGVPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:19:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48787 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgGVPTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:19:06 -0400
Received: by mail-io1-f72.google.com with SMTP id r9so2017475ioa.15
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8O+hcy9D+3uP1r6XjHEoJrtrZg3bcURkhZ7Tw7GCuco=;
        b=q2qPVQU4eURUXKM8rlHQdBARSPkPhL4Kh3hhGqgLU5E6PJ7SJyeyoc3cvtnYTmEDpQ
         Yj47xCOaN8dHr1rO3VHlHjUevFMIa/VgJz352yMiLOTdDjsAydvhzAs4cEpVx6Fl1aJI
         QR4JZ/+ZXJyWNMp9LP9eimxjh0DhCugy2hW4oTPJhHB4w77/kCtS6CHZFw8nybbuzsSR
         F2Ij8hZ146frJBmOpqwEgfGXjN3J3pRns52c2RbM1u72eqfugo8CU0SJqmYNiIOCVkwR
         51O0AIrw71ba//dv0k434uss8YOuabMyTqb3C7oiQTCuoVpfdQBDhqOXC6V0XUj1bU4S
         8I3Q==
X-Gm-Message-State: AOAM5332rSaRVH+Da9587mlzqiwCP9O8kFjsIY2bEvN8l+PEKYmwcCCj
        vDkniGFrkkff1MKsMBeh8Qw3MaC/1tMscVIA6pFTzJ01TY9m
X-Google-Smtp-Source: ABdhPJxrRwotvwsFMlv3C7Kix89/6yIaucCdCzBMJYqcV+TZWkdMEarhp/fVTNBpGxms54f0K8O0NlRmZla/4oD6CdGmmcZ6R3gT
MIME-Version: 1.0
X-Received: by 2002:a92:c011:: with SMTP id q17mr398957ild.290.1595431145264;
 Wed, 22 Jul 2020 08:19:05 -0700 (PDT)
Date:   Wed, 22 Jul 2020 08:19:05 -0700
In-Reply-To: <00000000000079a77705a8ce6da7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad5afa05ab09427f@google.com>
Subject: Re: general protection fault in qrtr_endpoint_post
From:   syzbot <syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e42671084361302141a09284fde9bbc14fdd16bf
Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date:   Thu May 7 12:53:06 2020 +0000

    net: qrtr: Do not depend on ARCH_QCOM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f50e27100000
start commit:   1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=140d0e27100000
console output: https://syzkaller.appspot.com/x/log.txt?x=100d0e27100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=03e343dbccf82a5242a2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1496f9f9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1692523d100000

Reported-by: syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
