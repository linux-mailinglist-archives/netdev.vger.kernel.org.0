Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874641046CD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 00:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfKTXAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 18:00:04 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:41567 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTXAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 18:00:02 -0500
Received: by mail-io1-f71.google.com with SMTP id p2so760718ioh.8
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 15:00:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ypoFC5Ro1whWyZkoNTFbjCm62awQmvPA/XY3KWGTpeY=;
        b=GsbV58NYvhot5jS5WDfHz/xgwYWjftrCGamwKhPi/KUcVRxuNoaRy8uB4dqMI2WJnd
         8K7xEHtqquw6OLWULPYEyOH+F49nI7PYWap+a9iogqXpLYPHvn5rcz+vdrn8uqhmn1g9
         h+Nhaf3WUu5RY3I50duFAKPYV/4Tsp8NDhOa9otB4aEw0YxiZMRrMOAlCmWtnlzzJe6E
         m0muW57H3NEJA1XJ4S9CKkSv/hHzricfscZu02ORw7OTxQR64PRI9r6QlElSfMazi0Tq
         rVO+y9ip80IVKIwzMy6ATuaPLkNObBw+9ebSAsj5gNhRG5R9UIOq9P6hOZfaML4G15Vu
         Se+Q==
X-Gm-Message-State: APjAAAUYBrl9npfz7dAEf7Yz7DsSiT+XubfpyRY38U3az0rRJH9xCT9U
        FYEZPBKIwnxgu7wWvPPxMQz+pSiUHxkkr0MbK3J1rdRcqqUM
X-Google-Smtp-Source: APXvYqyofe8WhECLKlKXZgBJZBsZrYVm/t+Y8eRSVSR0U/8UgoTSuC2z2cvX43ZBQGe1osg94jcabQYUuLJ1jeNst5ogvlPqNJZy
MIME-Version: 1.0
X-Received: by 2002:a92:1705:: with SMTP id u5mr6454619ill.151.1574290800348;
 Wed, 20 Nov 2019 15:00:00 -0800 (PST)
Date:   Wed, 20 Nov 2019 15:00:00 -0800
In-Reply-To: <1574170553.28617.10.camel@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed95090597cf2395@google.com>
Subject: Re: WARNING in ath6kl_htc_pipe_rx_complete
From:   syzbot <syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com

Tested on:

commit:         d60bbfea usb: raw: add raw-gadget interface
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=79de80330003b5f7
dashboard link: https://syzkaller.appspot.com/bug?extid=555908813b2ea35dae9a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=125c855ae00000

Note: testing is done by a robot and is best-effort only.
