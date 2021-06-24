Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5933B3704
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhFXTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:32:31 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:54157 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbhFXTca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:32:30 -0400
Received: by mail-il1-f198.google.com with SMTP id f4-20020a056e020c64b02901ee69c9b838so1089571ilj.20
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4GffdjDqZnowU56j73n2EpB/mSqgSUg9fkkvywwXGWo=;
        b=JEjZG84VvKiAK89xQO4UNSaJRgxdBMW6WZOtz6yADe2msUrfh16MomsSKRg99RhXvQ
         h4f+pVVKJWb50TwGSz4qwZAD9MPJgoc1lBXQovMgvltZUh5bQvWtEaYLfrZaResuI4JL
         mUE3RFZycY+7isJtu/+ouUHAtjIsbEt+utnm1i9/45XcMbgSIvyNLwOKMT3ctNR6kRVD
         xLDIWOMBVDkAhd/yh6iILXt/ylpxH/t1G12gWBSkzDG0aRxSikcdyG1XudSS2VSL+EH1
         okbp0QCZx7C/QSBTqCU2hLSYa4SzfMaqtmJGhNKVPXWAsRmIL8Tw6ay50lngC8ySpZFF
         JdBA==
X-Gm-Message-State: AOAM531ugNwTyHwfzOn3ejRh7inoRLpomkf9YLOFswKlCWNHPZweaETt
        Fb9oAaqhcIntRvqmtJNzrWt53QFWvWP5UjtYoEhXFWQBTLXY
X-Google-Smtp-Source: ABdhPJwWipLKwHeSiEufevAh3Nge4R6oY7mbwMwSHc2nPMIq4fjeo4QYOzfYGF9eEJI+PQWT0zYAo5nLYRQmNybNfIK1K6Hqgu7I
MIME-Version: 1.0
X-Received: by 2002:a5d:8986:: with SMTP id m6mr5370913iol.87.1624563009800;
 Thu, 24 Jun 2021 12:30:09 -0700 (PDT)
Date:   Thu, 24 Jun 2021 12:30:09 -0700
In-Reply-To: <20210624221244.3529b808@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d4e9805c5880db1@google.com>
Subject: Re: [syzbot] memory leak in xfrm_user_rcv_msg
From:   syzbot <syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com

Tested on:

commit:         4a09d388 Merge tag 'mmc-v5.13-rc6' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=be86be9dadf57eea
dashboard link: https://syzkaller.appspot.com/bug?extid=fb347cf82c73a90efcca
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14c17dbfd00000

Note: testing is done by a robot and is best-effort only.
