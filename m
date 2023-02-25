Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C666A2773
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYGJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYGJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:09:13 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448A13517;
        Fri, 24 Feb 2023 22:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677305352; x=1708841352;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ydnpuafRMywrMChE/DopyAUD95oiDpGr2V78Qp96dkI=;
  b=oHGIadDx8fchoa88qi8yIymk2ze9isoDtHlyEJf9C5FgzCbY6bMTsSrB
   NmAv1IlYlsPqPXuAMVjyjmvOXqUE6403X7p7+NLCeWxx0sropZFch+2n/
   jsP31+DUmMOorKEYFAEpMt+1pMs8MmhHgHl3bY5cH/QywhbDswo0eXUrJ
   KYebWw4xsYsX+HzrDI6WqXtaWMDyYpQFD0QmoSOKyhkwZxZAacHvk6kfR
   pO3UqiiJ4BpP1aS8zHn1KeSnSiZmbPqCddnFGyzAA6PwR+Tmg5kqOrnxX
   YnzzA/DtHJ+KuYXL6SMrpwryYuvYIEAo4P8GMPojfs8DSA7W2XUC049G0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="332326455"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="332326455"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:09:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="650583556"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="650583556"
Received: from soniyas1-mobl.amr.corp.intel.com (HELO [10.212.244.166]) ([10.212.244.166])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:09:11 -0800
Message-ID: <afcdeff6-e47e-6291-fa10-4919a50276c5@linux.intel.com>
Date:   Fri, 24 Feb 2023 22:09:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 1/5] Revert "PCI/ASPM: Unexport
 pcie_aspm_support_enabled()"
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, hkallweit1@gmail.com,
        nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
 <20230225034635.2220386-2-kai.heng.feng@canonical.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230225034635.2220386-2-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/23 7:46 PM, Kai-Heng Feng wrote:
> This reverts commit ba13d4575da5e656a3cbc18583e0da5c5d865417.
> 
> This will be used by module once again.

Since this is a single line change, why revert it? It should be simpler
to export it in the patch that needs it right?

> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v9:
>  - No change.
> 
> v8:
>  - New patch.
> 
>  drivers/pci/pcie/aspm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 4b4184563a927..692d6953f0970 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1372,3 +1372,4 @@ bool pcie_aspm_support_enabled(void)
>  {
>  	return aspm_support_enabled;
>  }
> +EXPORT_SYMBOL(pcie_aspm_support_enabled);

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
