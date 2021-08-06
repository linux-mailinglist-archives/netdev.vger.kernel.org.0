Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44653E2171
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 04:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhHFCWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 22:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhHFCWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 22:22:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D29C061798
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 19:22:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b1-20020a17090a8001b029017700de3903so10874754pjn.1
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 19:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mCGhRSDapQWYwIEN3apPsQBvC1fXSmmWJg6qlH68EK8=;
        b=jWIXYlxWGRyAP0bIr+Tenckndk6A9FN8kgAFHbV6BRoojgsLUs7coZGqxvvepaQKRB
         HarH2ipLz7xCTMRkCSlD9ki2N9y0Vqvmrclaf4Czsbd7z4gYyxwrQXMqwdYQTEnLVOW5
         a0vlXm6PVxN9O79lOtaHHmmALYYnClozaBIiNzsvgN0oYDwJarYVOkrRdN9U6d5RmQRD
         1rklZHMzlW2qxkNIzJiXVB8WY4a2hQoQuhyik4zZggAKnuvuKg4nqWTGYTq+P7Mqgr+Q
         ihsze8ylGvtdFzsFvzjn/Nfzd9gdTWeFhPHGARnoW997OlRVr7ZM8fzsYkosoXuSXt7P
         q5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mCGhRSDapQWYwIEN3apPsQBvC1fXSmmWJg6qlH68EK8=;
        b=iyziqKHzIQ7WCBjsknWQuusao4CMLRfk0dsGkA1lZMqxV/bja1nD1PHrrpMJYk1R40
         vEsKFEo9liht5+W1zfqU8O4cpC5the0cRNhdqpDgCZ5mulrjgS7PkLOSugSMqwlhd/pe
         9aJ5H2Re0+Bf8Lol7Ho3aTZs9wxsRXC3+asDyF4hPjJ+5hM6pX6rhlF4zoSSAmA1C6jH
         GMoxoNEJNZSj+aTmIQJY5Q8+G7sJnrR71pkvcIA/6LxxiXuhuVhnSdUwCZsSTkj8tYBf
         z5el9NqpXm3SWdEZhHEvRexZALFbiCmtp4QfYF1vTJkfNaRBuKJc4bEovklhsisdcpBl
         OGIQ==
X-Gm-Message-State: AOAM53265a4FGghN/ZKYPn1r6Cbl8FDWVh+mUUKgKFZhzieg4vK4GNri
        IazsjB4G1oHGPbDo2fXHocZnoKzX5CiOuvukD1jMuF3d
X-Google-Smtp-Source: ABdhPJwegkUKCCXFJ83njqoJGSKgFjUPyp/iQm4ur0hbKb9GhvP/fYq5MK+Wttxh79g5lzWtM+AWr3xL+ny24k5vNeA=
X-Received: by 2002:a63:154a:: with SMTP id 10mr2855827pgv.428.1628216553957;
 Thu, 05 Aug 2021 19:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 5 Aug 2021 19:22:22 -0700
Message-ID: <CAM_iQpWJ8+U7ExYC0mq_GWmsFw-2EYJEo6wnfZW_pVALa5KE6g@mail.gmail.com>
Subject: Re: [Patch net-next 00/13] net: add more tracepoints to TCP/IP stack
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 11:57 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset adds 12 more tracepoints to TCP/IP stack, both
> IPv4 and IPv6. The goal is to trace skb in different layers
> and to measure the latency of each layer.

It looks like we should not trace them at the end of each target function,
instead we have to trace them in the beginning, otherwise the ordering
is reversed in the output.

I will send V2 tomorrow.

Thanks.
