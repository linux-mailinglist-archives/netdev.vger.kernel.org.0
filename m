Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372CD38F402
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhEXUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:01:44 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37568 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhEXUBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:01:41 -0400
Received: by mail-il1-f199.google.com with SMTP id c1-20020a92b7410000b02901bb63d32e95so32719958ilm.4
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UxdQh88rvBJTStyCsXUz5phO00MIhSQveuUIqhOKQ3E=;
        b=SBvEtc0VRUYAsxNfC6Tw1yKYbmSy6umsDZvgtSaVi5WAEZdSxxpL0YsUKnXno7UWMU
         weRXbiQyAM0J5orW3gKpI9fLYEt4wkR1E07um+EBfboP2bByAuzEAANGMumkQaljkCeD
         Jpq3Hm871LjcOYFtpC9R2C7qg1sAcGzNvXryPljpmbAts26otiwlGNL8ZLgiGh1A4e++
         gQzkX8lFo6wl+bLxkjyn42GG0dgv3OCTb6WhvYATV+oN22mF4dkayV6oTvEimRj8DSWm
         CNQVY80MfaczlpV67doune8nGKyriYpAfYS722GWu/33Uqv3H1FqRd8UdcSAkHOLRhHH
         mPYg==
X-Gm-Message-State: AOAM532GCAeJhv1eywlSxlEX1Xbj8hj8FmSoiy+gizvuHuHgXR8G86O7
        PM4mNmRKOPzVrOwOp+JpTUZFahJSGPXLcrU5fVaIIN13b4ge
X-Google-Smtp-Source: ABdhPJxBi9ip3XWcomrql0oioeeL8xRGVpJK0qKKtYMWiP0u+HE6DkjDMrYcciPvJA3Bp7ydRzWdBAtUfomYqbdUm+Mmr4rBOuba
MIME-Version: 1.0
X-Received: by 2002:a05:6602:14cd:: with SMTP id b13mr8633555iow.163.1621886413024;
 Mon, 24 May 2021 13:00:13 -0700 (PDT)
Date:   Mon, 24 May 2021 13:00:13 -0700
In-Reply-To: <20210524224449.544eab2f@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083b7cf05c318db2c@google.com>
Subject: Re: [syzbot] memory leak in smsc75xx_bind
From:   syzbot <syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com

Tested on:

commit:         1434a312 Merge branch 'for-5.13-fixes' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb6cff3094efa258
dashboard link: https://syzkaller.appspot.com/bug?extid=b558506ba8165425fee2
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15dfdf1dd00000

Note: testing is done by a robot and is best-effort only.
