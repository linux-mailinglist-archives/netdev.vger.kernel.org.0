Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8415445CED5
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbhKXVWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:22:24 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:52745 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244055AbhKXVWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 16:22:23 -0500
Received: by mail-io1-f72.google.com with SMTP id k12-20020a0566022a4c00b005ebe737d989so2958577iov.19
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 13:19:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3GJ+4CdsX0PFWBhcNXJNFnBA66wTNN3En4M+MxGkMU4=;
        b=H16YlrcUD/mzNtDt2PSG+levQ2WHfp+F1oC1XfgbNVkm+oppx2HH0MhDgR+IvU/O55
         9vrOQoEZ5mgvjkNyXpXoPAkxvqWvceb3WSIAbetjzckw9JqtBPsiS1/BY8WCCYXeJGeG
         w6FXXcu8cuKw80MqCc+pl3RNp/S07/i+buiX3diV2wJki45420Ewqv1yr5208VEFOaIT
         SXBHx7VXrmayLcGjE3YiHkz5mXRs/NuOIP164+jDsbSeA53k4PId8pchrXqOvDBusFA5
         ZBARszQH/f71R0tUK71bymai3hD6Vnr2Fc/rixUUFcfEPZjD2nMG7b3EedIPac5XOfC6
         gspg==
X-Gm-Message-State: AOAM532xQsbqF0DBYa/2QTKRPy4EiPSzy3Z54sHM4uKXaEMfRNWgJKxw
        sP7QeVetrQeNl/aH5pDgWvdQb1Z/mhXORz+cX6RILOUDCX+7
X-Google-Smtp-Source: ABdhPJy+ViwXspfH+AzqZ3xdwhPy+j1L1gC3xMS3BkR/OpqAasuB0yWA/c9gLmE0ybj2FRKxAc40XFE9iaiA0nV4zoLLujW0xBBu
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156a:: with SMTP id k10mr14850843ilu.200.1637788753148;
 Wed, 24 Nov 2021 13:19:13 -0800 (PST)
Date:   Wed, 24 Nov 2021 13:19:13 -0800
In-Reply-To: <000000000000e2852705ac9cfd73@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9412505d18f6899@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in lock_sock_nested
From:   syzbot <syzbot+9a0875bc1b2ca466b484@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@nvidia.com, johan.hedberg@gmail.com,
        kuba@kernel.org, leonro@nvidia.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wanjiabing@vivo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit c5e0321e43deed0512b34d8d8d40a16c0e22b541
Author: Leon Romanovsky <leonro@nvidia.com>
Date:   Tue Oct 26 19:40:42 2021 +0000

    Revert "devlink: Remove not-executed trap policer notifications"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f87adeb00000
start commit:   a409ed156a90 Merge tag 'gpio-v5.11-1' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=20efebc728efc8ff
dashboard link: https://syzkaller.appspot.com/bug?extid=9a0875bc1b2ca466b484
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a4445b500000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Revert "devlink: Remove not-executed trap policer notifications"

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
