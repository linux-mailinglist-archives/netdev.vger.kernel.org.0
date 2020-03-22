Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE918E66A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 05:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCVEpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 00:45:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49679 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCVEpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 00:45:13 -0400
Received: by mail-io1-f70.google.com with SMTP id y20so8475802ion.16
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 21:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GI4GkIJkW1bKRzFiBtT/34jbKoBVKx5WZcrXpE1yJ60=;
        b=Of2E+06FLe31c9luHhpOQqaQMkpO2b6b1aX9NhkzNLZToDfSsSO7BQRuFQ8ZjHNehx
         mA/lBwvHj25hkev/YCZ/mJiOdKgdurFm1ilVuhasROWez4Xi8aswYa9abpGmOUGzvLDO
         eZ6QNUlwxtCeH9jHY/asRDQQHZO7sqRoqsmxYddNiCYzuo67J1NfTSCr5iQVAADg5No8
         kWpwVXAIl619UGwP5GXkAaAkyfJiJCBk+9BwyIeXY/pC6UR3Q+vD5teuvvRudnxV+Y0E
         xZPUkJiNTCLAz8af0pIROw562X6zv9TinjUNv7eHd2r0LiGSktJupO4dZBmh4tmRlj+S
         FAOg==
X-Gm-Message-State: ANhLgQ25GdTJPrugK82GAxwpha2xOGZXcJJRGqMh7BV22tPROU2UGatq
        tzc9DL5YStpxR2lvwZi/OcedBRgqD/DAaAJCH+jqg4n0myLv
X-Google-Smtp-Source: ADFU+vsJt5RAxUckaqjG5zRClhUofRtFleFv8EV/BOf4ia/aNTZI5251vcnXqewrTdJPZ9LxYOHay+p6Ei7aFnsYFXYRUdY460/d
MIME-Version: 1.0
X-Received: by 2002:a92:9e99:: with SMTP id s25mr14982996ilk.306.1584851942582;
 Sat, 21 Mar 2020 21:39:02 -0700 (PDT)
Date:   Sat, 21 Mar 2020 21:39:02 -0700
In-Reply-To: <CADG63jB59ZXWSUFKieXKGGEbPT9=z5OPARBjGqMgfh+K-k4-yQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f2eea05a16a1979@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

Tested on:

commit:         e76397e4 iterate datamsg list
git tree:       https://github.com/hqj/hqjagain_test.git sctp_for_each_tx_datachunk
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
