Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DC73C3EBF
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 20:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhGKS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 14:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhGKS1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 14:27:52 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B8CC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:25:05 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y17so15710864pgf.12
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xoFzYg5h5QNv4Vsky+W5HTQZHAEgpoKAh+4KonLxFAU=;
        b=jdkJ7bcOvuMxNGZ7PGb8zEdqLuCQlKMbSo7RFaTlTR4CiNMBtPW5VBfqYUsrRshK7+
         ZVtgPuxR4idJZh9P3wahwqNLfMcD/WKQ9jw8yTfEDHHgr8KZEJk7rnQHds5He2mCsffh
         C65tRKM2sKN5mXxCMt5Db5Pi96qULTBVpoV3FqWXbhk+DxuAHYg+thdt1nwFZNLPAduQ
         UNkFetntFhKUssMIzVYPLGvMQ4/npYjRF8yxnTZhuivFM9JnkMKe4aMG+NQC4YYMdSBV
         G6rgntyu5u08QvhE9Ije06zUKW6Z74xo/2ID4/jY3nVEt4c+K1ULPzQLT0ph2yK4Xrs1
         PyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xoFzYg5h5QNv4Vsky+W5HTQZHAEgpoKAh+4KonLxFAU=;
        b=h4dUflIrMpYja9mqxSTRC0aQMHdLr5p1xMdSIEgHdE+DWL1lHHI+6Y4GS4vk5RDmRp
         3Gd3w9tger7JZ7iA5MFxqpqwAb3p0MpWAdK9Qh52lz+avQzeZyJtIAFUV63uygML9Zxz
         J6+u1ZYW34YuRrklJdpoes8ncO8lRH76QAJv5ZKp8UogkBcG3cXVdkwhJdMQpHCvVsHg
         Wf3fz7bYWYzKeW6hP2cPw547i/U5lK96RQufZjj1D4U6A0hoFMlPG5aLz36UjL78001Q
         64ajTRtgx7V9cLYRiFq/ZlTymZFbizINbYsaFTjepSR71VUCEtmVHnf9Ic52R93pHSsS
         rVxQ==
X-Gm-Message-State: AOAM532HAeQ6Tuu2EtZIBfNhHfZLMm5Aklnd0EI75L2TNaUy2HprXMTG
        LOPs6b4ebUvS5ypkRawd7uJ6/UxT/mi0DTgdXGM=
X-Google-Smtp-Source: ABdhPJyJEYL8dleFCH3CUNh9idB9bFZrTjg3NjoVzbupJL9xgkEZJHToP9j/onQqcVnFQfouBUfNZaZpO5pPHxtbfAg=
X-Received: by 2002:a63:4302:: with SMTP id q2mr49178855pga.428.1626027904965;
 Sun, 11 Jul 2021 11:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 11:24:54 -0700
Message-ID: <CAM_iQpVewx4pDv7BHX0Tf_8px11R31H4jKpLQ+APT3YYcEr=YA@mail.gmail.com>
Subject: Re: [net-next 1/2] qdisc: add tracepoint qdisc:qdisc_enqueue for
 enqueued SKBs
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:00 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This tracepoint can work with qdisc:qdisc_dequeue to measure
> packets latency in qdisc queue. In some case, for example,
> if TX queues are stopped or frozen, sch_direct_xmit will invoke
> the dev_requeue_skb to requeue SKBs to qdisc->gso_skb, that may
> delay the SKBs in qdisc queue.
>
> With this patch, we can measure packets latency.

Coincidentally, we have a nearly same patch:
https://marc.info/?l=linux-netdev&m=162580785123913&w=2

Also, '%p' certainly does not work, it produces same address for
different packets. This is why we changed it to '%px', see:
https://marc.info/?l=linux-netdev&m=162580784823909&w=2

Thanks.
