Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C729022B3B8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgGWQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:40:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:13808 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWQkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:40:01 -0400
IronPort-SDR: Ps6lxktqZPzDG6aOhdjcaafItVwSOONYr5McH+7oR+KDCLfdeBEBavuLPpe+g+xJ/P99HAneEN
 egw0JG2dSxwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148064756"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="148064756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 09:40:01 -0700
IronPort-SDR: 5GmwT65orXDGe/5uyfIvoLiiaO+4SJDsyX02gvYQXFqHlM1JMTR5mSOVsf/Os6ZLLSLCAm4TV6
 06oammawXIOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="432797443"
Received: from tthayer-hp-z620.an.intel.com (HELO [10.122.105.146]) ([10.122.105.146])
  by orsmga004.jf.intel.com with ESMTP; 23 Jul 2020 09:39:59 -0700
Reply-To: thor.thayer@linux.intel.com
Subject: Re: [PATCH v4 06/10] net: eth: altera: Add missing identifier names
 to function declarations
To:     "Ooi, Joyce" <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
 <20200708072401.169150-7-joyce.ooi@intel.com>
From:   Thor Thayer <thor.thayer@linux.intel.com>
Message-ID: <74536ddf-f268-937a-8d06-f91cbc0879d6@linux.intel.com>
Date:   Thu, 23 Jul 2020 11:40:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708072401.169150-7-joyce.ooi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 2:23 AM, Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@linux.intel.com>
> 
> The sgdma and msgdma header files included function declarations
> without identifier names for pointers.  Add appropriate identifier
> names.
> 
> Signed-off-by: Dalon Westergreen <dalon.westergreen@linux.intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: this patch is added in patch version 2
> v3: no change
> v4: no change
> ---
>   drivers/net/ethernet/altera/altera_msgdma.h | 30 ++++++++++++++-------------
>   drivers/net/ethernet/altera/altera_sgdma.h  | 32 +++++++++++++++--------------
>   2 files changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/ethernet/altera/altera_msgdma.h b/drivers/net/ethernet/altera/altera_msgdma.h
> index 9813fbfff4d3..23f5b2a13898 100644
> --- a/drivers/net/ethernet/altera/altera_msgdma.h
> +++ b/drivers/net/ethernet/altera/altera_msgdma.h
> @@ -6,19 +6,21 @@
>   #ifndef __ALTERA_MSGDMA_H__
>   #define __ALTERA_MSGDMA_H__
>   
> -void msgdma_reset(struct altera_tse_private *);
> -void msgdma_enable_txirq(struct altera_tse_private *);
> -void msgdma_enable_rxirq(struct altera_tse_private *);
> -void msgdma_disable_rxirq(struct altera_tse_private *);
> -void msgdma_disable_txirq(struct altera_tse_private *);
> -void msgdma_clear_rxirq(struct altera_tse_private *);
> -void msgdma_clear_txirq(struct altera_tse_private *);
> -u32 msgdma_tx_completions(struct altera_tse_private *);
> -void msgdma_add_rx_desc(struct altera_tse_private *, struct tse_buffer *);
> -int msgdma_tx_buffer(struct altera_tse_private *, struct tse_buffer *);
> -u32 msgdma_rx_status(struct altera_tse_private *);
> -int msgdma_initialize(struct altera_tse_private *);
> -void msgdma_uninitialize(struct altera_tse_private *);
> -void msgdma_start_rxdma(struct altera_tse_private *);
> +void msgdma_reset(struct altera_tse_private *priv);
> +void msgdma_enable_txirq(struct altera_tse_private *priv);
> +void msgdma_enable_rxirq(struct altera_tse_private *priv);
> +void msgdma_disable_rxirq(struct altera_tse_private *priv);
> +void msgdma_disable_txirq(struct altera_tse_private *priv);
> +void msgdma_clear_rxirq(struct altera_tse_private *priv);
> +void msgdma_clear_txirq(struct altera_tse_private *priv);
> +u32 msgdma_tx_completions(struct altera_tse_private *priv);
> +void msgdma_add_rx_desc(struct altera_tse_private *priv,
> +			struct tse_buffer *buffer);
> +int msgdma_tx_buffer(struct altera_tse_private *priv,
> +		     struct tse_buffer *buffer);
> +u32 msgdma_rx_status(struct altera_tse_private *priv);
> +int msgdma_initialize(struct altera_tse_private *priv);
> +void msgdma_uninitialize(struct altera_tse_private *priv);
> +void msgdma_start_rxdma(struct altera_tse_private *priv);
>   
>   #endif /*  __ALTERA_MSGDMA_H__ */
> diff --git a/drivers/net/ethernet/altera/altera_sgdma.h b/drivers/net/ethernet/altera/altera_sgdma.h
> index 08afe1c9994f..3fb201417820 100644
> --- a/drivers/net/ethernet/altera/altera_sgdma.h
> +++ b/drivers/net/ethernet/altera/altera_sgdma.h
> @@ -6,20 +6,22 @@
>   #ifndef __ALTERA_SGDMA_H__
>   #define __ALTERA_SGDMA_H__
>   
> -void sgdma_reset(struct altera_tse_private *);
> -void sgdma_enable_txirq(struct altera_tse_private *);
> -void sgdma_enable_rxirq(struct altera_tse_private *);
> -void sgdma_disable_rxirq(struct altera_tse_private *);
> -void sgdma_disable_txirq(struct altera_tse_private *);
> -void sgdma_clear_rxirq(struct altera_tse_private *);
> -void sgdma_clear_txirq(struct altera_tse_private *);
> -int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *);
> -u32 sgdma_tx_completions(struct altera_tse_private *);
> -void sgdma_add_rx_desc(struct altera_tse_private *priv, struct tse_buffer *);
> -void sgdma_status(struct altera_tse_private *);
> -u32 sgdma_rx_status(struct altera_tse_private *);
> -int sgdma_initialize(struct altera_tse_private *);
> -void sgdma_uninitialize(struct altera_tse_private *);
> -void sgdma_start_rxdma(struct altera_tse_private *);
> +void sgdma_reset(struct altera_tse_private *priv);
> +void sgdma_enable_txirq(struct altera_tse_private *priv);
> +void sgdma_enable_rxirq(struct altera_tse_private *priv);
> +void sgdma_disable_rxirq(struct altera_tse_private *priv);
> +void sgdma_disable_txirq(struct altera_tse_private *priv);
> +void sgdma_clear_rxirq(struct altera_tse_private *priv);
> +void sgdma_clear_txirq(struct altera_tse_private *priv);
> +int sgdma_tx_buffer(struct altera_tse_private *priv,
> +		    struct tse_buffer *buffer);
> +u32 sgdma_tx_completions(struct altera_tse_private *priv);
> +void sgdma_add_rx_desc(struct altera_tse_private *priv,
> +		       struct tse_buffer *buffer);
> +void sgdma_status(struct altera_tse_private *priv);
> +u32 sgdma_rx_status(struct altera_tse_private *priv);
> +int sgdma_initialize(struct altera_tse_private *priv);
> +void sgdma_uninitialize(struct altera_tse_private *priv);
> +void sgdma_start_rxdma(struct altera_tse_private *priv);
>   
>   #endif /*  __ALTERA_SGDMA_H__ */
> 
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
