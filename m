Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B585842CD5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406544AbfFLQ7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:59:01 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:53799 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbfFLQ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:59:01 -0400
Received: by mail-it1-f198.google.com with SMTP id p19so5630343itm.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=w+d58fwxVEghqdBTL6OdFKQGL56looaKOR87EN5fMyI=;
        b=Nm3Sm6dVnjlSFsN4SXCkd0QydKKqCvQDFUXi8BIg124a5lbaMdrCa91BMZz233kEhI
         O/tABiW60PV0iZUbCzvxzaKqLf8Bz5CjsXHy6fD70AUM/K/jJdPJKxstiR6BtZBm7o0n
         EYPyCYYYnkmAwVXSR2dWZ2lUicnr1YaX3LcIZ4WjzkJYuSDUSUYZH1Xw2gHcIxnGP7DF
         sUUwZh/YsV+J1mR5sDPHOif5SOF7Jb+VSzbW2gpvAUYeo2Owr/3Smxfl65aX4VlTJ6+2
         b0ut9CVPGwlx2u1cHYLwnfJZspl6f/M8pVRtF3Gt5kOJCnxr4o61frAIG4h7yMfMD5Sk
         RFSQ==
X-Gm-Message-State: APjAAAX3str4aglP7pBgttn9wqrKCmuAorrBTnVxygHCPcGQ9b194R6M
        WUPUFWpWFyjDThw0ub8gviGrb7OggYYTNRTVt1LuR83gbvsa
X-Google-Smtp-Source: APXvYqy+d3bgPSksKj/GZ6l17+4OtmOMiusgDBDhfkPRefGdUEPiGlxdnCa9vMOOT8gqL3aVm/rMw7s9G7469ZfCQsjH5cNtRoZr
MIME-Version: 1.0
X-Received: by 2002:a02:4484:: with SMTP id o126mr4901697jaa.34.1560358740768;
 Wed, 12 Jun 2019 09:59:00 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:59:00 -0700
In-Reply-To: <CAAeHK+wpzHG73AbB+199-TN35Kb1kEjGrKScSqU++7q7RSUGGg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007741b1058b235467@google.com>
Subject: Re: INFO: trying to register non-static key in del_timer_sync (2)
From:   syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        dvyukov@google.com, gbhat@marvell.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nishants@marvell.com,
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
syzbot+dc4127f950da51639216@syzkaller.appspotmail.com

Tested on:

commit:         69bbe8c7 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
kernel config:  https://syzkaller.appspot.com/x/.config?x=39290eb0151bec39
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14171fd2a00000

Note: testing is done by a robot and is best-effort only.
