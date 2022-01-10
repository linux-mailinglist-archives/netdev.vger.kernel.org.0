Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638B1489E37
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbiAJRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiAJRVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:21:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0BC06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 09:21:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso807633pjg.4
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 09:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GhwOf0YXkDcJbqf4xvCv/gKefslIywgQOKdpbeZMR54=;
        b=XHA8jvmXjCu258OTcvoUGy15D+l8CcO2oIKLbA5wGWBNOZ9ejmBjvEAm9zZJVMHUJk
         8Ojm0U3eA5cdcebVwBxSr+6mYO9UXhYZNsbU3B4mMdVHqvIQ/htsjiWbBUdqc+6noMRE
         EkxeyDcDzzOO/bBHraq63jUhhRhcMpBb5WQRd9O0D0dgqLUHKDh38lFvxlLHxDceKSe8
         H0vH3gEe1pnFj391U00upjXNLyxChH0x0hkGt+oeJKcif8jU7c/5RfMrArVaqcT0cqcW
         PSQfKD+KmL2HalHMx5xWFf6fqfYaPgIDDtq0osu3uLYw9MnRKOlWD0isOOi89MTqBpch
         TbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GhwOf0YXkDcJbqf4xvCv/gKefslIywgQOKdpbeZMR54=;
        b=2byaVfL6mFVAM2eW5Fu53JiEBoU9p6+ZkydJCwqM/riHOfqQamFqyLOQMid2n5/pNG
         Rrpze9wSM2s4SvZ+ydlSXgZx+rJ2AjDRftJzr5E+F24DfbCCgWCJeAIyZu2/jrGZT8DE
         1vUN0nRRpfdma5hMOXilxTCMimEOhWBxx9o/4giEl0HKp90GxnMeM6v5nhBI1PDAYgfr
         n76b/apKOo/0krX0BbRRX8qPPARhLNiq5f2Nory5aVKsEXtSHdHsNNDzwgbrYPneIcr0
         E9zKRrNuW1tKPwRp4HPWRWIC94fWizFaOKYGkcvUvZxoP2/xK+RogiIAzNvPRUfT9kiu
         RaFg==
X-Gm-Message-State: AOAM531H1Ytv81Pd+kusyfqL533c0ifx+rICKeoIc6Yngzpj5x0LbPoF
        bHUgmgTrhkI1GOENhXPkZ0o5pvr7PKgWpg==
X-Google-Smtp-Source: ABdhPJyJQIPEq9asDUUbMMhiMy4kjikZeyBfPMruib/h2UI0sClBUiJRK/gbvT9ojyN7nN8iSIjeSQ==
X-Received: by 2002:a62:180d:0:b0:4bb:dafb:ff50 with SMTP id 13-20020a62180d000000b004bbdafbff50mr530396pfy.45.1641835261140;
        Mon, 10 Jan 2022 09:21:01 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id h5sm9252519pjc.27.2022.01.10.09.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 09:21:00 -0800 (PST)
Date:   Mon, 10 Jan 2022 09:20:58 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH iproute2-next 00/11] Clang warning fixes
Message-ID: <20220110092058.369bbff5@hermes.local>
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 12:46:39 -0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

> Building iproute2-next generates a lot of warnings and
> finds a few bugs.  This patchset resolves many of these
> warnings but some areas (BPF, RDMA, DCB) need more work.
> 
> Stephen Hemminger (11):
>   tc: add format attribute to tc_print_rate
>   utils: add format attribute
>   netem: fix clang warnings
>   m_vlan: fix formatting of push ethernet src mac
>   flower: fix clang warnings
>   nexthop: fix clang warning about timer check
>   tc_util: fix clang warning in print_masked_type
>   ipl2tp: fix clang warning
>   can: fix clang warning
>   tipc: fix clang warning about empty format string
>   tunnel: fix clang warning
> 
>  include/utils.h |  4 +++-
>  ip/ipl2tp.c     |  5 ++--
>  ip/iplink_can.c |  5 ++--
>  ip/ipnexthop.c  | 10 ++++----
>  ip/tunnel.c     |  6 ++---
>  tc/f_flower.c   | 62 +++++++++++++++++++++++--------------------------
>  tc/m_vlan.c     |  4 ++--
>  tc/q_netem.c    | 33 +++++++++++++++-----------
>  tc/tc_util.c    | 21 +++++++----------
>  tipc/link.c     |  2 +-
>  10 files changed, 77 insertions(+), 75 deletions(-)
> 

Will resend this after 5.16 merge. Some of these are already fixed
