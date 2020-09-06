Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696EC25ECFC
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 07:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIFFbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 01:31:09 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:40053 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgIFFbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 01:31:08 -0400
Received: by mail-io1-f79.google.com with SMTP id f8so6403510iow.7
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 22:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=AkAlyJgLNh08fM+adXYaVRQxqHnsf7ozrxDfshPlvlo=;
        b=iuhqogDk40Ni/JMch8nHBdEcsGDUld4OdwwumbEFYOh37D0NZzK94X87zuZMxI2xtw
         kZKMDfMQ5GvXuGDZHuBU8/1lo225RJrKPO/FrLamWAuqqGfYVpWo5pvy6nrxdE1yPhGQ
         pP77z81f3OhFBM4oC6KR++EP6fCYax9LMNDfN/QKDuE3pxo0K6Io7ZJlrRYqXV5OJJ2f
         5ldHcTsfiXqlAYE74oEYguiT/55G1lh5sIvMXf+ha4DmS0hqhyIvMLlimur8f7zuEHrb
         jMqcRb91fwQh2mErw7JdLRhcAtJ/B14Sid6FSIpttbafPxHC7rNJwAM9L952G0gvm9eh
         WAcg==
X-Gm-Message-State: AOAM530gg8WLtc5l7JbrAccpeBwGBAy834TFOz0KXJNRH/SFuZ/JCvxU
        gwWFNtg4e7AhdUlq+NK+tOgEQiNwdCZdfV9fnI8iCtpWk8bj
X-Google-Smtp-Source: ABdhPJwZOylw0u4Wo0Y6MQf20PT2tvuW4TXOi8u8DYia+/JL+8Tk/MjaNqQtmwfTZ13rTOIRf/mXOEYmGdgD6b9BLhL/1p4LDdw/
MIME-Version: 1.0
X-Received: by 2002:a92:99cb:: with SMTP id t72mr14005144ilk.172.1599370267186;
 Sat, 05 Sep 2020 22:31:07 -0700 (PDT)
Date:   Sat, 05 Sep 2020 22:31:07 -0700
In-Reply-To: <0000000000008b9e0705a38afe52@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3de6505ae9e6831@google.com>
Subject: Re: WARNING: refcount bug in do_enable_set
From:   syzbot <syzbot+2e9900a1e1b3c9c96a77@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, abhishekpandit@chromium.org,
        alainm@chromium.org, davem@davemloft.net, hdanton@sina.com,
        johan.hedberg@gmail.com, koulihong@huawei.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, mcchou@chromium.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b83764f9220a4a14525657466f299850bbc98de9
Author: Miao-chen Chou <mcchou@chromium.org>
Date:   Tue Jun 30 03:15:00 2020 +0000

    Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115a4245900000
start commit:   fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=226c7a97d80bec54
dashboard link: https://syzkaller.appspot.com/bug?extid=2e9900a1e1b3c9c96a77
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b3efea900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11131284900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
