Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF5BB3F3A
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390183AbfIPQtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 12:49:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35375 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfIPQtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 12:49:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id a24so335282pgj.2;
        Mon, 16 Sep 2019 09:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7qUWOCQv295QFg+kgQAJCdA5yUvErYXEpf5sx/e6XU=;
        b=AccxtUY3qK7DBSc5mPgdjoEFUUwFSbVOWkIiZa3Pmed9s8B+Jq2cAj8vs9ZxCbEuPQ
         +ObMojKzV113QlCwX3fdNfFZqpBxVg3+/dinNe8bpDnb4aXMqwXrtztLO1ArIkGalCXf
         7ZcchRzkgPvLfXiuim6yLSV8DDntHLpxeIbLMuSC69hOVTr6Utoj3JV4YJwQ44DXPyh3
         gwyBl5Uw4dR4PpvzgmQQNZAIIuDB1ybE8zDTbWVAdcx7JX4xuZ9YeSjPOTC+G+OEd4Kf
         kmbRjkshIqP2VkU/jGT8VwpRm9zzTJsqSZUpmvAIOvFPcORJL53qE/Q3PD+O8Nr8loc2
         KwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7qUWOCQv295QFg+kgQAJCdA5yUvErYXEpf5sx/e6XU=;
        b=RFA+gak+hD2Ku2FpwOR4BnvMxL/jn9Pr9Y55RqoEe1KXM1H0A56bXfa18+GBhBCBW8
         uNQHFlrkaM9S/G4e1ItivKMzr2rBo+qb08T5if2VEddI9esLGrzGRlgHh15Zgw9Bj1Uz
         JGrqQsE9nxk+jAL2IW3kgH1mny55PK91B4sK58EmN584lhqaWEBubt9Y2VXMIqnYREep
         Zmrl8iipddr4NQvH/P4lUC9m67rqKwkGYJuOJfqImMBabuuJQM+GgQb2ee5cNayyFyiD
         +6Ty0IVBOryuyYVW6r1YwU54dvxSpE3E+r+NvR5zO+fvulz5eBNBElxiIgl+pmGSykDb
         SAGA==
X-Gm-Message-State: APjAAAUk0gvqqkPTCptYuRgEcahyEuOx8G2So2dUzeOVBgWX2u6R5LkN
        RZmHTUmz7v9Qk8mcwKXoVU6MK6aSetUjkwok9CRiI7On
X-Google-Smtp-Source: APXvYqyAXD0tyD7MrbcDTMVUL4D6V3O9kJa2CxpFLHUtljsyh604tYz4byuwunOlqXswIi8ORiop7tPu7FZNfCHgfDM=
X-Received: by 2002:aa7:828c:: with SMTP id s12mr272706pfm.94.1568652578437;
 Mon, 16 Sep 2019 09:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bd36db0592ab9652@google.com>
In-Reply-To: <000000000000bd36db0592ab9652@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Sep 2019 09:49:27 -0700
Message-ID: <CAM_iQpXdTNVywYm6+vmAKMsBRcC6ySOX9Rcg70xhgdjJgbDJkw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in rds_bind
To:     syzbot <syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com>
Cc:     Arvid Brodin <arvid.brodin@alten.se>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 6:29 AM syzbot
<syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f4b752a6 mlx4: fix spelling mistake "veify" -> "verify"
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16cbebe6600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
> dashboard link: https://syzkaller.appspot.com/bug?extid=fae39afd2101a17ec624
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10753bc1600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111dfc11600000
>
> The bug was bisected to:
>
> commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Jul 4 00:21:13 2019 +0000
>
>      hsr: implement dellink to clean up resources


The crash has nothing to do with this commit. It is probably caused
by the lack of ->laddr_check in rds_loop_transport.
