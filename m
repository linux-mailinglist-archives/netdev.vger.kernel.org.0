Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FECC438C9B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 01:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhJXXrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 19:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhJXXrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 19:47:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C3CC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:45:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so7032292pjb.3
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZR2Hyrml6H0773jTh+6sC2KJ2Sr2eOvYaYV1TYp/dN0=;
        b=dus9V/SfCQ98obSvBlCnAkzYA2QTo6+oF3vXkBJdWap9znM7UQJQ8qFMxcnrijOlVe
         tIk0VyUExkjrkPATK+LW4FPz+E5XutFuE6q/2NAXMhevY2XBfNtc6qvVBmjcZeRh2AnK
         238Xn0PsahoeUGbG6sNZGs3oAC08eKrgsBMxUs5HT9niEpXA62TZCcDgCVz6fDWNYFhj
         dryZuRRSb+fsKLsUTrrk5g1HyexW21SAL4BY9MAh7MuJDwBbIsBz1qNY/zytwiGnbEo4
         k11snUwcu6GBHrcbtb9JAE/NVISWelok62xEpKdAnjt5gWeJY1YwiCsS24LUTlHL37hP
         2Hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZR2Hyrml6H0773jTh+6sC2KJ2Sr2eOvYaYV1TYp/dN0=;
        b=WkSS57ZdOQLCzRMyGK7EjF6oeKRfnYImuwcXp2d7lM4xB3wRJxYdIFgsi9/LpE6GrT
         1saWntwg/er7kpu9JjgV0xk4Lyteh225R7LY3lBShopVsWNDS2bpsCepKDYUjxwMZbVz
         bCLi4bE0BEv88k/NlpyNslHZVZ+ARnFsjdp9BP9mjU1f0SqwgPgXJMN/NX96iA9jQhq1
         C9rY1vDpNi5cFJq4OzQR3hShYxJJTLDSeFbc1SU5bhoO/8XsglqnvaJJas0O2tSTkrgQ
         x5vOZMmBF+kzPBza0QKOzmFkDS2N9k/nFy4wNh2gYDJl+LHrX0b4JaWMzvZD/4Tnm9ym
         nnug==
X-Gm-Message-State: AOAM530G3G6ZGbb8UTGzZqJ540DvINwfxW5qezZXV+QeoTFlKfF8cYKV
        c0S2Dr/OvdBHb/ck9XQgBfU663bL+GPXpg==
X-Google-Smtp-Source: ABdhPJzoUIwh1+8XMRyEwYc/nfHVak9KTh8FTZv5pF2xpG+vRQ2OeSgFV925Xa9wZiH5nVji8OfTZQ==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr30682243pjs.159.1635119129597;
        Sun, 24 Oct 2021 16:45:29 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id z10sm3573105pfh.106.2021.10.24.16.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 16:45:29 -0700 (PDT)
Date:   Sun, 24 Oct 2021 16:45:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: add AMT support
Message-ID: <20211024164526.2e1e9204@hermes.local>
In-Reply-To: <20211023193611.11540-1-ap420073@gmail.com>
References: <20211023193611.11540-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Oct 2021 19:36:11 +0000
Taehee Yoo <ap420073@gmail.com> wrote:

> +	while (argc > 0) {
> +		if (matches(*argv, "mode") == 0) {

Try and reduce/eliminate use of matches() since it creates
lots of problems when arguments collides.  For example "m" matches
mode only because it is compared first (vs "max_tunnels").
