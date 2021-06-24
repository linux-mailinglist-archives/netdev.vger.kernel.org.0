Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6283B3033
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhFXNkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:40:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:46863 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhFXNkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 09:40:09 -0400
IronPort-SDR: xPtQV2aRHDAQ1iX37jpFaWV+CtO5tqF+u36IdqefQm3EqzP6gv5wcLNm9xVWrZtg4aWQeIWWUu
 JTojFaFC2GbA==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="204461080"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="204461080"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 06:37:48 -0700
IronPort-SDR: hsyGtgr1AkJRH4vCogDTqIzy7Ov7yFK+kAqoWLOXWKfc1jljhbW57Tw7VoslPX0MHPLjPPvZXz
 7fLYWm9E2Zsw==
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487757005"
Received: from dfuxbrum-mobl.ger.corp.intel.com (HELO [10.13.13.106]) ([10.13.13.106])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 06:37:46 -0700
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix an error handling path in
 'e1000_probe()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
References: <2651bb1778490c45d963122619fe3403fdf6b9de.1623819901.git.christophe.jaillet@wanadoo.fr>
From:   "Fuxbrumer, Dvora" <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <c2ed2d13-6949-3f78-a28f-752cff8b08ee@linux.intel.com>
Date:   Thu, 24 Jun 2021 16:37:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2651bb1778490c45d963122619fe3403fdf6b9de.1623819901.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/2021 08:05, Christophe JAILLET wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: 111b9dc5c981 ("e1000e: add aer support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 1 +
>   1 file changed, 1 insertion(+)
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
