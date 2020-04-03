Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E496D19DF68
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 22:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgDCUcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 16:32:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38759 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgDCUcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 16:32:06 -0400
Received: by mail-io1-f69.google.com with SMTP id x20so7186889iox.5
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 13:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=w8mFdsMhO76bZFqWMwIe+0AsU+lplHC+HdX5ScRWf2o=;
        b=NiTEHHb57Ts6WWVg1klNeh3ZknKysXg4yJCX+o84jH6Vp0OCGkT0k13GRxsckkg0N6
         EN9QDbXn1UtYlUYNQlXe3G2MRP0hgMlFponDNMB76yN8Sb7CI6mFAn0Lj8o8FBMbOObl
         km4jc/H6Wvpf2b0e6kbKBXhg0SAI8nUmb+Nv9tOX9qVyB6KxuP/j5ngBQWa9NKzs9g75
         g1KFKLDGyphVY3TW8Au+zM2D59lAq8m9qCiCcBio+/zulgaUvyMz5IIEgbvuUUUqhTyX
         cRB5hO2wInPgnIIK8YWyc4ye8guKgIkFZDkRIvBMmmDgti+cmT7H7sSXMq2Rpxc4h0VW
         k3RA==
X-Gm-Message-State: AGi0PuYLfclpr03cbZOVeuQNq9AGQdJCVxpVF7VJ7A5WWCwzn7tmT/m1
        j+5Fh+OWTcoGb9yS5mRANB+MWAZlX1TV82hLGZ8qgxXDKa6I
X-Google-Smtp-Source: APiQypL7/jcPzgJ8/OUT0G36YxdR1mbGZlszf4LQ7Ts2iHfYZMZCQYXEICwC6jd7nw2CDDArjKeiPzryS0MxWW+sw+5fXTvdVwjx
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:790:: with SMTP id q16mr10888997ils.295.1585945923666;
 Fri, 03 Apr 2020 13:32:03 -0700 (PDT)
Date:   Fri, 03 Apr 2020 13:32:03 -0700
In-Reply-To: <CADG63jBkWfxOSsJ=7FkB-6ScdW48VPJZLV2KrhCVLjVRCASzhQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069c9de05a268cf5f@google.com>
Subject: Re: general protection fault in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, anenbupt@gmail.com,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com

Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=40d5d2e8a4680952f042
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17b013b7e00000

Note: testing is done by a robot and is best-effort only.
