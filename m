Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4627F990
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgJAGkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:40:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:55478 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgJAGkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:40:06 -0400
Received: by mail-io1-f71.google.com with SMTP id t187so2899279iof.22
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8ZPUiK5xIdDCc0xK61WpBqqfUj8VzeTeMVAnJhuRkZ8=;
        b=cXoM3+nWPgUSDuNuCI1ENj31b830/c+Ir33ETKApHXK2n72aC6pqp9rwZTD3+Ecjcz
         pX/TMeCd9PsLPbkM15BQqHRdPmyT10ksO4bSyT/dOeVFZhi4rV0laxIwoJI+iN9DQtXR
         v08j31ztmVnK74kUteXrNxGAzKyhp9+cbu3B7cEhZqEOLhBlxOOb2N2vjxYaMps3TTcS
         uHAPta4rHPSlscwdDNY45bhoyp7delLyffXk6CatVbqJj13AmAUHzF7gIoKIlZ1KOcMC
         n6avg9mIStLn1uGc8DxjoEAqPd+Blc2dGCd0vRwI/oDmTze1jm/V+5iDfktSI2ESkiBE
         rPrA==
X-Gm-Message-State: AOAM531oF0hFIseDLst/iL5o6AjnYBbbBJ1oVhMJ2ov5oRczUvtDfQeL
        URsG2M0PPWrbmTzLEX+LH4NcNATBvzKDGaNLi0+iZsq24psK
X-Google-Smtp-Source: ABdhPJyCUXV1Atqih0XfjzbZqhinetrnbdIcc4dxtZCg5vcKg4pgutDDshPeQdie+3XeA2qiuKejW73TyENaFORzM7nYtxliq4Ng
MIME-Version: 1.0
X-Received: by 2002:a6b:d60b:: with SMTP id w11mr1882148ioa.198.1601534405596;
 Wed, 30 Sep 2020 23:40:05 -0700 (PDT)
Date:   Wed, 30 Sep 2020 23:40:05 -0700
In-Reply-To: <CAM_iQpW+_5wLteCoVc6Wn+z9WOp6FwVUpsy456hM+up0daxedw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000575e3405b09649ff@google.com>
Subject: Re: INFO: task hung in tcf_action_init_1
From:   syzbot <syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com

Tested on:

commit:         d5b70379 request_module()
git tree:       https://github.com/congwang/linux.git net
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=82752bc5331601cf4899
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
