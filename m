Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04473987DE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhFBLUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:20:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36621 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFBLUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:20:16 -0400
Received: by mail-il1-f200.google.com with SMTP id s5-20020a056e021a05b02901e07d489107so1298329ild.3
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 04:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=fUuOkxrIdoQmAb56CsmjGA6rmm8IFaIzsgB206kzii4=;
        b=YTTQRf9tBvqvsrh2s1t1tm8RDaGSy7UiGFYitXM5s4ZUDt37lZcYwPO6Wo3SYORUwT
         JXkUt7QbjD9+Rxm1T+5vqpojNEipRAmJLYzkibVN07T5Xodkl38kl0SjKZ7/TrME1c1i
         MoQzeWk3vH9s0qHT4J/cnhnT5tKgJsyYBf1+ZKOOM8yNHLeEqqbo0bsFPHdZxTzQulrV
         IyBZhvzFhcRC0XKhTrDT/45A199/1MrFwEuZQDBVENLWGLM2tvzco+yUVKdqCyJCarvl
         9Wx0cV0IKXYV8EHDz9t98IdtcgOrfJFRdkFWQlto1gwQQZwuYtp+sUjR5qlsiROlaZNX
         04Zw==
X-Gm-Message-State: AOAM53022ThfVaPI6teH03yKd2TYh2Y31YUVbZQk3vrymcRWfMnm55/B
        bZ6dpIDYMye3DvafZDP+FrIRL3WhTif3T+AU9eoXXVvkiA3L
X-Google-Smtp-Source: ABdhPJz7V5+svtllpxH9nzf4ovxVaVuS5+ylKIbKxC0l1D+WwRHYpJWQy/Nm9+9mMbCvDsJopVTIjAVhfqs6ZSYfC97n2tcnqNcJ
MIME-Version: 1.0
X-Received: by 2002:a92:c5ad:: with SMTP id r13mr14881585ilt.238.1622632713370;
 Wed, 02 Jun 2021 04:18:33 -0700 (PDT)
Date:   Wed, 02 Jun 2021 04:18:33 -0700
In-Reply-To: <YLdo77SkmGLgPUBi@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b451b05c3c69e4d@google.com>
Subject: Re: [syzbot] WARNING in idr_get_next
From:   syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     anmol.karan123@gmail.com, bjorn.andersson@linaro.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ebiggers@google.com, ebiggers@kernel.org, eric.dumazet@gmail.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        necip@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> #syz fixed qrtr: Convert qrtr_ports from IDR to XArray

unknown command "fixed"

>
> On Wed, Jun 02, 2021 at 03:30:06AM -0700, syzbot wrote:
>> syzbot suspects this issue was fixed by commit:
>> 
>> commit 43016d02cf6e46edfc4696452251d34bba0c0435
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Mon May 3 11:51:15 2021 +0000
>
> Your bisect went astray.
