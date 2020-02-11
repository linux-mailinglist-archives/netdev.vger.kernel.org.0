Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A94158A12
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 07:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgBKGuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 01:50:07 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38035 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgBKGuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 01:50:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id j17so823355pjz.3
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 22:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q8fCSPBuhiSnh/GVp05YA4eF2xiMUD8xMxXwsn6Wmew=;
        b=phdn8vmBoPDwXF8wyFJoNL72HIb9dMyV3Qm96BTY9IlYIQt8gNa4MNl/SaR/z/MTxy
         txFzakwbUWd/OMRX6XCCnQgtXj8sT7C9SFOrrFxjxK/q7OKJdqAKgEo0MSEmdQLvDXJl
         Drx8/1LiIo501w4UQC99mCf9bM/iOBQNBOdfFxFZ8u0f/BbRo87YfQtAp2twEee1j07C
         DVLQkyWg6Ap9Xq7bhlMDPL9+ykTSYIKM1xuv7UKUWxs72ASMQyh2WGdctDxodiRW4jYy
         CgrFvpjljAAu5uwuB4E3C7pZz6nYNKI3VdeIaDZjh7SFn1ZL0lWajBAMAPiKQCuGJd0l
         C75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q8fCSPBuhiSnh/GVp05YA4eF2xiMUD8xMxXwsn6Wmew=;
        b=QdUmnZe620uMFMo3vscI5J0C8p++yKO0pD+AW+e4uxk6RGjsg9cHNses/VgiyytF63
         Hd6WPSA+tiGcZL7mH9xKPbys/xcF10m1GP6turBnYuFxLaZV5Gj2eB6lFJ25c/yQ+01I
         WS8sIfgkN++NAaVQXIpKEZeQfcXvEbaHqnE2cFmRNpDYgwyoUSvHiPh2ylrwr6M7LHKg
         KD4P28VYt9oCqCiSRALnSqcHzouzRxQGDrUJBtOJHZdGz7ZeRKtOs3AkOj91G+Md78K8
         2YPwj5EdWAdSC5EgmsrRinnBYVpwisd8DXTXMXrA7D6MtefvnbeJ4j2L4IYNTR3tz0yg
         up8w==
X-Gm-Message-State: APjAAAUCgtoBsn7PzMCNl079yVDMbl9vFTyU5Trrl8zGog/KAJ4HMAZa
        GxLb9ppUanjhHG7UUASoKm55mIEw
X-Google-Smtp-Source: APXvYqwdFCbT+QSmIre83bT3KDquixwF88cjxQFnBs9wiC5w9BlxPlQsa1IrNrcGWp39cEZT8AovmQ==
X-Received: by 2002:a17:90a:7307:: with SMTP id m7mr1972471pjk.75.1581403806967;
        Mon, 10 Feb 2020 22:50:06 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id b6sm2741591pfg.17.2020.02.10.22.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 22:50:06 -0800 (PST)
Date:   Tue, 11 Feb 2020 15:50:01 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jarrett Knauer <jrtknauer@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fixed extra indentation in
 qlget_get_stats()
Message-ID: <20200211065001.GA5718@f3>
References: <20200209073621.30026-1-jrtknauer@gmail.com>
 <20200210043158.GA3258@f3>
 <45451eb8-e6a9-2e7a-e2fd-680b31e38717@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45451eb8-e6a9-2e7a-e2fd-680b31e38717@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/02/10 11:31 -0700, Jarrett Knauer wrote:
> On 2020-02-09 9:31 p.m., Benjamin Poirier wrote:
> > On 2020/02/09 00:36 -0700, Jarrett Knauer wrote:
> >> qlge TODO cited weird indentation all over qlge files, with
> >> qlget_get_stats() as an example. With this fix the TODO will need to be
> >> updated as well.
> >>
> >> This is also a re-submission, as I incorrectly sent my first patch
> >> directly to the maintainers instead of to the correct mailing list.
> >> Apologies.
> > If you really want to fix this, I would suggest to go over all of the
> > driver at once. Then you can remove the TODO entry.
> I can do this. Would it be best for me to re-submit this patch in a series of patches with each indentation fix that I go through + a cover letter for the series?

A quick run of `clang-format` shows:
5 files changed, 2305 insertions(+), 2407 deletions(-)
Many of those are unneeded but I guess it will still be a lot of changes.

There is not much benefit to splitting each small indentation fix into
separate patches: it doesn't help to understand the patch, it doesn't
help bisectability, it's debatable that they are logically distinct
changes.

If you want, you could split them into topics like "fix code formatting
in enum/struct definitions/function bodies/preprocessor directives/...
Then again, if the overall changes turn out not to be that large, a
single patch would be fine I think.

Please make sure to read Documentation/process/coding-style.rst; that
doesn't go into every small detail and some things are up to the
preference of whoever wrote the code. In case of doubt, I'd suggest to
look at other drivers in drivers/net/ethernet/ that are not too old:
ice, ionic, sfc, mlx5, ...
