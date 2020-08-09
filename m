Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDE23FCDA
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 07:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHIFPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 01:15:11 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49757 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgHIFPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 01:15:10 -0400
Received: by mail-io1-f71.google.com with SMTP id c1so1213214ioh.16
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 22:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+7GquL5yQSGcFGMZlACJ2Y2BFlEpHb0ViyNa4GHMUYI=;
        b=GlNxAU9eH5JcRx9E2eqLQ2pALf6fYNiUx6KOwL7fgapSoiJDtwS6h5em6/7F4iGylE
         EfI6so2m20VJA4vhxkaOeIkne29ZL7J1/Ul54y95g1N9AvfvGoTisBHbP6QIfxag1Nqw
         VcyKui1N6q4BMnZUrpec1Ap6k7d++QgGG2Gs1HfwVzFNyOQIh2iArSk0VSVyjj64cCfM
         mBSoEUt2cWErrTGU7tSUnalTTSqaxUw1woa+HQwlmzZ6wpWpJTKiLa4Cf4tVcOlM547c
         x1Lrf5ursZpF7Zxz+Y2bK0Ogp8QEqd9ugz5PsZwToTE4lpal1Ep9W39nvAYj3QqlTusn
         Uzdg==
X-Gm-Message-State: AOAM532Hh9kie7UK2xhBXkYFHxxjb882TzWvOykujI6xAcT/w7yCo94i
        JyE7mQan43jcwFni+HlDMYkwFuz/zaGbnR5VBh1lUvafrugS
X-Google-Smtp-Source: ABdhPJwnoROO8orXk27MbZoY6LmPmQEmrUZnYlYAjH2J4bAGvlMJDDzVwIZ0hH60TV5qaTtB7u2wVG/qNSiGwWh/MNVTaKiDIsBk
MIME-Version: 1.0
X-Received: by 2002:a92:918b:: with SMTP id e11mr12138160ill.201.1596950109419;
 Sat, 08 Aug 2020 22:15:09 -0700 (PDT)
Date:   Sat, 08 Aug 2020 22:15:09 -0700
In-Reply-To: <000000000000cde53e05ac446157@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fefd5e05ac6aeb99@google.com>
Subject: Re: WARNING: ODEBUG bug in put_device
From:   syzbot <syzbot+a9290936c6e87b3dc3c2@syzkaller.appspotmail.com>
To:     bgolaszewski@baylibre.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, jdelvare@suse.com,
        johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, marcel@holtmann.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 6f8c8f3c31015808100ee54fc471ff5dffdf1734
Author: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu Aug 8 08:01:44 2019 +0000

    hwmon: pmbus: ucd9000: remove unneeded include

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1550298a900000
start commit:   47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1750298a900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1350298a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7bb894f55faf8242
dashboard link: https://syzkaller.appspot.com/bug?extid=a9290936c6e87b3dc3c2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b69a52900000

Reported-by: syzbot+a9290936c6e87b3dc3c2@syzkaller.appspotmail.com
Fixes: 6f8c8f3c3101 ("hwmon: pmbus: ucd9000: remove unneeded include")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
