Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFF228032E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732673AbgJAPtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbgJAPtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:49:53 -0400
Received: from localhost (fla63-h02-176-172-189-251.dsl.sta.abo.bbox.fr [176.172.189.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DD6206A1;
        Thu,  1 Oct 2020 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601567392;
        bh=I9y5FouUKvTPoyTvm4LqdvOV87V49w2rnF7/C7hQ7T8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=amCKXMR/jm4a7P6Md8X9oYQ65K+m8txVg4DBdv5WIX2Q5foNCTHzgYmcwCOvPHjGV
         iZlvMT436Re1gSb3IfJNe6ycIak49x41hVZUO1Ro77nJgw+U9uK3FSFOZdw72I3gmE
         3Uz9zjtF9zSy0TKod2n1jMZ01BkhWiWE3P62uAhU=
Date:   Thu, 1 Oct 2020 17:49:49 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 0/4] isolation: limit msix vectors to housekeeping CPUs
Message-ID: <20201001154949.GA7303@lothringen>
References: <20200928183529.471328-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928183529.471328-1-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 02:35:25PM -0400, Nitesh Narayan Lal wrote:
> Nitesh Narayan Lal (4):
>   sched/isolation: API to get number of housekeeping CPUs
>   sched/isolation: Extend nohz_full to isolate managed IRQs
>   i40e: Limit msix vectors to housekeeping CPUs
>   PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c |  3 ++-
>  drivers/pci/msi.c                           | 18 ++++++++++++++++++
>  include/linux/sched/isolation.h             |  9 +++++++++
>  kernel/sched/isolation.c                    |  2 +-
>  4 files changed, 30 insertions(+), 2 deletions(-)

Acked-by: Frederic Weisbecker <frederic@kernel.org>

Peter, if you're ok with the set, I guess this should go through
the scheduler tree?

Thanks.
