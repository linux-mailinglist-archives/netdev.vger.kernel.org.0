Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099F43E5169
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbhHJDSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 23:18:44 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:41907 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbhHJDSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 23:18:30 -0400
Received: by mail-il1-f199.google.com with SMTP id d11-20020a92d5cb0000b0290224103389b9so1855439ilq.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 20:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5BRXu3w+C12fxdxN1C+eVxxxv4+y9P7u8pANMPW2JlA=;
        b=Nm1PFUhh8uuWZIM3Ihgunor2UNL/KmIurrihDyh5NKAPqFmGZep20zg8X/xlVly4JU
         wDzvKkgvPyjRJZB/1eD7Ci16djio2fDVC8GEEj0CCYJexOKyppdQb9q+JtGwyViqh15C
         1luiZrORGlx+OgbIYcG/2i33VCSbq+u94D7Nut8blh8kOPgg4M8eFrcg1hDulRoz7fTt
         Hlx23rCbzld1zGIm23arxWX5slQ8OzFU/RaNAPXFPC3Mr18llsswZqUaqyPflGslHov2
         0CBoxkI19I/2eHQe5CAQ/SoSIo93rn+rfdYCed3GaM4eBcgVMjka6BLTjErmlHbTAJx3
         43Lg==
X-Gm-Message-State: AOAM532niPDuO2rbVq4pHtsK6D0cO1eUilO4RF12hs6BKCt5jDYK0FN3
        P1Qxn3vOPbGvxxBYpCUIV9hiLiPGeOpL8+vqL6RY3yoTfLvz
X-Google-Smtp-Source: ABdhPJzSejOHZF2vwRQa08jvFtWilpXHY4p8/eqRrMxxZV+P6Xpydk/aba2JEJl1ObwHXQ0rqs6Y+cSJYd76Qvyoc+6FLgQKYkyI
MIME-Version: 1.0
X-Received: by 2002:a6b:4015:: with SMTP id k21mr139228ioa.28.1628565488642;
 Mon, 09 Aug 2021 20:18:08 -0700 (PDT)
Date:   Mon, 09 Aug 2021 20:18:08 -0700
In-Reply-To: <2d002841-402c-2bc3-2b33-3e6d1cd14c23@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071b06d05c92bf331@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
From:   syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com

Tested on:

commit:         9a73fa37 Merge branch 'for-5.14-fixes' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e3a20bae04b96ccd
dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12d6baf6300000

Note: testing is done by a robot and is best-effort only.
