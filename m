Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0E3E9DE2
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhHLFTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 01:19:36 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:46663 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbhHLFTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:19:35 -0400
Received: by mail-io1-f71.google.com with SMTP id r14-20020a6b440e0000b029057f73c98d95so2818588ioa.13
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 22:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vAYClqij0nGxn6pQX2zV5X7oi626A4U9/u4hsAbCSsk=;
        b=driJvolWP/a5qTT/NF7PaYCkCyjemNRXOy2Yr4bfKOkVrCSNfPE1kpmyRfax4uuD8c
         lTGO6s3oFIXOJRGF4jG1JPWTZcGX9ZLh3uRxlGnv0/5AgCuALBe4huIX+t7MLWqZj/b1
         HV7xpGd372B9UZhjGlam0AvnqxVD9FtWQsKRNpR3EejN832yhb+QzFdDbYSXt44oWn6G
         2melaeg10NEJf5wt6qU8oHmXg7x5s5tF5SWt4P+CxC3ex7nc9qPiPe0RRiNz0RqUFxNC
         jTml7l1BCpM9TQE7FHPURcI8WqNTzLBWIxLs+w9yvMv83Gw84fZprV4RFfAda8H8Yrvh
         Szcw==
X-Gm-Message-State: AOAM532cp4DF9RrWAMJXoi+EZP1mLeIWH4Huk8LaJap9HrAHzb39wyEn
        mxcVsjvLHFy6Xbpqi7VwZmbMJUHha2xFrSR6FrKkGxuxaU7K
X-Google-Smtp-Source: ABdhPJwKnImalox7HdHKi7x9YHaW3z1Q/MyGYUO2gKpwVxsARpknotR0UEuiqgT7eCH1tXhs/b0QjX8Urm5c+ETchZAr4asAvYIr
MIME-Version: 1.0
X-Received: by 2002:a92:b308:: with SMTP id p8mr1541359ilh.296.1628745550454;
 Wed, 11 Aug 2021 22:19:10 -0700 (PDT)
Date:   Wed, 11 Aug 2021 22:19:10 -0700
In-Reply-To: <20210812045047.2548-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6e6b305c955dff5@google.com>
Subject: Re: [syzbot] memory leak in packet_sendmsg
From:   syzbot <syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com>
To:     hdanton@sina.com, linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file net/core/dev.c
patch: **** unexpected end of file in patch



Tested on:

commit:         761c6d7e Merge tag 'arc-5.14-rc6' of git://git.kernel...
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=989efe781c74de1ddb54
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=147a5779300000

