Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B2EF6CE
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388045AbfKEIFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:05:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47628 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387954AbfKEIFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:05:02 -0500
Received: by mail-io1-f69.google.com with SMTP id r84so15045309ior.14
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:05:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A+4AkRt/iJ32TVTQDYf76dEd7rbEn0HxYNkhXJNAhU4=;
        b=GN+z+vhPOaVixyurxw7lDjJfD2w+DiP5v/2eC0Fdg6qLey/9WJvi73f6PJYsJotuy3
         5jznfj/Lw+bOxBeotcFd6L7V5H6WtLkKvi1DhqxJNl3SfMwXxV+uP0d78WnTYNs2g5dV
         eZ43Trlwv2ZC2z4AVZq5BNl3NMDo1l+oGHnQub8XMWNXCuojSpVn6VeFWHeWFbu7rEqt
         2pCSV/K5Q8BdzAPV1uC3oI+MpP+HllaSxynrsE2JIlgrFY4Br4oMpOD7Vhqr5+bvV++9
         lZJor6LPgZIGO+yvDaVCA97BYvu+6lVo+mQubYLFhI4Guxfe8btPV9y5VVJzAjosy75L
         Bisg==
X-Gm-Message-State: APjAAAVAA5fO/lYcDlWt2FbVSKe1xY9LwKPFsE5fZuQv027xexyMaDjy
        2rTuzg0ZYFQeimFcsaTrDcsWGo2U62HHg/JmsIC9r3SER7SN
X-Google-Smtp-Source: APXvYqxxHa3WZGVREfBIgxsSHWRMFio4aR3soJvRprK7KTi8nNn6BI9Am+gZILpmI5NcZhdyGyBTD3WyVzvP9Bg1F+VtznmK0N4k
MIME-Version: 1.0
X-Received: by 2002:a92:8dd9:: with SMTP id w86mr31839322ill.93.1572941101014;
 Tue, 05 Nov 2019 00:05:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 00:05:01 -0800
In-Reply-To: <0000000000009393ba059691c6a3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009427b5059694e33c@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_session_get_by_addr
From:   syzbot <syzbot+d9536adc269404a984f8@syzkaller.appspotmail.com>
To:     Jose.Abreu@synopsys.com, arvid.brodin@alten.se,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        joabreu@synopsys.com, jose.abreu@synopsys.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 2af6106ae949651d529c8c3f0734c3a7babd0d4b
Author: Jose Abreu <Jose.Abreu@synopsys.com>
Date:   Tue Jul 9 08:03:00 2019 +0000

     net: stmmac: Introducing support for Page Pool

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f481c8e00000
start commit:   1574cf83 Merge tag 'mlx5-updates-2019-11-01' of git://git...
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17f481c8e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f481c8e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c26333525dde4c39
dashboard link: https://syzkaller.appspot.com/bug?extid=d9536adc269404a984f8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16050314e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159c59b2e00000

Reported-by: syzbot+d9536adc269404a984f8@syzkaller.appspotmail.com
Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
