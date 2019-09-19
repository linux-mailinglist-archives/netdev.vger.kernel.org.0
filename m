Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E21B7974
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbfISMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:32:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:51166 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfISMcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:32:01 -0400
Received: by mail-io1-f69.google.com with SMTP id f5so4924947iob.17
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xRvATBd4vJz/ca0H8KHxwpk25gX5YP7T2VKX90zZjjY=;
        b=GEDl48DI2Adub7VbhBlpDUimEW87CSkljswB7hnfXU7GOA9UboTQRMmAjIjT+TvvXs
         Xknddq/w/r85Tof8E0M3o4kiFG9rXjOniWn5Eu+7O19VsaXohfqPl4f5al06N76jlZeU
         sRT/2xl+M03esTzg6RCkFIACahfA93sXcPhhvA6bMs0kQBs79USy44QN9coJ7oLJIYsA
         9epxA0D2PWMCmIhodDj/bNf5jGcKu4xO3LjBArFVCePeY7QISIiasVj8PYYzvupo/DHW
         yynlH8I5XvxNN5bNEFK/mEFetIchMmYcYLwVRbxI4PapOfH5kpOvAHsk2m1bLfgtRfQ1
         7yxQ==
X-Gm-Message-State: APjAAAW64bpR8w2cEylZGqwT7yrX3eBXZLcdXWaciXrwOYXlnoDUdW1t
        LsKIb/Q9WQ7KuKKbUh3DDds02EFYY/xG5sqb58rmc5TOkPdU
X-Google-Smtp-Source: APXvYqznsY295KYp6iVKDsqG6sE+Z6Mre4W0acF8SRnsbhhSSg0DoispESLcXcx0yTSMXL8rH7pjSRc8Sz/uxP6+Ti76M+HxxP4c
MIME-Version: 1.0
X-Received: by 2002:a6b:b8c3:: with SMTP id i186mr12174261iof.194.1568896320918;
 Thu, 19 Sep 2019 05:32:00 -0700 (PDT)
Date:   Thu, 19 Sep 2019 05:32:00 -0700
In-Reply-To: <20190919121234.30620-1-johan@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5e3c40592e723c4@google.com>
Subject: Re: KASAN: use-after-free Read in atusb_disconnect
From:   syzbot <syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, stefan@datenfreihafen.org,
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
syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com

Tested on:

commit:         f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=f4509a9138a1472e7e80
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10f3ebb5600000

Note: testing is done by a robot and is best-effort only.
