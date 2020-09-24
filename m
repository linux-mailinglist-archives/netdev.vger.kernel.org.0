Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75A227716A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgIXMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgIXMqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:46:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14CDC0613CE;
        Thu, 24 Sep 2020 05:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H+NuQC2ydn+3c8TeWONHmZD2Wn+Q0rKHcvASi9MJfyg=; b=vRni5o3W+fkqU3HdpPyIx+zJ5z
        cm/15c3T8XFrvxPimIANQdEi8yq9HFFxcHT/7YInRgUf/OKoEn8RBl3/C0Ts8/PiDmCD5TF4D5EG2
        BV1daaMSk7u3u7boeSegr550qSJIEnXI3Jyl7km3dwSLhCajBoVG4hqCDvvVyJT5QqHxOJEqHX0fh
        t4bTk6WweLAlHZCoH5ELkDVCvmvydOWpB1KEuLo6sUA7FKNkBo2uG2VrjFoNMtQYSh7eBMbIxSvbT
        TJeNi1l6M8e/XCCv0baRnaOgkz4uVWt7z3FwVvyF0jxYoYKdkdC7NYatwWyoNxT9YsNQxELwcbOE4
        nIwlf2Hg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLQdg-0007Si-Qk; Thu, 24 Sep 2020 12:46:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 42E143060C5;
        Thu, 24 Sep 2020 14:46:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EF0DC20AC5164; Thu, 24 Sep 2020 14:46:19 +0200 (CEST)
Date:   Thu, 24 Sep 2020 14:46:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
Message-ID: <20200924124619.GL2628@hirez.programming.kicks-ass.net>
References: <20200923181126.223766-1-nitesh@redhat.com>
 <20200923181126.223766-2-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923181126.223766-2-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



FWIW, cross-posting to moderated lists is annoying. I don't know why we
allow them in MAINTAINERS :-(
