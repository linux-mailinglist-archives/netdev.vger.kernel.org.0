Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479F019E052
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 23:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgDCVbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 17:31:06 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36494 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgDCVbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 17:31:06 -0400
Received: by mail-il1-f200.google.com with SMTP id e5so8379521ilg.3
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 14:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SPAwpvKMvYbr6XxAGejDItd1iT8+uNKheRzWPuMzaNE=;
        b=rhqonKTYYJjnQZOgxdquZ+vxtHUzKf+JPTQhFRybOKM5KYNfuIj95AwAAPab7l60Jo
         tTDIcu0hp7c87FkJHimo4ZQ02RootEz5HeFVO7u6Xw+gRQdj8pnfjoG9Yc/46qx8s4Vr
         jKKkoBmOwcG9ENr+394D50hhJGPWbNMyWr0AJvT4sMd1EkkfJAiELXiKto/qvly68hd0
         02x2/lBdsKN4oLHjRRZaaR9OVM9LmXp2ZUNAWYFPEIDo1pOFwkcrOCm1HfbdLzkk7k8W
         gmWpJnhlKeCri8xVt6MhND/azYpQ10PShV/5xqj6RcfTQrmKKjl97j7FR869xvPpZI5M
         bmeg==
X-Gm-Message-State: AGi0PuY8j+mz2hy0BCQTarUCq66vTP64kL3Zn5SdseNP+NXhgIZ3m08k
        3NZEKOW5blJvHkYyGAqPAnHG1CBH1fGAW/H8927ypDonKFMA
X-Google-Smtp-Source: APiQypKtbpUx/vzWx0thrapB3XZjS4Im1jHjhnIpoPxECPWeYSgLiP8MWdcuJaBa01aC7/l5u2pJ7JQUYFzktar8s2Ldy/IUQ2JZ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1550:: with SMTP id h16mr9161068iow.171.1585949464055;
 Fri, 03 Apr 2020 14:31:04 -0700 (PDT)
Date:   Fri, 03 Apr 2020 14:31:04 -0700
In-Reply-To: <CADG63jDxb5zkvQwNn=M1ONCsEVZxZBUo8SzN86U01w4tQ5F4Rg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006fd4d605a269a296@google.com>
Subject: Re: KASAN: use-after-free Read in htc_connect_service
From:   syzbot <syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com

Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
kernel config:  https://syzkaller.appspot.com/x/.config?x=6b9c154b0c23aecf
dashboard link: https://syzkaller.appspot.com/bug?extid=9505af1ae303dabdc646
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15bab2cde00000

Note: testing is done by a robot and is best-effort only.
