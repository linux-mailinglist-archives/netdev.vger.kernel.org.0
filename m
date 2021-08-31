Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65313FCD45
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 21:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhHaS5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhHaS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 14:57:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B628DC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:56:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q3so12950plx.4
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=neBaH7/0larvqiBeio9tFuFjX9Lg73dBxL1DNUSIdj0=;
        b=LKSJOC7/q1kMFKZTO5QUL69mnMZHSsOg1eBbilmDesXXfiIyyHrzyaYOKzng0xZOEk
         TUiVavtxq13WQgbwZDrhvRU/qeZeVWexpiRlDiYw7D++cVviE0vaRSFNkqIIHrEEDhMi
         nHaP6tfBEQQaVcCfwkLgc2aY6qk4rEyUK5ciyttLGo/N3npNMplW+7wA2kEdM3asNmro
         8fDDlNIpBNnPdUMqQuniIuNDYN6Rt6696P0emQx6qCn84XGdKstRa8QMvMiOfpq9z0x0
         MPh0in7QX9wq3gCa289F6h1vLuvu3mCDCQqmLaUqTjckfdAjbo1o7Echjai6fcMsqYhf
         tZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=neBaH7/0larvqiBeio9tFuFjX9Lg73dBxL1DNUSIdj0=;
        b=GQiNMgnbXfePIeC9hT236Ixs+TmaD+7xNL59x7bnfOTwAjjZguYmfVSTrRWcKbAvdx
         z2g9IJy6TsbV4wKcnuD/PoDRYrVCwVHCybriw0L1R3upioY68bCuwxtCILiyTq+OAIZ9
         81MmC+Ati1gsmKOIzsIaTPa6VDpDk+zGm8oKusScAThdHWcPfWdLuwXmJlDnwF20UYP7
         bI0Cu3OTuAcicIz7I74xrNeLA4k5zkWTZi6mqg6vYVRQF32bHOr0jry5j1Y5U1O6r1Ms
         PGWir4BVGCq7TYJFvI3zI72NFNq/6u9zOVhN0Ce6STh5Xaqk4JyUwXKaCalgZyCmYugW
         9yLg==
X-Gm-Message-State: AOAM532kuBfn8EjYvhzdXLenTQAmQUyuNR0jXKPcShsBScW6hFziws47
        tM4zNAk3utjIsVHOieWF0CWI6C2GfVSviQ==
X-Google-Smtp-Source: ABdhPJwj9CpHkj7646R0/9egBD6s9iRuc1aNVyavaYlhUwWb9IMjXZCrQyXb4cwMYGQQd5rFXDt8jw==
X-Received: by 2002:a17:90b:390d:: with SMTP id ob13mr7118401pjb.129.1630436183172;
        Tue, 31 Aug 2021 11:56:23 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id q7sm3564320pja.11.2021.08.31.11.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 11:56:22 -0700 (PDT)
Date:   Tue, 31 Aug 2021 11:56:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [iproute2] Time to retire ifcfg script?
Message-ID: <20210831115619.294cf192@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifcfg script in iproute2 is quite limited (no IPv6) and
doesn't really fit into any of the management frameworks.

At this point, it looks like a dusty old script that needs
to be retired.
