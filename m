Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0A41A608
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbhI1DYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238805AbhI1DYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 23:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C61661262
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 03:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JaFPVDVr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1632799376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YVbfOvJhR4HG3DcTmqvSfZylxTE3BT4gD25v4VMI6gU=;
        b=JaFPVDVrCJZtLcU0MN0vonqGPOAn7GlH+VMirMiFueGCMzWEjhWdoxnO0e1nquEzbrcBrQ
        Kp4+5R7kdE12SY7Vpsd6buUB+gbXZgPF0kSnMCvAaYuz38uFVvtXckbPVjcahIWM8KC/7S
        vfS61Es2wJP3mmmy0fSxnNUAPTK9dyw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 876f9a74 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 28 Sep 2021 03:22:56 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id r1so28614704ybo.10
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 20:22:56 -0700 (PDT)
X-Gm-Message-State: AOAM530C0dHr+AJY4lCPAZwExlVO4uOWngfx1bHxE+gRHfJ1zVoof5a+
        MlfGd97Qqv4imWyEcOIMQ0llFhnPwPuD/yVPBm0=
X-Google-Smtp-Source: ABdhPJyODnGkFeqSnOf0IQfNi3jsSOjxlakHamUf0qcVjkoEiC5YnQLgmhj0r2UrXj1xM7Onqi7vzvWoN4YhnOBx79A=
X-Received: by 2002:a25:664c:: with SMTP id z12mr4018256ybm.62.1632799375200;
 Mon, 27 Sep 2021 20:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210928031938.17902-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210928031938.17902-1-xiyou.wangcong@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Sep 2021 21:22:44 -0600
X-Gmail-Original-Message-ID: <CAHmME9rbfBHUnoifdQV6pOp8MHwowEp7ooOhV-JSJmanRzksLA@mail.gmail.com>
Message-ID: <CAHmME9rbfBHUnoifdQV6pOp8MHwowEp7ooOhV-JSJmanRzksLA@mail.gmail.com>
Subject: Re: [Patch net] wireguard: preserve skb->mark on ingress side
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

I'm not so sure this makes sense, as the inner packet is in fact
totally different. If you want to distinguish the ingress interface,
can't you just use `iptables -i wg0` or `ip rule add ... iif wg0`?

Jason
