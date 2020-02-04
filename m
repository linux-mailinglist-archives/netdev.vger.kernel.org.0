Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB8C1518B3
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgBDKUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:20:06 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:40861 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgBDKUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:20:06 -0500
Received: by mail-wm1-f43.google.com with SMTP id t14so2828441wmi.5
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 02:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bPhO2d0iXbx+A6V3G6DHvzOm2QGy1T4FQ7TgAJINkqI=;
        b=Xygmb677dZDiCu/xi1aNKdUz5iWBC47mFJHlNX4H9VVC1SX81EUSoB0y3YH4TVihZe
         740IGlwN698nKs2sqQD+CHnSuOrudiuGPf1IYCIMpyOzvunYHcqplJLPFvcEQRhSmeNm
         D2bu9u2MI4mizhlar4f05j8aEwiFLbFCTEk+j4p9gA7NdyA+yGl6CaKmcIaQeAxExbNu
         omIpKL88w7L+217zMRGxEEGmHI5vsPDlwXfiTwJQY2nawhol1PwAaJd9fH80ZOerW6fR
         cvcGfRmZWOHXWPegodCqHxtF3iNLVaUexuoX+F3p2WLevyHqoR7Pm0v5dD7dY09vUYVO
         0SMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPhO2d0iXbx+A6V3G6DHvzOm2QGy1T4FQ7TgAJINkqI=;
        b=hzTtxkBZUEkjI3yqCOzoriksetah7c49yPSqKYO1U3m0caSdM40I2SdR4TW9QSM/c1
         vHgBOExIrKYGKT/hqoDksrJnXdJHlfy/HCy+KvByb3kyw+zAVBhvet7Pl7xqFdCzLckF
         xO32vevcJIITX2vdH3OPdJgoztW2PbGK5RFdONE3Wtal3qQ3lP37/hnOdtzz5MzBEewo
         FJSygYwYCmaxE9zflRmASlXkfqGBKE3vI+O/GK+apUXSpZKBYP+PTsfkluIx3qPnTwz6
         LSqUFQvIfkfs/AxhTTVIOvRbbmgMF5GBN0fchGUp2Tbhfe3QrTSII26Un2DN1/rDjuvm
         o87w==
X-Gm-Message-State: APjAAAXA3APqEzFurPmVaTx654tDqbuq1rSluLQcMppz1YT1CufHjhLI
        Gjt64jpOpSpGaQL3fGPJW3DL+w==
X-Google-Smtp-Source: APXvYqyRMsSBHb2+PLzWcVL5MWpUBd8wanmaKtiMJAdwOxmXVSlL3i25H8SsB0WWG44nCUWwJjtJuw==
X-Received: by 2002:a1c:5445:: with SMTP id p5mr4946446wmi.75.1580811604420;
        Tue, 04 Feb 2020 02:20:04 -0800 (PST)
Received: from shemminger-XPS-13-9360 ([212.187.182.166])
        by smtp.gmail.com with ESMTPSA id h2sm30405119wrt.45.2020.02.04.02.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 02:20:04 -0800 (PST)
Date:   Tue, 4 Feb 2020 02:20:02 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH iproute2] tc: add support for FQ-PIE packet scheduler
Message-ID: <20200204022002.4463eec4@shemminger-XPS-13-9360>
In-Reply-To: <20200201065536.13825-1-gautamramk@gmail.com>
References: <20200201065536.13825-1-gautamramk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  1 Feb 2020 12:25:36 +0530
gautamramk@gmail.com wrote:

> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> 
> This patch adds support for the FQ-PIE packet Scheduler
> 
> Principles:
>   - Packets are classified on flows.
>   - This is a Stochastic model (as we use a hash, several flows might
>                                 be hashed to the same slot)
>   - Each flow has a PIE managed queue.
>   - Flows are linked onto two (Round Robin) lists,
>     so that new flows have priority on old ones.
>   - For a given flow, packets are not reordered.
>   - Drops during enqueue only.
>   - ECN capability is off by default.
>   - ECN threshold (if ECN is enabled) is at 10% by default.
>   - Uses timestamps to calculate queue delay by default.
> 
> Usage:
> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
>                     [ target TIME ] [ tupdate TIME ]
>                     [ alpha NUMBER ] [ beta NUMBER ]
>                     [ quantum BYTES ] [ memory_limit BYTES ]
>                     [ ecn_prob PERCENTAGE ] [ [no]ecn ]
>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
> 
> defaults:
>   limit: 10240 packets, flows: 1024
>   target: 15 ms, tupdate: 15 ms (in jiffies)
>   alpha: 1/8, beta : 5/4
>   quantum: device MTU, memory_limit: 32 Mb
>   ecnprob: 10%, ecn: off
>   bytemode: off, dq_rate_estimator: off
> 
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
> Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
> Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> ---
>  bash-completion/tc   |  12 +-
>  man/man8/tc-fq_pie.8 | 166 +++++++++++++++++++++
>  man/man8/tc.8        |   8 +
>  tc/Makefile          |   1 +
>  tc/q_fq_pie.c        | 341 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 526 insertions(+), 2 deletions(-)
>  create mode 100644 man/man8/tc-fq_pie.8
>  create mode 100644 tc/q_fq_pie.c
> 

Overall this looks great, thanks for doing the bash-completion as well.

The only issue is that iproute2 now uses SPDX for license information.
Therefore do not include the legal boilerplate and use SPDX for GPLv2 instead.

Checkpatch sort of identifies this.

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#378: FILE: tc/q_fq_pie.c:1:
+/*

WARNING: else is not generally useful after a break or return
#529: FILE: tc/q_fq_pie.c:152:
+			return -1;
+		} else {

total: 0 errors, 3 warnings, 558 lines checked



