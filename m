Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3544815A145
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 07:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgBLG3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 01:29:53 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34993 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgBLG3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 01:29:53 -0500
Received: by mail-wr1-f43.google.com with SMTP id w12so737346wrt.2
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 22:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pItV3/3Hj7DWUi7bWcMdxXGwSnz+kOatMuXj/xey/20=;
        b=eFyxlxqlNpwqpUoOOCUdsLwE4ZYU2lIc9112YabR2J1keX8hK9ip2Heo6jLSF+pu+J
         TM57AvtCReZKA0zv+6JMakI87fXp+UUyEVFjH3SBUNMKPdGu5d9tKlLoEYG9NJ+lPFxR
         aZOPH+Jy/7gCfTdUg3hlxMqBPqNTddSj6iiQ0wCuswmkjBIBhNnzZ5rv7TCfOh6c9mo2
         fQRotdir7oDf/v+Mqyj09pv/KoI4yVKlljHubGnML1fad9C+nMuDDmDJQ8i889SE/yeo
         0QhVmnVsEW4GE6i5w6xsvQ9JnWyxGahgOKo2REeuPZ1EEpQyAWs8gQXngMuYnIWl6nrx
         htQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pItV3/3Hj7DWUi7bWcMdxXGwSnz+kOatMuXj/xey/20=;
        b=S0wn1KhN8sra4WnOlpb1kh7bQmAiTgtW0rqIEaju6n+Jn9WqY7EY97tP9EJN7VwyKu
         Ct7+XOqZFbtg2P/55nO3vJRAOzxe77HGsJTpuHEdtT0iEx11rl1oLdptWXPHS4uoev1T
         UG2S/hHFzG8nrpF7rka3D7y8nhy8AljjEvI78Cl4DLKv2NjO+ljpe6qbH8oVuRJ5Xa6s
         VFCV1FYJ9UVIX+BLIWYIlsi6tAVKtyLAsUYGI4U0tPjVRIPwMEYHTWql2jD+g2U1GEhG
         WT3k6eTcsmOpEeZ1rdXA+RdDxC876s7nGAawN+e2qux2lmoOF79DRFlXoZm4ZOhFsRE/
         lNwA==
X-Gm-Message-State: APjAAAVDxTr8gQ1jCICIkGLBvGwH2hZ1EUHsdhzVSKnt2A/oDX+FYHCN
        JI5LWKiGqgmh0nEyxjll7k6PUw==
X-Google-Smtp-Source: APXvYqy0IACO/46r8B32bt5bIVRCSTtxVL04mNEhjv9xYiqv/YW/4SSnS1GnFjMwGhNoqPDlJVg+gw==
X-Received: by 2002:adf:e686:: with SMTP id r6mr13360911wrm.177.1581488990940;
        Tue, 11 Feb 2020 22:29:50 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id s15sm7959241wrp.4.2020.02.11.22.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 22:29:50 -0800 (PST)
Date:   Wed, 12 Feb 2020 08:29:47 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     brouer@redhat.com, lorenzo@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH, net-next] net: page_pool: Add documentation on page_pool
 API
Message-ID: <20200212062947.GA1171328@apalos.home>
References: <20200211154227.1169600-1-ilias.apalodimas@linaro.org>
 <25360a12-90ce-39ac-4956-8591a8c4eb74@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25360a12-90ce-39ac-4956-8591a8c4eb74@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> 
> what about 'order'?  is it optional?

I actually forgot about it, i'll add it on v2

> 
> > +    * pool_size:  size of the ptr_ring
> > +    * nid:        preferred NUMA node for allocation
> > +    * dev:        struct device. Used on DMA operations
> > +    * dma_dir:    DMA direction
> > +    * max_len:    max DMA sync memory size
> > +    * offset:     DMA address offset
> > +
> > +* page_pool_put_page(): The outcome of this depends on the page refcnt. If the
> > +  driver uses refcnt > 1 this will unmap the page. If the pool object is
> > +  responsible for DMA operations and account for the in-flight counting. 
> 
> Hm, above is not a sentence and it ends with a space character.
> Several lines end with a space character.  :(

i'll fix both on V2

> 
> > +  If the refcnt is 1, the allocator owns the page and will try to recycle and 
> > +  sync it to be re-used by the device using dma_sync_single_range_for_device().
> > +
> > +* page_pool_release_page(): Unmap the page (if mapped) and account for it on
> > +  inflight counters.
> 
> inflight is spelled as in-flight earlier.  Just choose one way, please.

ok

[...]
> > +    page_pool_put_page(page_pool, page, false);
> > +    xdp_rxq_info_unreg(&xdp_rxq);
> > +    page_pool_destroy(page_pool);

Thanks for the review, i'll wait until net-next reopens and update this

/Ilias
