Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5888346940
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhCWTlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:41:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:46567 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhCWTkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:40:52 -0400
IronPort-SDR: EKtEONcOmc2ZuCZbW2IURHUMcCaPYV4Cx/nHl29abdImb00PfbaPRwrvmLsbswwSunBIgacj+B
 yx20XDs6/ejw==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="178118859"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="178118859"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:40:51 -0700
IronPort-SDR: 50JVbDM3OXVNtr/9fTbaGCYta4bCy8TsLKj4kOe4teHrkNLyvLOKCFUUJiA5ZElecQnWCZKuJQ
 DkCCGOfYXgLQ==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="452283510"
Received: from ckane-desk.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.48.247])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:40:50 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 2/3] igc: Enable PCIe PTM
In-Reply-To: <20210323192920.GA597326@bjorn-Precision-5520>
References: <20210323192920.GA597326@bjorn-Precision-5520>
Date:   Tue, 23 Mar 2021 12:40:49 -0700
Message-ID: <87mtutk69q.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Mon, Mar 22, 2021 at 09:18:21AM -0700, Vinicius Costa Gomes wrote:
>> In practice, enabling PTM also sets the enabled_ptm flag in the PCI
>> device, the flag will be used for detecting if PTM is enabled before
>> adding support for the SYSOFFSET_PRECISE ioctl() (which is added by
>> implementing the getcrosststamp() PTP function).
>
> I think you're referring to the "pci_dev.ptm_enabled" flag.  I'm not
> sure what the connection to this patch is.  The SYSOFFSET_PRECISE
> stuff also seems to belong with some other patch.

Yeah, I will improve the commit message to make it clear that this patch
is a preparation patch for the one that will add support for
PTP_SYS_OFFSET_PRECISE/getcrosststamp() and what's the relation with
PCIe PTM.

>
> This patch merely enables PTM if it's supported (might be worth
> expanding Precision Time Measurement for context).

Yes. Will expand the definition in the commit message.


Cheers,
-- 
Vinicius
