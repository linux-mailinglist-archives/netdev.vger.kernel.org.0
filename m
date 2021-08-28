Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319363FA72B
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 20:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhH1SdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 14:33:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37782 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhH1SdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 14:33:01 -0400
Received: by mail-io1-f71.google.com with SMTP id h3-20020a056602008300b005b7c0e23e11so6119429iob.4
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 11:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=up8sbinmdfW5FEk6l6npSbM0ylrChylbR3vjt8i49Xs=;
        b=dtrFbLmgT8hgBZ2kfdxH3kMwrhdW7t9DStFlZra9KDDXiqIn7TI/jgstKdaJr9vPbQ
         aVaH4sqCEREqItx1mxtlvVdQ9pBusTJVl4ZfcMSFyTKpnOm4V5tQ90p4zhAiUtwypZui
         4xQnDYpwjh40o7qyC+fO+Whvr3TCYs9W1Jc1IvQpYhhReoZ5c/MgGGkqr1mUMQBrQt9z
         VSerKZqV7KuXvyDPC0L6C6ESCeePIrghxhJqyfE8i8sOYza/kKoIdcJtPGjiC73dssA2
         L7C6cDpXwvkXLthcqZowG0wc8Wpq9A0n0d9yGRh/55p6GrgKFqzZD+exxFkehJ/K4YGP
         66Sg==
X-Gm-Message-State: AOAM531esvw5jydgm2gCuZ+gzIccyu1FJv9ginvN2YyBgl89pL9CBdjl
        w3LHf39X+/BNscO1dsULLm0qVPjXmyYJrHn+jZSRevNrFqWO
X-Google-Smtp-Source: ABdhPJz+Yyr5HRroDxrfkjQQ5ziL5gBeIlEZ7KitgTECC5WrydwZTAne5hlTp3U9EC17zAoYBcRj22iKM9omVjv0Oo7cv7/OiVjq
MIME-Version: 1.0
X-Received: by 2002:a92:280d:: with SMTP id l13mr10827952ilf.99.1630175530430;
 Sat, 28 Aug 2021 11:32:10 -0700 (PDT)
Date:   Sat, 28 Aug 2021 11:32:10 -0700
In-Reply-To: <000000000000b575ab05aebfc192@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069bb3e05caa2d1f8@google.com>
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
From:   syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>
To:     anant.thazhemadam@gmail.com, bjorn.andersson@linaro.org,
        butterflyhuangxx@gmail.com, davem@davemloft.net,
        dragonjetli@gmail.com, hdanton@sina.com, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, mani@kernel.org,
        manivannan.sadhasivam@linaro.org, masahiroy@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 7e78c597c3ebfd0cb329aa09a838734147e4f117
Author: Xiaolong Huang <butterflyhuangxx@gmail.com>
Date:   Thu Aug 19 19:50:34 2021 +0000

    net: qrtr: fix another OOB Read in qrtr_endpoint_post

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11279a4d300000
start commit:   ba4f184e126b Linux 5.9-rc6
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12263dd9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d77603900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: qrtr: fix another OOB Read in qrtr_endpoint_post

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
