Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5ED3F0E5F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhHRWvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhHRWvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 18:51:04 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D664C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 15:50:29 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso6131834ott.13
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M34JhqnwK58bm7f3IeobKlDCFS9qF2TW3zpJ2uSHAXk=;
        b=iy6Zc4k6aTOTxZIHBZLz0xEHh17DXDQlHdmCmYAyHwaD+CldUswEuGs9PRigFVa1Jk
         rIk2sZSfLfFoe4oOsRMvCC7IUN1Xn7nzqegY0yV9ezgva6cQ7ZsHfzCxoYLnf4uofA1G
         du3iIcIBblnq8rvIJ3XG0/b0++hknNE4XVwI5dRsnShmV46BTXE8a7trp6ZOhX+STz+F
         hqGmz9l1lE6J73baOg9HUndqx6HPDFvQXlzVmjkAkjEuHb7AX++sjINBN25H41MeamgV
         V/eb9tSUPfAfgjAnFAj0hu26nmBAqnYq7xbXip/m1+f+IM1tOEONuIiXz4tKxpv5VJ8I
         rwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M34JhqnwK58bm7f3IeobKlDCFS9qF2TW3zpJ2uSHAXk=;
        b=mT3JYM5iHu6sT2E0QA2iL+3o6u22xJknWtsPdMmFbjrrtmDGgzd5/8cjKJvMWEGQS2
         P1JM+S/Crsz7QEn0f4uKcapVqNLs542kGOM/TDBRbO7tjYt1Lc3ZJJlNl98us53Et7at
         X7xJ7iX9piE7e/JcTIQ0jlXAXbC33ULcu/wd21+0EqR7NDYrTaBk7idwBlL9h4R0DOiv
         NH7IshAtYRC/wyowJPe8WmXuD7ETwM3BHOb+ryOSD8rhz7T0/9ZZ8sjCx8eJ46DEE1WP
         Fz8FO6P1wRG+f9jphg5abgDFHRj6RQcMn+uxSjqYB8O/BQHFY37dEH3NSq3GUsM8z8I5
         cKZA==
X-Gm-Message-State: AOAM5317YUwj2ULcA2pqdIPcnYy+QTRMQnHrS4U3wATo4W3zjQQec0Sk
        8aqSCcZbWWufGp7KAJEDGg==
X-Google-Smtp-Source: ABdhPJyqutzQ1E5PADK4xHMU1gYV5wBaj5uFLzTgH6zQXxinHt97qewpq2NJyvxUtWk/iOvS0ZKc/g==
X-Received: by 2002:a9d:7299:: with SMTP id t25mr9207380otj.272.1629327028506;
        Wed, 18 Aug 2021 15:50:28 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id 14sm335428otl.78.2021.08.18.15.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 15:50:28 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:50:22 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
Message-ID: <20210818225022.GA31396@ICIPI.localdomain>
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 01:37:21AM +0300, Nikolay Aleksandrov wrote:
> 
> Sorry, but I don't see any point to this. We don't have it for any of the other
> non-default cases, and I don't see a point of having it for ipmr either.
> If you'd like to display the non-default tables then you query for them, you
> don't change a sysctl to see them in /proc.
> It sounds like a workaround for an issue that is not solved properly, and
> generally it shouldn't be using /proc. If netlink interfaces are not sufficient
> please improve them.

We found that the ability to dump the tables from kernel point of view
is valuable for debugging the applications. Sometimes during the
development, bugs in the use of the netlink interfaces can be solved
quickly if the tables in the kernel can be viewed easily.
> 
> Why do we need a whole new sysctl or net proc entries ?

If you agree on the reasoning above, what do you recommend then? Again,
this is to easily view what's in the kernel.

Thanks,
Stephen.
