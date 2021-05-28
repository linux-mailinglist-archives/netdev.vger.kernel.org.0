Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE13946BE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhE1SDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 14:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhE1SDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 14:03:40 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41062C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 11:02:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q25so3842046pfn.1
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 11:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=svSAtfKQJJoe1CrFljBn7KUaJrhGIh3gV/ealjtaSyM=;
        b=R8BelaB5KuHd9DFPIwpzITIJxXWkpq90VsoyfapO/ys3MTaTykOtK+eswKB9id039g
         bp50Fs5RE/TqZH8N8TdITfSl8yxy5PqOwj+KaoPkjB4ZTphLcn+dhTLfydxvdrNYnOB+
         GSl+XpdejOKjzXhkBEAJPkJbN5bHb8T4POixMcZ5jhnPrroReZ8MR/r7ctgN7HYoeYmL
         zVjpbHVbW4fmwwyw5vGw453uAcyyHZHgFfM/9KjWoJgFk4+QWqKEJ8MgZ50FkI7lYjBC
         g656bpbe2g83uHBVax/qcOdtaLn+IFnCzrs31YwnI8sEEguKSv8gF/Q6epj4vOWPi1tJ
         D6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=svSAtfKQJJoe1CrFljBn7KUaJrhGIh3gV/ealjtaSyM=;
        b=p/x3EUi6bWUz+9goyp6W02LBT/zz2uBVcARZ0ZaAmcGios78siAqqaTxT+dMOA7oz/
         dEsJpPKzsjI6wWhf+Vb7RdyDmB8ex31hrdXAqX278O5OwUJBvY1gFvFr3BuTCKVo/Nse
         qplUEisHchhAW1MjYofpuZco3qMg/c1UVncRJ96yMQzdql2KfIZWH0sh/0UzsONCuf/S
         kpPtlKK4HNwsKZ6hOZadoaLg0e1KVzn2dxm8ntg0DTr48untBMavmRhMVAtC1AX3uVmU
         u61uU0ZTs2nn8U6YP6bk5RofB64/LhMOQKJ5E6gOnaxAOfiPv4FgLMetpfjh/rlHP7wX
         WNSQ==
X-Gm-Message-State: AOAM531nWC5zeeuSrdUrVK8DxiG1SMUpb+A8+jGMd3HUTAz/V22nYsvV
        vBqu+Plreqw/nr1FG+IXJWLwBA==
X-Google-Smtp-Source: ABdhPJz0iz7CJnQwxyiYhchdNBClbwDroQtwrHAx8VCkQ3U10fAbvHOT1XvfaOERjha7vB1NU9pVAQ==
X-Received: by 2002:a63:4c41:: with SMTP id m1mr10055741pgl.394.1622224924536;
        Fri, 28 May 2021 11:02:04 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id z2sm4752231pgz.64.2021.05.28.11.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 11:02:04 -0700 (PDT)
Date:   Fri, 28 May 2021 11:02:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Norman Rasmussen <norman@rasmussen.co.za>, netdev@vger.kernel.org
Subject: Re: iproute2: ip address add prefer keyword confusion
Message-ID: <20210528110201.4e6a17b7@hermes.local>
In-Reply-To: <cee42fde-e171-6484-3091-fba1e65271df@gmail.com>
References: <CAGF1phaw5pe5y2acaoT2FqtMbZ0KXbzkg9ANAJoH=PVG=zJc7A@mail.gmail.com>
        <cee42fde-e171-6484-3091-fba1e65271df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 22:31:24 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/27/21 2:58 PM, Norman Rasmussen wrote:
> > commit 78d04c7b27cf ("ipaddress: Add support for address metric")
> > added "priority" and "preference" as aliases for the "metric" keyword,
> > but they are entirely undocumented.
> > 
> > I only noticed because I was adding addresses with a preferred
> > lifetime, but I was using "pref" as the keyword. The metric code was
> > added _above_ the lifetime code, so after the change "pref" matches
> > "preference", instead of "preferred_lft".
> > 
> > Is there an existing way to deal with conflicts between keyword
> > prefixes? Should "prefer" (or shorter) fail with a clear error
> > instead? Should the metric code have been added below the lifetime
> > code? Should it be moved or is it too late?
> >   
> 
> It is in general a known problem with iproute2's use of "matches" to
> allow shorthand commands.
> 
> The change where "pref" goes to metric vs "preferred_lft" was
> unintentional. At this point (3 years after the commit) it would be hard
> to revert the change.

Agreed, matches() is a real bug trap.
