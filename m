Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A253D4325
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 00:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhGWWKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:10:38 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33645 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbhGWWKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:10:37 -0400
Received: by mail-il1-f197.google.com with SMTP id d6-20020a056e020506b0290208fe58bd16so1835257ils.0
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 15:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DaaaaLaBW1jmlP7RMEUt9dIMXSCUGy/U8gtZX+ytnqM=;
        b=BjahHyCEAabYyPOQx7mgAx5OrvwHyQ7Wb4vso58rXBdXWnmwxl9NKyNnFsNiAMGXhN
         2bmQpXCT7AKSNoFj8bVUCDgrL9SksESQY16H22b4GOvQQSiaO9qqFw8kZyKE52dGtaBe
         DFPBr4yDf5kQMjTDJRXR0WFBnRfSp3AiyzWp/0/hpSS2doKVHOMj09TTH5dFtTqgDyoF
         fUAAXrCStY0aOpmq7PaZff0KAug5QDDZUincGWq6Anfy49Bn59o7JD5QOu9tyJ5ReDkF
         yzKjG8UY8ZalSFa81erwEt1LQRAOx9pJdEFgSpG88FJc9mpCrVijwabUkJe1SJVqsa6c
         qs2w==
X-Gm-Message-State: AOAM530u1siACN0y3treOB+DxUPDAeXkvte8k9L1NxHQNfYatB5L5K7a
        nfFwMUIAcZMstz4SNWbnc+j7AD4SnXILvqkYPlP+7vXo+poN
X-Google-Smtp-Source: ABdhPJweXdk5LKw1isr4SDbMvL1cbkMhpSNQqGu3T3XT9SozL7genpVeOdqLMsTdl2BTZ1gxnhs5pMIqV2dyyp0c0dqI1H+ZhY0P
MIME-Version: 1.0
X-Received: by 2002:a02:ad08:: with SMTP id s8mr6092490jan.40.1627080670155;
 Fri, 23 Jul 2021 15:51:10 -0700 (PDT)
Date:   Fri, 23 Jul 2021 15:51:10 -0700
In-Reply-To: <20210723193611.746e7071@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d9aa505c7d23d2a@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
From:   syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org,
        frowand.list@gmail.com, gregkh@linuxfoundation.org,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com, rafael@kernel.org,
        robh@kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file net/tipc/socket.c
Hunk #1 succeeded at 1885 (offset -1 lines).
Hunk #2 FAILED at 1974.
1 out of 2 hunks FAILED



Tested on:

commit:         704f4cba Merge tag 'ceph-for-5.14-rc3' of git://github..
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11e7d8b2300000

