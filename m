Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB536A2776
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBYGK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYGK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:10:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E11F57D33;
        Fri, 24 Feb 2023 22:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677305455; x=1708841455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qs8TowkeaJTOr+OC7UE5rISgjUgqB6IL5jioaVAOZ3s=;
  b=OWCdSPVkz6HorEgN+oCMpzbF7jcLKf2wjZnSTstnJJ4DlBvuFOU2ld9z
   zeSTMTBSOqs6/8UwcbdHi2MOsmAyB3rXqMQupEaocwnTa83e5td5yp44m
   WFyE59wfRlo3YpfGlkrgI+W+faTMEmidBNAmXPoEqaW428jZN6b8nQ27d
   5D68eQauLX5fkrw83EMKw0GLHz+QjEwYUDK5ypdsCnDQDmSL68KmbzXT1
   MQrWKsaeC0GzhYgjVk1X7NpI7RTYbU99dNYQvhoTleevVGZcu4ROqghLz
   uai9wHmd2ghvxALRFznA+FkRGuzKjmfyB7n6ePKI4vSlDHMVupl6fWJJc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="332326565"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="332326565"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:10:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="650584082"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="650584082"
Received: from soniyas1-mobl.amr.corp.intel.com (HELO [10.212.244.166]) ([10.212.244.166])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:10:54 -0800
Message-ID: <33930e67-d2fb-1aa9-ba72-9ae61892e0fc@linux.intel.com>
Date:   Fri, 24 Feb 2023 22:10:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 2/5] PCI/ASPM: Add pcie_aspm_capable() helper
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, hkallweit1@gmail.com,
        nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
 <20230225034635.2220386-3-kai.heng.feng@canonical.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230225034635.2220386-3-kai.heng.feng@canonical.com>
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
> Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.
> 
> The user will be introduced by next patch.

Instead of just saying next patch, just say which driver or use case is
going to use it.

> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v9:
> v8:
>  - No change.
> 
> v7:
>  - Change subject.
> 
> v6:
>  - No change.
> 
> v5:
>  - No change.
> 
> v4:
>  - Report aspm_capable instead.
> 
> v3:
>  - This is a new patch
> 
>  drivers/pci/pcie/aspm.c | 11 +++++++++++
>  include/linux/pci.h     |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 692d6953f0970..d96bf0a362aa2 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1199,6 +1199,17 @@ bool pcie_aspm_enabled(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL_GPL(pcie_aspm_enabled);
>  
> +bool pcie_aspm_capable(struct pci_dev *pdev)
> +{
> +	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
> +
> +	if (!link)
> +		return false;
> +
> +	return link->aspm_capable;
> +}
> +EXPORT_SYMBOL_GPL(pcie_aspm_capable);
> +
>  static ssize_t aspm_attr_show_common(struct device *dev,
>  				     struct device_attribute *attr,
>  				     char *buf, u8 state)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index adffd65e84b4e..fd56872883e14 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1692,6 +1692,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
>  void pcie_no_aspm(void);
>  bool pcie_aspm_support_enabled(void);
>  bool pcie_aspm_enabled(struct pci_dev *pdev);
> +bool pcie_aspm_capable(struct pci_dev *pdev);
>  #else
>  static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
>  { return 0; }
> @@ -1700,6 +1701,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  static inline void pcie_no_aspm(void) { }
>  static inline bool pcie_aspm_support_enabled(void) { return false; }
>  static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
> +static inline bool pcie_aspm_capable(struct pci_dev *pdev) { return false; }
>  #endif
>  
>  #ifdef CONFIG_PCIEAER

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
