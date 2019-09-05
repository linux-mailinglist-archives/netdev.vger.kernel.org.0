Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27CAA1F5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbfIELrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 07:47:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48654 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfIELrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 07:47:01 -0400
Received: by mail-io1-f69.google.com with SMTP id p1so2862846iom.15
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 04:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Nuyvp9vyMVnR3ZMhOYe+0oKwj4ltt2pST6dZGPPFdDs=;
        b=t7g/TfSodM08phUab8Jzwkw1R2gGy15lZlpKBE52bRsJgk+RecqK8jKIiYiVnyi/a2
         P7RLBFBbsh5dgsTCZJpgTf5U4GYidcjskxuOEeizaTKslZVLY78RzuBhky2c5xwS+VZy
         A8xQmjf3NEGBhCsVU8TMo72+rIUV6hHIRYPzcEljOhBXAWMKbLtj6O67sl56ys9CYnTm
         eqo6h6EV+B9uozlECm3KUb4mtkaTf4+riRKuItQ29NVVBJzrmb+cAAcFL0ZWQIw6BxQx
         oHOkXYSU/ysZyYPFXUroB/Wq4wF1JqDnmi3fPW2M1Pz1XRVOclEkoGg8FXrv4roEmGOM
         ZLMQ==
X-Gm-Message-State: APjAAAXQoIX1VZL0xR2WX2GQ2CXGpXYJ7QplKQkqFCOS0q4NfwAr45LE
        YV1AR4b0w0THfAtesEudKVavvSee3ycYoUH8gTKNthEsMtM6
X-Google-Smtp-Source: APXvYqwXx5xVREHqN2GcbqE+Tt8E1onLoKBKAcj+sRYuDGmkwww2a9nv2C6YStKt8wJGXh8WFQyP/WmdeP9MEZWuHR92/vOHwLjw
MIME-Version: 1.0
X-Received: by 2002:a5d:8599:: with SMTP id f25mr3413002ioj.265.1567684020483;
 Thu, 05 Sep 2019 04:47:00 -0700 (PDT)
Date:   Thu, 05 Sep 2019 04:47:00 -0700
In-Reply-To: <CAAeHK+y3eQ7bXvo1tiAkwLCsFkbSU5B+6hsKbdEzkSXP2_Jyzg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000293ed00591cce18a@google.com>
Subject: Re: WARNING in hso_free_net_device
From:   syzbot <syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com>
To:     alexios.zavras@intel.com, andreyknvl@google.com,
        benquike@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, mathias.payer@nebelwelt.net,
        netdev@vger.kernel.org, oneukum@suse.com, rfontana@redhat.com,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com

Tested on:

commit:         eea39f24 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0c62209eedfd54e
dashboard link: https://syzkaller.appspot.com/bug?extid=44d53c7255bb1aea22d2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1188fcc6600000

Note: testing is done by a robot and is best-effort only.
