Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49D52416D4
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHKHCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:02:14 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42563 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgHKHCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 03:02:06 -0400
Received: by mail-il1-f200.google.com with SMTP id z1so264065ilz.9
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 00:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TCO+CRsxJrzBCsKOBMk3YisLrnkYLPAHpyx6MjWmV2I=;
        b=HiH1NbUQEBnMrLhbIprcZNaBneiL2YS5pp5T2BWjS4R1awpaBXZ4u6diwC+2nV0o6u
         c+XREiDq4YesfMs6+dJWjLic9v4hgxkwalEHs9WnitnEdA0bIi6BHzQJksB/FIds2tFw
         Y+ef0RSWJI1f1YHI3h8nFc2RETa/lX3/cpSPx6M+CUJ8cpn4cA6NAmJnMy8+uq0hxAFK
         2+NfREHQYNPgux8ENUTpllAIGUPzjNjQo3nKIKKKmClRmGYPeBmL10sCVHqr9fcvPSIR
         6JEZ9hYIzuvGpVi0ogL5Xuq/JyOIH96WiV8L7RYCZAQJCeP4Fi83q3EXlx0YSwYQ/JIj
         Cgag==
X-Gm-Message-State: AOAM530ezsutgLUG3urcb2shYn1m4X62OTcbV0BPHfD2R3MkDi7hzYGX
        1wswQkHPMLl6rdm5ASjplxgrvr8C8VOkVCzyy0rayp7L13wC
X-Google-Smtp-Source: ABdhPJyIOSFerfWVR1Xo+/AxlOPWMpkrbzwv7jfTrQQsSCTPmQrSRvQ8Qgc2g4nydi3v0jjeKq2dBeLk3CJlnTSTNsYyiHQh6z0f
MIME-Version: 1.0
X-Received: by 2002:a92:db51:: with SMTP id w17mr1349732ilq.105.1597129325132;
 Tue, 11 Aug 2020 00:02:05 -0700 (PDT)
Date:   Tue, 11 Aug 2020 00:02:05 -0700
In-Reply-To: <00000000000079a77705a8ce6da7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015bfd405ac94a6c0@google.com>
Subject: Re: general protection fault in qrtr_endpoint_post
From:   syzbot <syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, bkkarthik@pesu.pes.edu,
        dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 8ff41cc21714704ef0158a546c3c4d07fae2c952
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue Jun 30 11:46:15 2020 +0000

    net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f1cfe6900000
start commit:   1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=03e343dbccf82a5242a2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1496f9f9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1692523d100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
