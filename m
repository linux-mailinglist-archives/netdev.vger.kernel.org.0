Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035896F24A9
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjD2MYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 08:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjD2MYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 08:24:19 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ACD199B
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 05:24:18 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-760718e6878so119562539f.1
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 05:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682771058; x=1685363058;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3/O37jbJPrx0egQZizzBPXO3pOaEVKxAT/XL88r88Y=;
        b=WK4FhR7y8Ur4Sj0p8AnOiCDVnEiSWkr3z4JWaM9ephYjvT1u+/wCDDJIKojz79tP/C
         1p+SRUA9Zx7WQcQG7QOHJ74QPHyrXvJx+En5f0C47unkw+c8NqiUwr9oo0Lj7845tEXY
         C7KVopwnQ+UEtidFOa1JImoAZ6JiEu5tBfnV+nbTMAGb4JtNBUggeQgsusqm9985FY+Z
         PNEZwDJyjoVC1m5I+s9/57FMJjUcp1bSzNEDb7+ORCldir6uUvs1YJ5S9Gy7pFGy4+Xl
         ksZ+5XXbk6eaCXl1mV8nsBcLJ74f29LR/i3rR1aemQLf5sONwbVB4CaV9JK3QNOBI4pG
         ewnw==
X-Gm-Message-State: AC+VfDxqckyi36wgjgLdaFqWZu/knyoKaO2GiliqdruqhwnkB/uBZBfC
        3xsI7P6aP3HavqqKLF0C9eAVYyUGal2LjqIu+izwlLhqPJmG
X-Google-Smtp-Source: ACHHUZ7l6HMecdIv4PNQIwacEAZUNObjUxMAIuVjcofnPbIsMC/OYoKNcdTC38gpdJNsyY7RHnWBOWqj5/gSkJv5AP2TfCN6e+9H
MIME-Version: 1.0
X-Received: by 2002:a5e:8341:0:b0:763:91d5:1636 with SMTP id
 y1-20020a5e8341000000b0076391d51636mr4055924iom.3.1682771057985; Sat, 29 Apr
 2023 05:24:17 -0700 (PDT)
Date:   Sat, 29 Apr 2023 05:24:17 -0700
In-Reply-To: <ZE0BSJfjlJNE0WgI@shredder>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026535405fa78ab6f@google.com>
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in ethnl_set_linkmodes (2)
From:   syzbot <syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        idosch@idosch.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com

Tested on:

commit:         66863178 net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1106c0dfc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bb01a8d28d10570
dashboard link: https://syzkaller.appspot.com/bug?extid=ef6edd9f1baaa54d6235
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=138de410280000

Note: testing is done by a robot and is best-effort only.
