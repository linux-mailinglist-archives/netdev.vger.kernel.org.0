Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0833AD5A10
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 05:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfJND5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 23:57:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41447 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729706AbfJND5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 23:57:02 -0400
Received: by mail-io1-f72.google.com with SMTP id m25so7320951ioo.8
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 20:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OuWAyTtmm63QQUGDPXR+DkHDOHPMuPnOWQaHNFnyLBY=;
        b=Y9ZntNuY+s7ITn/wnEG3XFp1u74aG06vRYwqGuFe4MzOgBxcnKu/B7sjVZ3l8jYBVD
         qTR+6ufbsDvPpqGkYpFy7ygxLH8m+fsiu61I2jxBzOg0CfP6K3YbG7aXv0+KP4H7vbwd
         /D+YP7trufV3g7GuN2xhfBxWq3mrzmjyAqRvTSu8EizrJ04ormllWuKHoiY+du5/g9ht
         dsm+s+9jsEX4jGXdEs793qDtP8hl9kWF8QK0fns/PcXd2tAEduizpN2kXiBQcFwfsU4s
         1pZPBV1vjbJC8z9vsiTusdhrbGZXT/uL3iTRP6S8QafT3CXX3JWSmgMch8wW01+NUUZW
         oGSA==
X-Gm-Message-State: APjAAAXn7DzKVbalIdcV7k2Wcj1gT45v8UD6dhOlrVrkQTqbTwziXgLy
        GND8LsauyX7RnHtoheN5J3QuTpfSZZlZIDgkdg0cK/DHIO6/
X-Google-Smtp-Source: APXvYqwVwyIy9nSYbsyJl/5Ky7DslcWs3entkTykv54QRnqMyvOOoULUzhOD3mtwNZ2fJRFRwM9mAxsY/zpxHu8l3i0Nylw2l3P/
MIME-Version: 1.0
X-Received: by 2002:a5d:93c7:: with SMTP id j7mr6139939ioo.167.1571025421311;
 Sun, 13 Oct 2019 20:57:01 -0700 (PDT)
Date:   Sun, 13 Oct 2019 20:57:01 -0700
In-Reply-To: <00000000000059b6d40594d0f776@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ba5570594d6dc99@google.com>
Subject: Re: WARNING in batadv_iv_send_outstanding_bat_ogm_packet
From:   syzbot <syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com>
To:     a@unstable.cc, akpm@osdl.org, arvind.yadav.cs@gmail.com,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        kgene@kernel.org, krzk@kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        mareklindner@neomailbox.ch, mchehab@kernel.org,
        mchehab@s-opensource.com, mingo@kernel.org, netdev@vger.kernel.org,
        oleg@tv-sign.ru, roland@redhat.com, s.nawrocki@samsung.com,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 26d051e301f67cdd2ea3404abb43902f13214efa
Author: Arvind Yadav <arvind.yadav.cs@gmail.com>
Date:   Thu Jun 29 08:21:35 2017 +0000

     media: exynos4-is: fimc-is-i2c: constify dev_pm_ops structures

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a0aff0e00000
start commit:   da940012 Merge tag 'char-misc-5.4-rc3' of git://git.kernel..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a0aff0e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a0aff0e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d2fd92a28d3e50
dashboard link: https://syzkaller.appspot.com/bug?extid=c0b807de416427ff3dd1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141ffd77600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11edd580e00000

Reported-by: syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com
Fixes: 26d051e301f6 ("media: exynos4-is: fimc-is-i2c: constify dev_pm_ops  
structures")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
