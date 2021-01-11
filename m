Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EED2F14C7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbhAKNaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:30:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:35059 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733042AbhAKN2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 08:28:11 -0500
IronPort-SDR: GffsZxxTHeFG1XeW0Uq5GQM579DBO9ysgowumx55jNXSP7Xeth235/RngKrvDzamKyRk5xWI7L
 c+TDRNJTmGlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9860"; a="175280821"
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="175280821"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 05:26:08 -0800
IronPort-SDR: 9rR6L8Ra2W2XoqC4xXwCfSU+DGNafg++oodP96V4LoXDNkru7uqyOtpLuWUDc0gcxrq6T4a1zg
 d6tBu8T/W0PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="423789385"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 11 Jan 2021 05:26:04 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 9B0E4114; Mon, 11 Jan 2021 15:26:02 +0200 (EET)
Date:   Mon, 11 Jan 2021 16:26:02 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Radev, Martin" <martin.radev@aisec.fraunhofer.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "Morbitzer, Mathias" <mathias.morbitzer@aisec.fraunhofer.de>,
        Robert Buhren <robert.buhren@sect.tu-berlin.de>,
        "file@sect.tu-berlin.de" <file@sect.tu-berlin.de>,
        "Banse, Christian" <christian.banse@aisec.fraunhofer.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel
 TDX
Message-ID: <20210111132602.bcd5hmtoqe4dcjwp@black.fi.intel.com>
References: <AM7P194MB0900E443CEBD6EF2EE37325ED9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
 <AM7P194MB09004AD790C5C85EDCB42323D9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7P194MB09004AD790C5C85EDCB42323D9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 03:31:56PM +0000, Radev, Martin wrote:
> Just noticed that Intel TDX already does the device filtering. Check: https://github.com/intel/tdx/commit/6789eee52aab8985e49b362379fab73aa3eecde2
> 
> CC-ing Kirill and Kuppuswamy from Intel in case they want to be part of the discussion.
> ________________________________
> From: Radev, Martin
> Sent: Friday, January 8, 2021 12:57 PM
> To: netdev@vger.kernel.org <netdev@vger.kernel.org>; intel-wired-lan@lists.osuosl.org <intel-wired-lan@lists.osuosl.org>
> Cc: doshir@vmware.com <doshir@vmware.com>; jesse.brandeburg@intel.com <jesse.brandeburg@intel.com>; anthony.l.nguyen@intel.com <anthony.l.nguyen@intel.com>; Morbitzer, Mathias <mathias.morbitzer@aisec.fraunhofer.de>; Robert Buhren <robert.buhren@sect.tu-berlin.de>; file@sect.tu-berlin.de <file@sect.tu-berlin.de>; Banse, Christian <christian.banse@aisec.fraunhofer.de>; brijesh.singh@amd.com <brijesh.singh@amd.com>; Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>; pv-drivers@vmware.com <pv-drivers@vmware.com>; martin.b.radev@gmail.com <martin.b.radev@gmail.com>
> Subject: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel TDX
> 
> Hello everybody,
> 
> tldr: Both drivers expose skb GVAs to untrusted devices which gives RIP
>          control to a malicious e100 / vmxnet3 device implementation. This is
>          an issue for AMD SEV (-SNP) [1] and likely Intel TDX [2].
> 
> Felicitas and Robert have started a project on fuzzing device drivers which
> may have negative security impact on solutions like AMD SEV Secure
> Nested Paging and Intel Trusted Domain Extensions. These solutions protect
> a VM from a malicious Hypervisor in various way.
> 
> There are a couple of devices which carry security issues under the attacker
> models of SEV-SNP / Intel TDX, but here we're only discussing VMXNET3 and
> e100, because we have detailed PoCs for both.
> 
> Maintainers of both vmxnet3 and e100 were added in this email because the
> discussion will likely be the same. The issues were already sent to AMD PSIRT,
> and Tom Lendacky and Brijesh Singh have volunteered to be part of the email
> communication with the maintainers. Both have been working on AMD SEV.
> 
> Please check the two attached files: vmxnet3_report.txt and e100_report.txt.
> Both contain detailed information about what the issue is and how it can be
> exploited by a malicious HV or attacker who has access to the QEMU process.
> 
> Fix:
> In an earlier discussion with AMD, there was the idea of making a list of
> allowed devices with SEV and forbidding everything else. This would avoid
> issues with other drivers whose implementation has not been yet scrutinized
> under the threat model of SEV-SNP and Intel Trusted Domain Extensions.

+Andi.

Right. Our TDX guest enabling has white list of devices that allowed to be
used. For now it's only VirtIO, but I believe it also requires hardening.
We need to validate any VMM input.

It might be beneficial to have coordination between Intel and AMD on what
devices (and device drivers) considered to be safe for trusted computing.
I think we can share burden of code audit and fuzzing.

-- 
 Kirill A. Shutemov
