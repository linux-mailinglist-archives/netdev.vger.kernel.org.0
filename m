Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A634A2FF8
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbiA2OHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 09:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiA2OHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 09:07:17 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B67C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 06:07:16 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ah7so26262722ejc.4
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 06:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0x3hajvhMdYrsBq4N/8zaKp4Mut67KNOt5i422OuXTU=;
        b=rVg29X4p8dFhNEXgXWHVjnRl2MU4o7MwxT3nnCmpyjRYN9cmZv23WA6oAvy2mvop/b
         TC1II/jqZknact3y1RF734JfAhRCL+G0jNlZXAHaDqC1SCi3j8HrKVuqIQlD6a2eiASF
         IeM5AxYfPRd0iOC42ueQ+PWe6QVrcrtphdwgEAZ9hLftiT/53YyMlfcbA5I8VVdGUBmt
         FGgjnVOtXmNxUx47BBFa4OBx1eJ4BfUkVaAejfzh3fUD76/PtJGhG1BNswmJPIbhjOY8
         Ee/pTauCV662v8249DszLengRtyQGZLr5TG9JPEnCO76s6cHs1yHW2xrs6B+7oqpGbWW
         RzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0x3hajvhMdYrsBq4N/8zaKp4Mut67KNOt5i422OuXTU=;
        b=Acwao/CM442O++iLoVzUHoMFnYrktbYUcQ6tS1AHw9RZDKoycLTlV99lHLwqgA5kbL
         1L490sMaPQai+6PXAqh0zpmmkHQrJ/HKeFH/ydHe1JHQF/JTKHiACal+zmDdmwKErwNR
         leyFiu8dR6e3kaqk0jW8IrFDN4FMIW4hLesW7BWMg58D1CHEByw3fZuoimuBlWx9FO9J
         Z3HpT7wi6u0BUPtBM/Kv1+5i16TcXvPnT4QbTbdDzL6ZE0PxrtILdyj4lL95lu50yiZm
         wAbPr3b28bkn4iqeCpzGxuIozPQFBLpkIqsLaY1S7GMYpx1i0Y9UjxnhRn9CuNThJyXq
         Iemg==
X-Gm-Message-State: AOAM5328CRPvVs40IRlaIcVIInZWBMo5oLS+DLQj13+41MQ1jgidfVBy
        a4ILXqjH+6R1p8EOgsNCjuRK2mBAs/bcTyBe
X-Google-Smtp-Source: ABdhPJwe/BavqVNs9S9EPzRz9Ipu9dbqKmB+l9ZoDHNXQyrDstoIUf/p4RrqC6w3CsZKz2Sjmc95og==
X-Received: by 2002:a17:907:9688:: with SMTP id hd8mr10757732ejc.80.1643465234084;
        Sat, 29 Jan 2022 06:07:14 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id s20sm2620650edq.55.2022.01.29.06.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 06:07:13 -0800 (PST)
Date:   Sat, 29 Jan 2022 16:07:11 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
Message-ID: <YfVKDxenS5IWxCLX@hades>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
 <YfJhIpBGW6suBwkY@hades>
 <CALALjgyosP7GeMZgiQ3c=TXP=wBJeOC4GYV3PtKY544JbQ72Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALALjgyosP7GeMZgiQ3c=TXP=wBJeOC4GYV3PtKY544JbQ72Hg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe!

On Thu, Jan 27, 2022 at 03:55:03PM -0800, Joe Damato wrote:
> On Thu, Jan 27, 2022 at 1:08 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > Hi Joe,
> >
> > On Wed, Jan 26, 2022 at 02:48:14PM -0800, Joe Damato wrote:
> > > Greetings:
> > >
> > > This series adds some stat counters for the page_pool allocation path which
> > > help to track:
> > >
> > >       - fast path allocations
> > >       - slow path order-0 allocations
> > >       - slow path high order allocations
> > >       - refills which failed due to an empty ptr ring, forcing a slow
> > >         path allocation
> > >       - allocations fulfilled via successful refill
> > >       - pages which cannot be added to the cache because of numa mismatch
> > >         (i.e. waived)
> > >
> >
> > Thanks for the patch.  Stats are something that's indeed missing from the
> > API.  The patch  should work for Rx based allocations (which is what you
> > currently cover),  since the RX side is usually protected by NAPI.  However
> > we've added a few features recently,  which we would like to have stats on.
> 
> Thanks for taking a look at the patch.
> 

yw

> > commit 6a5bcd84e886("page_pool: Allow drivers to hint on SKB recycling"),
> > introduces recycling capabilities on the API.  I think it would be far more
> > interesting to be able to extend the statistics to recycled/non-recycled
> > packets as well in the future.
> 
> I agree. Tracking recycling events would be both helpful and
> interesting, indeed.
> 
> > But the recycling is asynchronous and we
> > can't add locks just for the sake of accurate statistics.
> 
> Agreed.
> 
> > Can we instead
> > convert that to a per-cpu structure for producers?
> 
> If my understanding of your proposal is accurate, moving the stats
> structure to a per-cpu structure (instead of per-pool) would add
> ambiguity as to the performance of a specific driver's page pool. In
> exchange for the ambiguity, though, we'd get stats for additional
> events, which could be interesting.

I was mostly thinking per pool using with 'struct percpu_counter' or 
allocate __percpu variables,  but I haven't really checked if that's doable or 
which of those is better suited for our case.

> 
> It seems like under load it might be very useful to know that a
> particular driver's page pool is adding pressure to the buddy
> allocator in the slow path. I suppose that a user could move softirqs
> around on their system to alleviate some of the ambiguity and perhaps
> that is good enough.
> 

[...]

Cheers
/Ilias
