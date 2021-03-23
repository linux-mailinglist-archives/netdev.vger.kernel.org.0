Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B7B346809
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhCWSqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhCWSqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:46:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E626C061574;
        Tue, 23 Mar 2021 11:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TyB4jsgy1fbxCs/NyuZjXpuJ7EYGZ4t4yL8X8bIIVyE=; b=kb88EJynv+gJRz/F6hUVKnuS2k
        ZlyZ93zYPJyRKl10g+Dqr2PqQ3ung8vgIp112dBGn1XjBBCEawQYvfvJP9JI5H89focMBQVgOOVsj
        y8Nnpr/VZCQY4C2TRsKJyiNnxHT5kWi55nHBqnISsekGxRSCP1W/QkH1aoU6f/JLtkWJLCNI3NdYG
        SA62mEHFIA6Gl15nO35NbMcW1C9FuZx01D4oukqITcdrysBb1ct2YaXYP/wihLKKF7HOkkXV2joL2
        b7BNM4sxaaZRyrX0BbS3m0FMCKfGa5Q31/JdOWfxQmixhNVfKIWXaJUYvgrepyhQJlgSR6gedPg0K
        CwRkeqIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOm1y-00AQAU-N9; Tue, 23 Mar 2021 18:45:35 +0000
Date:   Tue, 23 Mar 2021 18:45:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
Message-ID: <20210323184530.GA2483289@infradead.org>
References: <20210322161822.1546454-1-vinicius.gomes@intel.com>
 <20210322161822.1546454-2-vinicius.gomes@intel.com>
 <20210323160122.GC2438080@infradead.org>
 <87zgytk92s.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgytk92s.fsf@vcostago-mobl2.amr.corp.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:40:11AM -0700, Vinicius Costa Gomes wrote:
> > Without an EXPORT_SYMBOL_GPL this is not going to be very useful for
> > your driver.
> 
> Unless I am missing something here, the commit that made
> 'pci_enable_ptm()' private didn't remove the 'EXPORT_SYMBOL' from the
> function definition in drivers/pci/pcie/ptm.c.

OOPS, indeed.  Looks like right now the function is nindeed exported,
but has no single user at all.
