Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA97E68D6B5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjBGM32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjBGM30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:29:26 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCB137B4A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:29:18 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id x12-20020a5d990c000000b00707d2f838acso9086011iol.21
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:29:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1W+bbvxJgd12cdk+HzCNvM6Y1Uq2EiGGlNY/VqYlGM=;
        b=oUFSBUjl89CEoqDhKehi2YyWOTXl4R34dQRnAHn5oSXNBB/4xc6L8aO1AcaW676pih
         N+CCIG+BgI9ej89L+AjycX+dpKVaVQw+YgO3sR8Cy5zbhSkJ8lKfivAIL2Hgc7eIotHX
         5PPzOlEdDJfpqwO0Z+6wWPsBFBys4kdnZIWpMib+3W/mawWFz526+9I790ZIEQ6+bIga
         FSJiy/we0YVEgkBc6Qs1ShRxttUNTHw9GsgsCxXksdqF+4mIimVeDonavOf6RX8+a0de
         tuxIn7ECb5fpqaGwGTluG3+fY5Wkw9Qt8Ysx60v3NcCgT6Sw0lv2OXw1s8TDfzyDyHjO
         W1Fw==
X-Gm-Message-State: AO0yUKV5RtRiDfrb++T5bJyMX061ZXZzKNNxdJzq1a7oi7xRoTYox3J2
        EhyCWCUrRTuB4kvnHqn3bRbZTsgzE+hbc0QdbAmKvp3DXj2f
X-Google-Smtp-Source: AK7set9BfIqmXKJuVCgSNu40g5dj8NebV5qafrX+xTsJgnDdZLhfs50tFXXyDG2i3TeGcBkmNQdkZgWy1rDNSN081eIWM1V7EB+F
MIME-Version: 1.0
X-Received: by 2002:a02:c774:0:b0:38a:a802:cfe with SMTP id
 k20-20020a02c774000000b0038aa8020cfemr2661282jao.45.1675772957734; Tue, 07
 Feb 2023 04:29:17 -0800 (PST)
Date:   Tue, 07 Feb 2023 04:29:17 -0800
In-Reply-To: <3104641.1675768952@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000debe6505f41b4b9c@google.com>
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
From:   syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        hch@lst.de, jhubbard@nvidia.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com

Tested on:

commit:         e7b5bbb5 iov_iter: Kill ITER_PIPE
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/ iov-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=129d541f480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=318265a8e536ca3f
dashboard link: https://syzkaller.appspot.com/bug?extid=a440341a59e3b7142895
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
