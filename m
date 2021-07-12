Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490743C615A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhGLRFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbhGLRFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:05:35 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BFCC0613DD;
        Mon, 12 Jul 2021 10:02:47 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e13so20317742ilc.1;
        Mon, 12 Jul 2021 10:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=irpRnrsbtCZ01nJfbjB7c7/Wua+y1vAzJ01ZP5BX9aY=;
        b=UgfNk6iLdzSd3jH55URZflkUxRwg0muGNRIXToGflqVEJBQ+BL9fRqqnVeTaTkPWef
         dvMRAVnQ2siGKluJH2cSGVgVqz4qc5IHrBw6mrj9emYddrZP2amLfGKvakJKnjJeHPx2
         3xzT4JWbcCcD2/Y8Q9espFMNSvBdpfTz9a83TBHkCeTo+cfyJOkMFcBe4FhKu4MFp7pE
         HxKVnkxhBmaAPJXcGXCwyxu34NystssCKr5KLItvHq77prFbhHxx2WMkDki2COdYkV0u
         daFvm3AWOYIzn3O1BYlrjXB1oSlQNXDnv32lPQHo2CuAAgoO/fO3hXahnj/4vApWeLTE
         W7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=irpRnrsbtCZ01nJfbjB7c7/Wua+y1vAzJ01ZP5BX9aY=;
        b=rSCkkbR5dVjPP13Pxm0ErmsMj4zlhxl8si8eV/GOfUQGu9sNP0nNHfQSiUiz1HpTjM
         5240Iwt91LRXhgQzTQnJTIgwn/sBZ0f0fMTRjlR8KUUcPlTpkeqOGysS03AYH2PSbpDN
         D2tUN44CAS3I3Pa4pgWovVPge2CJ4IwG02QmwtDCCJNawjO2Xr780MOCxMv+2gBdER1b
         a5X9HDYhUQEjWsyvPEiO7f951QbOQ9ccg0jdDQN1cuXNq4eqMHnzhjmH/EytbNfbVYIv
         Ndm+aulDUF92W81nLjePs6m8AKgzk3oggBh8f33513r63trtbTCZGZ2bEhpdNw5Rpnt9
         DH4Q==
X-Gm-Message-State: AOAM533GZMruOKE0if/5nrIxdjzU3LnlgvWzpOK4dYysalOKeccZyP4J
        b+hlLE+Oe1YEAALV/Ud4miU=
X-Google-Smtp-Source: ABdhPJwR6AV1tJGjvQz6ErALMlqBPkpebabhPS8lsOGMuFUlDv/wDd3P4P2nB30vGz2QbJCYusXI5A==
X-Received: by 2002:a05:6e02:52:: with SMTP id i18mr38672914ilr.108.1626109366510;
        Mon, 12 Jul 2021 10:02:46 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n5sm8802564ilo.78.2021.07.12.10.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:02:45 -0700 (PDT)
Date:   Mon, 12 Jul 2021 10:02:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Message-ID: <60ec75af43d1d_29dcc2085f@john-XPS-13-9370.notmuch>
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
Subject: RE: [PATCH bpf-next v5 00/11] sockmap: add sockmap support for unix
 datagram socket
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This is the last patchset of the original large patchset. In the
> previous patchset, a new BPF sockmap program BPF_SK_SKB_VERDICT
> was introduced and UDP began to support it too. In this patchset,
> we add BPF_SK_SKB_VERDICT support to Unix datagram socket, so that
> we can finally splice Unix datagram socket and UDP socket. Please
> check each patch description for more details.
> 
> To see the big picture, the previous patchsets are available here:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4
> 
> and this patchset is available here:
> https://github.com/congwang/linux/tree/sockmap3

LGTM Thanks. One nit around kfree of packets but its not specific
to this series and I have a proposed fix coming shortly so no
reason to hold this up.

Acked-by: John Fastabend <john.fastabend@gmail.com>
