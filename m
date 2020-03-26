Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3647B194A77
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCZVZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:25:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42203 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZVZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:25:02 -0400
Received: by mail-io1-f71.google.com with SMTP id k25so6586640iob.9
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=R0UtT0wl+/DHJxOHjaoWbQcF3VR+MnxFmO8PugCJFXM=;
        b=B+rMHjXEgc3eMSw412owrCUZh3CVpoLmJm3BcZSOPRjCUj1/tdgLue1zL7s4f0zI05
         FuaPPiCAAElU9bfUHWUJkxTDbR6i//j950IjIbt0DDDJEa2G3AVq+Z9UKgeEK4U9rOHd
         s3YwNjiw9htUyOgiV7no0Yf+y47iqjwQzpN4sA1eklWsKXocPGkXPToSswYHpZaIMqZJ
         2DDUT+/JcMXQwgBle3D/xE3fuJCC2Z80elcYd2+zDnqJFBatRgRTc85AwOQPLawKLZQx
         zswAszsRxlVUScnUSZZLCIT/oTXSs3mAvdVp49tzjWttGTcTy+GnYS3UqToPP4lKwjaz
         S5/Q==
X-Gm-Message-State: ANhLgQ0ry3aeH7CoucERoZDQ3zeM2VlHNmW5yh2udLDwyrKh3nt73bED
        bwR9xd1K+T5MJmB9tavK+DYxMkuJEPkFsWy9FOlQUrzFIZyU
X-Google-Smtp-Source: ADFU+vuq1ZdA15x+aWbKAF5XR3OUgPZocunA3rxU2f2eixsCPsTJVpYHE8hrML1m+H2C0/QHibYoQEO8qicie9S7k8eG7C6Y0h32
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3a4:: with SMTP id z4mr9602598jap.141.1585257901712;
 Thu, 26 Mar 2020 14:25:01 -0700 (PDT)
Date:   Thu, 26 Mar 2020 14:25:01 -0700
In-Reply-To: <CADG63jDGY1dEQ9uS5Cd9q3DeEKWTff-4FC=UiEBpuh2caSLwOQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bedcf05a1c89e96@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

Tested on:

commit:         9420e8ad Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ac76c43beddbd9
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1670bfbbe00000

Note: testing is done by a robot and is best-effort only.
