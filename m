Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1B182520
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgCKWlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:41:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:32338 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387410AbgCKWlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:41:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 15:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,542,1574150400"; 
   d="scan'208";a="389411759"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga004.jf.intel.com with ESMTP; 11 Mar 2020 15:41:35 -0700
Subject: Re: [PATCH net-next 08/15] net: fm10k: reject unsupported coalescing
 params
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@linux.intel.com
References: <20200311223302.2171564-1-kuba@kernel.org>
 <20200311223302.2171564-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <6d74fc75-a0c8-2d9c-5ecc-c37c5da4c2ef@intel.com>
Date:   Wed, 11 Mar 2020 15:41:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311223302.2171564-9-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/2020 3:32 PM, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> index 68edf55ac906..37fbc646deb9 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> @@ -1151,6 +1151,8 @@ static int fm10k_set_channels(struct net_device *dev,
>  }
>  
>  static const struct ethtool_ops fm10k_ethtool_ops = {
> +	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> +				     ETHTOOL_COALESCE_USE_ADAPTIVE,
>  	.get_strings		= fm10k_get_strings,
>  	.get_sset_count		= fm10k_get_sset_count,
>  	.get_ethtool_stats      = fm10k_get_ethtool_stats,
> 
