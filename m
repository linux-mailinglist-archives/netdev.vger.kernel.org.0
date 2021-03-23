Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE963467E8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhCWSku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:40:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:11908 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhCWSkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 14:40:13 -0400
IronPort-SDR: Bx47M6F+sVHwqDdofKCRpfiCubVR11spYJaBL/UGCb3EyoM6+VHpmkBadwAL6neUKbptSCdPEX
 jlYr2uDzUEfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="188222881"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="188222881"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 11:40:12 -0700
IronPort-SDR: kaTgHydsjhC4c6IVJcL2IUITm3tNUuhmOzdgw2gzCYcpNnFnI6n6KJ9j4/42K6B8uzzIaS/39T
 BF0MhDBU2blA==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="374345719"
Received: from ckane-desk.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.48.247])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 11:40:11 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
In-Reply-To: <20210323160122.GC2438080@infradead.org>
References: <20210322161822.1546454-1-vinicius.gomes@intel.com>
 <20210322161822.1546454-2-vinicius.gomes@intel.com>
 <20210323160122.GC2438080@infradead.org>
Date:   Tue, 23 Mar 2021 11:40:11 -0700
Message-ID: <87zgytk92s.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Mar 22, 2021 at 09:18:20AM -0700, Vinicius Costa Gomes wrote:
>> Make pci_enable_ptm() accessible from the drivers.
>> 
>> Even if PTM still works on the platform I am using without calling
>> this function, it might be possible that it's not always the case.
>> 
>> Exposing this to the driver enables the driver to use the
>> 'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.
>> 
>> This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Without an EXPORT_SYMBOL_GPL this is not going to be very useful for
> your driver.

Unless I am missing something here, the commit that made
'pci_enable_ptm()' private didn't remove the 'EXPORT_SYMBOL' from the
function definition in drivers/pci/pcie/ptm.c.


Cheers,
-- 
Vinicius
