Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96F227B84C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgI1Xfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:35:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:57791 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgI1Xfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:35:38 -0400
IronPort-SDR: 56unekRHEtxFWO4tphIjWWP196dPpIKT+KEaiZQF7lTLmlHvhS2e2azaFazRsM8Bjuo/J19nvT
 NnlkMTeJdwXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162954611"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="162954611"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 15:32:26 -0700
IronPort-SDR: l1LXZVtDg3Pz6xFidwHb1+h8Lc9tmcugUaI8PZ8Ftp9x1S7NDK2APlag9o0GfwlFsjx8eY/3Ts
 SPh5GTyPAnJg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="457017844"
Received: from unknown (HELO ellie) ([10.254.6.151])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 15:32:25 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        andre.guedes@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH next-queue v1 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
In-Reply-To: <20200928215432.GA2499272@bjorn-Precision-5520>
References: <20200928215432.GA2499272@bjorn-Precision-5520>
Date:   Mon, 28 Sep 2020 15:32:23 -0700
Message-ID: <87h7rhv8g8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Fri, Sep 25, 2020 at 04:28:32PM -0700, Vinicius Costa Gomes wrote:
>> Make pci_enable_ptm() accessible from the drivers.
>> 
>> Even if PTM still works on the platform I am using without calling
>> this this function, it might be possible that it's not always the
>> case.
>
> *Does* PTM work on your system without calling pci_enable_ptm()?  If
> so, I think that would mean the BIOS enabled PTM, and that seems
> slightly surprising.
>

At least it seems to work, yeah, the PTM related registers that I need
for cross timestamping still return valid results when I don't call
pci_enable_ptm().

Btw, I just noticed a typo in the commit message, will fix it for the
v2.

>> Exposing this to the driver enables the driver to use the
>> 'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.
>> 
>> This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> AFAICT we just never had any callers at all for pci_enable_ptm().  I
> probably shouldn't have merged it in the first place.
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>

Thanks.

-- 
Vinicius
