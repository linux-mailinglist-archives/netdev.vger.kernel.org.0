Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C0123C6F3
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 09:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHEHbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 03:31:12 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:37055 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgHEHbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 03:31:09 -0400
Received: by mail-io1-f70.google.com with SMTP id f6so16790026ioa.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 00:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UAjlV35CqUYg8Wq8iE9joWFodTfiF9zQm++Jk44fcSY=;
        b=EDyRbimd20G4sR9s5WCrzx8kQFq1o05qct6/0rQwukFPzVCWIqSZvumRB0m0D1q2PT
         LO8Woib9tvSRnxHczjuIppxnK7sXlwg9gYl6EqGO6bpf48LCzltWhQIUSVPZrt4eceUZ
         DRpqcF67DsUrGESj+soUC6jezO7D2nSD0QIqnnZA8eXlOIM5rdHhRA8DAT/w0pY0IpT4
         O56PIHueE28raITAXTfz9vGPRIhAlhHilmDKbtn4tuNQh+jaU9HL+qRbCC5TkXmOeWHK
         HEPXcTrkArI649MufrRTzOcEO+4bxrRCsTLXvk0xLUajxSghBfIYyJxpd7N/m983qQl3
         wzXQ==
X-Gm-Message-State: AOAM531VK3YhtDNcxVAGeOMzousQP/NoZe0nJQ88dg6c83iZKsZD2grV
        CBtshkoYWzGg8msp7QuM0yfuNDfVyv2/Kk8+CeBEuDEcV4lY
X-Google-Smtp-Source: ABdhPJydINKXG6kk6Rt5Q7YptVJc6WU2HIGHbqBbyEup0nCj4eB/muV9ogT+bIQJk1+5SdRMqrFrePgB51/EIuvRRPKG7IPv2d9A
MIME-Version: 1.0
X-Received: by 2002:a92:1b5b:: with SMTP id b88mr2679375ilb.104.1596612668103;
 Wed, 05 Aug 2020 00:31:08 -0700 (PDT)
Date:   Wed, 05 Aug 2020 00:31:08 -0700
In-Reply-To: <000000000000a39e4905abeb193f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed214e05ac1c5ae8@google.com>
Subject: Re: general protection fault in hci_phy_link_complete_evt
From:   syzbot <syzbot+18e38290a2a263b31aa0@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, johan.hedberg@gmail.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, kvalo@codeaurora.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux@armlinux.org.uk,
        marcel@holtmann.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit b59abfbed638037f3b51eeb73266892cd2df177f
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Sep 15 13:30:03 2016 +0000

    mac80211_hwsim: statically initialize hwsim_radios list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15dd5f98900000
start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17dd5f98900000
console output: https://syzkaller.appspot.com/x/log.txt?x=13dd5f98900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf567e8c7428377e
dashboard link: https://syzkaller.appspot.com/bug?extid=18e38290a2a263b31aa0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e4e094900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1143e7ca900000

Reported-by: syzbot+18e38290a2a263b31aa0@syzkaller.appspotmail.com
Fixes: b59abfbed638 ("mac80211_hwsim: statically initialize hwsim_radios list")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
