Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43B6274ACC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIVVIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 17:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgIVVIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 17:08:13 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8491C206FB;
        Tue, 22 Sep 2020 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600808893;
        bh=BDZqDbEsDos24AuogLq7FSNVZYR47oBmsuzshIlUfoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJ7AU/9yLn2smE8LGi1p6MwmLz1Z8pLjt/9D1MCsE2JEL2NHFq1kZb6+f5ZxgTJR6
         +Hgz1vS9G0NoT1pVAXtV/jfMVXLPrA+aa6SuyGzWP1nkAFsW7R1MEoej+nC/xlikNE
         1VEMgNeGEMeYqGEDP8kb3PmWOUslrUdPkfQuWHZQ=
Date:   Tue, 22 Sep 2020 23:08:10 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 3/3] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
Message-ID: <20200922210809.GE5217@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-4-nitesh@redhat.com>
 <20200910192208.GA24845@fuller.cnet>
 <cfdf9186-89a4-2a29-9bbb-3bf3ffebffcd@redhat.com>
 <75a398cd-2050-e298-d718-eb56d4910133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a398cd-2050-e298-d718-eb56d4910133@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 09:54:58AM -0400, Nitesh Narayan Lal wrote:
> >> If min_vecs > num_housekeeping, for example:
> >>
> >> /* PCI MSI/MSIx support */
> >> #define XGBE_MSI_BASE_COUNT     4
> >> #define XGBE_MSI_MIN_COUNT      (XGBE_MSI_BASE_COUNT + 1)
> >>
> >> Then the protection fails.
> > Right, I was ignoring that case.
> >
> >> How about reducing max_vecs down to min_vecs, if min_vecs >
> >> num_housekeeping ?
> > Yes, I think this makes sense.
> > I will wait a bit to see if anyone else has any other comment and will post
> > the next version then.
> >
> 
> Are there any other comments/concerns on this patch that I need to address in
> the next posting?

No objection from me, I don't know much about this area anyway.

> -- 
> Nitesh
> 



