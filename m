Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43A8B4D16
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfIQLlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:41:03 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54713 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfIQLlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 07:41:03 -0400
Received: by mail-io1-f72.google.com with SMTP id w8so1677872iod.21
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 04:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TQhhyZzw4ZIrhNwvPs/n5pRvZA2rc0RlRwXQQDytjlk=;
        b=ke5FReuW390W4hpTKVtbmVzJCcf5m9Bny8ZSR7oTcj7UXIEU+h3Ym50R/rQX31/a+P
         yTrGeJaH+4uurjrYnlDXQRTHAi3aXXgMWYtMaxMlQPcMlFQgxE865JmvCYOLnkiS8Diz
         m6V7dakOq76+thI07Opw1sP3f4Y7im0H7HufC1ZdWTf4m9FK+BfJzDHaiXCUhzOX7h9t
         j4MHEVgQvd4XVTGORPUZAxMrXhq6GBjNIL+vcT910eG3uOknomhSRgDbrQcTHSdlyetu
         v2IxjeVvfm2zTVLTeF6f5k6DDlT3GQP7syGUF1wGL4F4md+TU9IJ3vrYchzN+cioshSr
         aS4g==
X-Gm-Message-State: APjAAAVC6u5bmREbxMxv65CuI0lqQAHQpLaQDdanMe6fGk7s+i0Sm5qI
        7Ca8VLFwNhHZwtmruzNAQhSAL/MEwSOUPslN1xV5Mi0Vx0Hm
X-Google-Smtp-Source: APXvYqwbenYfz+8HvwnLFDOKoiAoxlPm+66Jbx8olwWU83VYq6sGheysqWYQO0WVHRMdPe+OjJsMSZuHPvPXxStFJVjfulg2ZCMU
MIME-Version: 1.0
X-Received: by 2002:a6b:b792:: with SMTP id h140mr2782768iof.225.1568720460772;
 Tue, 17 Sep 2019 04:41:00 -0700 (PDT)
Date:   Tue, 17 Sep 2019 04:41:00 -0700
In-Reply-To: <1568719373.23075.4.camel@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d100350592be31e7@google.com>
Subject: Re: divide error in usbnet_update_max_qlen
From:   syzbot <syzbot+6102c120be558c885f04@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com,
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
syzbot+6102c120be558c885f04@syzkaller.appspotmail.com

Tested on:

commit:         f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=6102c120be558c885f04
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=148689be600000

Note: testing is done by a robot and is best-effort only.
