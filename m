Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BBB22738C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGUAPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUAPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:15:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A517C061794;
        Mon, 20 Jul 2020 17:15:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so9876457pfu.1;
        Mon, 20 Jul 2020 17:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6zGvwhUe2FFGqztJFVymLHzK9QGdNzpkFLjmsFUfJ4M=;
        b=bfqqLWaGDnKvm/wes98UvCkw6qs9nxCE5n9cCUOEKMmg0n2q9WeXWTZ1OO1KpnIXM7
         53th1VKPHo6tk5S9I0Mk0C5JusNsFOJt6MGvjvkdZkUdzJPNvk5RuT8kJKubOQBmQMQ7
         quhbbjhwaXeqVj4pzxf1VPvpTQMNOimTVzu2SUmdyypJU5K6gQsxW7NRcQtyVHQaFsqg
         cv9nVyUv5z5ZbPjbrhKIoz8stBpASMmksn+SYBPhjlUDcTuKSeEWLWE6UugHYP3yiSJY
         eSVFFv2/ASLKnL05rQ4Gk3NoPPxX6qiXGZyJi2CglpLO+8zxk+2aY97xGU4VwU8YE+qW
         BKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6zGvwhUe2FFGqztJFVymLHzK9QGdNzpkFLjmsFUfJ4M=;
        b=OYO+7oXjdKQaVPsMQ9BuKOXehQK/OwKkFAZY+vtd180wETe1Qt6tU5MHPpY3d46wDp
         mQMfrCqDsfN8Zg/zxvNXAM9m65bHQo7yLs4X0+6jOip9G+qIPerUb4LswbE/d9D1eT04
         74zMA1QVHz800z0p2uLUF8DSQufN2Lhgind6dSOgnEu7nbsqSHUMqzCvXWllnf4NhbBi
         fu+M5LP8bHDXdlw2/Fz8v0FHqB3UAGvu47aHBLcNxraHP4AQ29iatI8Poi7LdfuJtEF1
         GvsEO3PmxrWRLGPIyaqSEa3TRceIjQlCDa7zOvFnV2uZPzPAyivcd5bofJQVVuxn5SVA
         AchA==
X-Gm-Message-State: AOAM533Tjs20zbukS1TcntSFn1i0q8lxbp1OyNr+bFK1/MiNjeLGG1qE
        mAL8bkrVu3deYQEa2EW87l8=
X-Google-Smtp-Source: ABdhPJw+pZ92XpemKJt+K7TYWeoPFNxtEMfnKmemXU/hmfPx3V07+fGiJRGxEZCCfYwWcM7E8O4Wyg==
X-Received: by 2002:a65:6799:: with SMTP id e25mr21593933pgr.364.1595290522861;
        Mon, 20 Jul 2020 17:15:22 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b15sm259764pje.52.2020.07.20.17.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:15:22 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:15:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200721001520.GA21585@hoboy>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720210518.5uddqqbjuci5wxki@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 12:05:18AM +0300, Vladimir Oltean wrote:
> 
> Yes, the problematic cases have to do with stacked PHCs (DSA, PHY). The
> pattern is that:
> - DSA sets SKBTX_IN_PROGRESS

Nit: DSA should _not_ set this bit (but a PHY/MII device should).

> - calls dev_queue_xmit towards the MAC driver
> - MAC driver sees SKBTX_IN_PROGRESS, thinks it's the one who set it
> - MAC driver delivers TX timestamp
> - DSA ends poll or receives TX interrupt, collects its timestamp, and
>   delivers a second TX timestamp

> So it's very far from obvious that setting this flag is 'the prevailing
> convention'. For a MAC driver, that might well be, but for DSA/PHY,
> there seem to be risks associated with doing that, and driver writers
> should know what they're signing up for.

The flag only exists to prevent the stack from delivering SW time
stamps when HW time stamps are active.  If an interface doesn't
provide SW time stamps (like DSA interfaces), then there is no need to
set the flag.

For MAC and PHY/MII time stamping, they must co-operate, meaning that
the MAC driver must be prepared to deal with the fact that the PHY/MII
might set this flag.  Many MAC drivers don't do this correctly, but
there are very few PHY/MII actually in use, and so very few authors of
MAC drivers have paid attention to this.

Thanks,
Richard
