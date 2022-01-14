Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C24E48E266
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 03:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiANCJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 21:09:08 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:44742 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiANCJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 21:09:08 -0500
Received: by mail-io1-f71.google.com with SMTP id k2-20020a6bba02000000b00604f85cceffso4871366iof.11
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 18:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l+R7nWMxKcU084x0V/7GNQbj65lf2ts3dJyo3gy3f6s=;
        b=09im0LPuA0FhNgZZiNyKinHeP1NzvSvNE0F8Gjbz67viJceT1o+gKHxaUHiRdq/2wV
         K0IZ+2P63wQBmbBJQc7z99SeZxkEAnoNeErF1A5yW7mjr47rvWWpoo7/EoeIHGVOJFvn
         qbBCyMZzB5MQbvIJee5L3m0aXcjULaWGT4yWllmNlLBjIimBWGY1LUt5I8EYniEm7DWZ
         HLhayTfJNy7icyz8AGsKHigrvkxv/L+wDscuGhg78pqUOtCa/VteMkocuoZlVAH1vCZx
         5FBs0vxNc4h61gXiBTfOugfoKwAXj77/UJ5Ofq/tlOlbine4H15qaLMygDhwXWl3UyNY
         leYA==
X-Gm-Message-State: AOAM5318+opJuuh/u7mQffolBxzKaFYtdNnikosNxV+KmzuJUzfekWue
        3ZiXCq6jnZ5JcAiR9+mxMOTC0KtnEJmi1rWZbtYTnQ6YZ2H4
X-Google-Smtp-Source: ABdhPJybKJOsrE+8Vo8gzVZrp2mTACAvXMUTRVRTzELPcrK9to/GJshkwEJEUMZmSYSGqFeYj8NqLtMD/0Cl7x2d2cUB4f5x7AlY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ce:: with SMTP id s14mr4007528ilu.0.1642126147538;
 Thu, 13 Jan 2022 18:09:07 -0800 (PST)
Date:   Thu, 13 Jan 2022 18:09:07 -0800
In-Reply-To: <998e645c-b300-9e58-eb02-3005667dcfe2@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b355a205d58149fd@google.com>
Subject: Re: [syzbot] WARNING in signalfd_cleanup
From:   syzbot <syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, changbin.du@intel.com,
        daniel@iogearbox.net, davem@davemloft.net, ebiggers@kernel.org,
        edumazet@google.com, hkallweit1@gmail.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com

Tested on:

commit:         59fb37ef io_uring: pollfree
git tree:       https://github.com/isilence/linux.git pollfree_test1
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aaa2946b030309
dashboard link: https://syzkaller.appspot.com/bug?extid=5426c7ed6868c705ca14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
