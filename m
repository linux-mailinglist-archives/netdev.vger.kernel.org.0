Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EF2ED4C1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhAGQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:50:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727413AbhAGQu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610038141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NEWzDghVmoiWFPFqZnl2qZ7dTRKfMUgExc8FdbxchX0=;
        b=aqT/bi2kSPu/BjSFIIyRNww19W3hhVNvv4V+kLZxYnI5NFloWx3dOc7+kDXdmCSL8HYlLj
        L2aM/cedXz7xlDdG5EgKW93s44w+u7QAjHcV7lQOa5cQhqB0AGq/tsF8pLLbn8qkv1ge4j
        uXFtWoLOUvtoYzbKv3B9in5P+l/Tfso=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-bhawvM7iOyyBVNBrLc8e1g-1; Thu, 07 Jan 2021 11:49:00 -0500
X-MC-Unique: bhawvM7iOyyBVNBrLc8e1g-1
Received: by mail-wr1-f69.google.com with SMTP id 4so2883035wrb.16
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:48:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NEWzDghVmoiWFPFqZnl2qZ7dTRKfMUgExc8FdbxchX0=;
        b=pNmp8niJ0W9YZY15m7cU1ykbVTH1aW7hxc21zpGm0n1bGDx4hxVNkLIPA9+zmP3s/g
         g/kCTZ8SC0m5ab4+d0ZVlpDJrZIUupeEebYRIz80vNrfbv1gE1xf6WMZg9V5+ESsRWtd
         uQEl6HE8b7ZnW8B208I5vUGE6XKt4cKlS7SqXUWO1VMuo7VR/jhP8hJ7hqHtDRnHDFgx
         HpHUhhlDgz/ORjj67rKwbG6urEtRcvRMNfKf73k336rIqWe3/a3t51maQLmtEg9CTKOh
         gVMcEzx6MyWdus/q/rsKcalSetOyjxtJOcfSVl8ZDvNCj5c0grCyTJ8boGFkArOTY8qb
         dGQg==
X-Gm-Message-State: AOAM533XIOqJ2zIpIwF0ktSM7ohohZQttDptNKGPLKmDiBoeL5McN9kq
        T+68xmso9t14/qzpTJRG/PVLLF3FDTpM/2ls1z73+Pgno2uMTZcFWWTdnQ7wQadzrozRwxhp83L
        IGilyTcJfhHm5LsHv
X-Received: by 2002:adf:fdce:: with SMTP id i14mr9903472wrs.58.1610038138668;
        Thu, 07 Jan 2021 08:48:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQkK5dPSPu0mqLRwtQIAeSrjNjD0TKgFgOuR5vtEdvR++3XUZ2QhSuFMF6RY7tidmGSInRgw==
X-Received: by 2002:adf:fdce:: with SMTP id i14mr9903464wrs.58.1610038138539;
        Thu, 07 Jan 2021 08:48:58 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z6sm9337725wrw.58.2021.01.07.08.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:48:57 -0800 (PST)
Date:   Thu, 7 Jan 2021 17:48:56 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <20210107164856.GC17363@linux.home>
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 11:25:32PM +0100, Guillaume Nault wrote:
> The json output of the TCA_FLOWER_KEY_MPLS_OPTS attribute was invalid.
> 
> Example:
> 
>   $ tc filter add dev eth0 ingress protocol mpls_uc flower mpls \
>       lse depth 1 label 100                                     \
>       lse depth 2 label 200
> 
>   $ tc -json filter show dev eth0 ingress
>     ...{"eth_type":"8847",
>         "  mpls":["    lse":["depth":1,"label":100],
>                   "    lse":["depth":2,"label":200]]}...

Is there any problem with this patch?
It's archived in patchwork, but still in state "new". Therefore I guess
it was dropped before being considered for review.

This problem precludes the implementation of a kernel selftest for
TCA_FLOWER_KEY_MPLS_OPTS.

Just let me know if I should respin.

Thanks,

William

