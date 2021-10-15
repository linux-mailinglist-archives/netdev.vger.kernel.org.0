Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08FE42E6DA
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhJOCxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhJOCxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:53:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4289FC061753
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:50:58 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gn3so689531pjb.0
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=buel8FT8odvpagvmPrwbM1NuTKwe5jQmfhwUUa1cid0=;
        b=oslE2W0ohtjDFpXAYPra2hMdbrbG6sIiHgPeLF2Q5qsXSEjDHAxlJXzuHuVD6qQyNS
         OVxYgd03wBTkusctiFfKT/2DsITZjakfNycL833nRd+Yisvk3o65fIG0dITn6a6khh+t
         p+t7Zr8dfHDNpIZ7R2t1LI/deT/caxuNU4mwq05Ar8aLC16aTlwxl9yBuxZKE9PUm5Z+
         TJ4TeTugDQ3BK5M6W76DB0xlw2pT55jlrlTuCHGG+flFGEC0YYr/pbBZ/wk2oMs++sUJ
         aJmaNSUSJOVpsWHqIV2peUEnC2IyKCkyFMxEQYXoNy/zG6dNdCsDjXqOdaJJFna4HF/9
         zJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=buel8FT8odvpagvmPrwbM1NuTKwe5jQmfhwUUa1cid0=;
        b=VG67uJfv/7qo+AmTwv/C14pyfsRanSj+mSakfX7Jk/hzPb2BO4v7/GFkBOT0Ry/X5Q
         jCyOab8sHvcZcSXM+a1z3btexqDFd1I+VqLx3miKTvGmkmOtJKxH05wpSv7MP08N/qpi
         McB0dq6bDp5vhjhk1wHzq1juqOsJvUirbb5Kg1+TjHsuzONABrIUZY4hsKoXbPYx/nBC
         1rYyhtCGwgCRsI9rqvG3WPo6vEtdlvCrsMnIIFfrJ8tgAYAvXdcyljsWusW2YpkFO18l
         x7FDmYmwmbMRKmxH/PJDIxRlM4wv/61HzSEtpgN2zzvAfxYdFI3k8EtvSLLhDpUU74oS
         WpcQ==
X-Gm-Message-State: AOAM5332slWg6IyPU01+wnySKtuAp0/Xr9tDs5E8bwPhDOJT6elmYsn/
        7ZLIVtT2PY0u1m6cTeomycU=
X-Google-Smtp-Source: ABdhPJz42TtQ0QzfgRxBL7BejzjZQrNGyb8TYikah6BbxPYHaVIIpKfSJpaJL7B4YV4ZmSPiTBRcIA==
X-Received: by 2002:a17:90a:ea94:: with SMTP id h20mr24901775pjz.58.1634266257694;
        Thu, 14 Oct 2021 19:50:57 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id 139sm3680798pfz.35.2021.10.14.19.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 19:50:56 -0700 (PDT)
Date:   Fri, 15 Oct 2021 11:50:52 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Anybody else getting unsubscribed from the list?
Message-ID: <YWjsjB8rewStIybP@d3>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
 <20211014144337.GB11651@ICIPI.localdomain>
 <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
 <20211014145940.GC11651@ICIPI.localdomain>
 <6263102e-ddf2-def1-2dae-d4f69dc04eca@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6263102e-ddf2-def1-2dae-d4f69dc04eca@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-14 11:17 -0400, Jamal Hadi Salim wrote:
> Ok, so common denominator seems to be google then...
> 
> Other than possibly an outage which would have affected
> a large chunk of the list using gmail cant quiet explain it.

Happened to me too in the same time frame, also on gmail.

I think the last message I received before the drop was
<487fa811-5afb-e25f-4292-0771c67cc462@omp.ru>

In my case I haven't been dropped from the list since 2010.
