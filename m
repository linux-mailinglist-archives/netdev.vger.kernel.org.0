Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80103D83F1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhG0X2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:28:09 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33683 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhG0X2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:28:08 -0400
Received: by mail-io1-f72.google.com with SMTP id l9-20020a6b70090000b02904df6556dad4so428222ioc.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 16:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=o+xohfaKx0eRBXKeZWoG/RFdPcbzbopGddR2do92Akw=;
        b=kqe9iXWalt+4UYh+BNizDFKK4D2EXmoeaOv8OGRjzn+iiMvcajXapfjkYslEpNwpeR
         UIJULo3K5plQE+F3M3NaHoQezmhntVmOoZkZz7H074VQLk84F9JkWHAJPm0LpFTmJRzk
         QHUmIyfQzmRuRSbVMa+19bBj859l2RJGU0Z2PCnGVR5haNgQIS446aH/MKBbGoQuBmU3
         MD9qX8EKcRDVlHk6XFLNjPCLn9fG0GWKUStS6/6RyB0pFZDa4aedODDUyJUSSPBFejuA
         ZmpQFRPviG3BZc2WTPhQAqXZqZmD5BCthwvdo++9loUrR5Jhr++mfKdN2nL7GCc4qbFe
         yq5A==
X-Gm-Message-State: AOAM531M3VE9PH5AvQITOo3EYbV/C8p8Jd+9B26qHaUNN7chy9Fh98W4
        kho0lSaPO2CVas7iTJEJJmFCzG3UuOPTT0hWhOHkylDSlLAJ
X-Google-Smtp-Source: ABdhPJymsLUnghnpljxzoV3XPtlT7OCAGWIsKe3mEd2UVlAKDQBBXJBylRL1TGFTIMq7BFjxAs1v2Maaoa9ch7uR9CkMjdnG7peU
MIME-Version: 1.0
X-Received: by 2002:a92:c04f:: with SMTP id o15mr2041189ilf.156.1627428486474;
 Tue, 27 Jul 2021 16:28:06 -0700 (PDT)
Date:   Tue, 27 Jul 2021 16:28:06 -0700
In-Reply-To: <20210727174318.53806d27@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5736905c82338ac@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_set_default
From:   syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

net/xfrm/xfrm_user.c:1977:2: error: expected ';' before 'net'


Tested on:

commit:         42d0b5f5 Add linux-next specific files for 20210727
git tree:       linux-next
dashboard link: https://syzkaller.appspot.com/bug?extid=9cd5837a045bbee5b810
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=147b8d0a300000

