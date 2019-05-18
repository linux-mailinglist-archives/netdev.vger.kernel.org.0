Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565122247A
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfERSbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 14:31:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56005 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbfERSbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 14:31:01 -0400
Received: by mail-io1-f72.google.com with SMTP id s16so8135289ioe.22
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 11:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5UxPqyqpEqIg/qruEb6a7Im9QP9xMl5nRiEBDpgwPDQ=;
        b=RnWk0ivuOjbIwSaWQZxM9aFaaHGOmcdFnzXiLJ468kJlflem1srsTW4gkLPBR1YRNP
         4cKCj4/77x3QzviCwf4+Emn1Jly6tykCmee2HwScK0isYJNyEFCsemsjJuGK8cm2r5Mw
         C1XCpfXje0OB3ZuximUFIHKihfgCBIq1vXwTOG0iFgftwOjmzr3VzPdp0TBmXY/Lttj9
         dv6AMnAbM/hpnU4RI6ZKFrxYaENsm/bUZ6WZOnyByT2qMdcKbMrk8QcNKLQOWGQ+tEoE
         BwC3AD0caD74k7wcX/vNxMyDFTyzNp9C63hD1FZcZV2ESREH4I9aMESF3zjQBAc4L7WI
         o7bQ==
X-Gm-Message-State: APjAAAVcePFbHwpYdfLXsmZS3lLeZxf3M8KnRSpK7H01QBuQRQme2pq8
        RTOGNfrFtv1k7nG0sZhhaSq+25tDfrae9a8LBANOLNrLfot9
X-Google-Smtp-Source: APXvYqxyoPxBCWAJcC7wBdzP5ONzNf8bm0M0WJRQqXxOkD/QkxdxnSlvE17v680NI9Hn+ZjaeUejDcigqV9rbTj2Ln+qA8flWavS
MIME-Version: 1.0
X-Received: by 2002:a6b:4e17:: with SMTP id c23mr9854089iob.178.1558204260940;
 Sat, 18 May 2019 11:31:00 -0700 (PDT)
Date:   Sat, 18 May 2019 11:31:00 -0700
In-Reply-To: <Pine.LNX.4.44L0.1905181346380.10594-100000@netrider.rowland.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000076047305892db3f2@google.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
From:   syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@gmail.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com

Tested on:

commit:         43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17e42018a00000

Note: testing is done by a robot and is best-effort only.
