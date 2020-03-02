Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69641753CF
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 07:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCBGaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 01:30:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:54847 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgCBGaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 01:30:09 -0500
Received: by mail-io1-f71.google.com with SMTP id z16so1773940ioc.21
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 22:30:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4YYMt/NmjzWA++n+f1JrmgMPppH69EcF6rf66gBwOAQ=;
        b=Ts4UBGfchPP8eJJW2bQzzTBYc3Rk3wwJ+q54kpMXPF2mI/fSyxA5JdsuLERMAlOO50
         XiO/0sDb3W7o8RCGOToxGfmeGafUX578sc+PbCQZikFUTBs+PRA0bmmeS6WxfK4j3MXO
         F3Ok6uJMKVvxYlphkmocINdc3gr3E+x20BR+IsW1555Ty0VLOyaTPWXmCzAXtWDIh9F9
         Qw+yWYigSpN41kAlyA5sVHH+H7LD+B2QU7SSss6CHizCtiE7rM3Nw9IBfa222wseZ6FA
         hhhK52LD1zRJmJAi01cwL/gWrChdmZxW+zS611ybfan5IVA5shxSPwP14nBoORtNhdCA
         tR/g==
X-Gm-Message-State: APjAAAWGia/URhHU0BzIflxl8VXFaY4WFMmzOC4ZL78i7HSunx9luGAt
        tTqHi6C3Fqo2QDZqKg6rv2JjJD84IxbPWNOVXkbF+ui7fbBi
X-Google-Smtp-Source: APXvYqxO00LLlC0E59VXlspGx5WEkQ2/lGhvq9JtGOFZlbtjoSv4GLYjpozDO1f5VgJgyv2k+3MwmO9OuUPzoUF9IW31DADJl64C
MIME-Version: 1.0
X-Received: by 2002:a5e:a703:: with SMTP id b3mr8643903iod.95.1583130609317;
 Sun, 01 Mar 2020 22:30:09 -0800 (PST)
Date:   Sun, 01 Mar 2020 22:30:09 -0800
In-Reply-To: <0000000000000e4f720598bb95f8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099fb63059fd95165@google.com>
Subject: Re: KASAN: use-after-free Read in slcan_open
From:   syzbot <syzbot+b5ec6fd05ab552a78532@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, jouni.hogander@unikie.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com, wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug is marked as fixed by commit:
slcan: Fix use-after-free Read in slcan_open
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
