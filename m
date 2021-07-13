Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35943C6990
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 06:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhGMFBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 01:01:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:8072 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhGMFBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 01:01:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="207080215"
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="207080215"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 21:58:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="492567823"
Received: from mckumar-mobl.gar.corp.intel.com (HELO [10.215.202.204]) ([10.215.202.204])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 21:58:51 -0700
Subject: Re: [PATCH] net: wwan: iosm: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <dd34ecd3c8afe5a9a29e026035a4a11c63e033ae.1626014972.git.christophe.jaillet@wanadoo.fr>
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Message-ID: <754912a3-d1fe-516f-d64b-e8a70a93d570@intel.com>
Date:   Tue, 13 Jul 2021 10:28:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dd34ecd3c8afe5a9a29e026035a4a11c63e033ae.1626014972.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/2021 8:21 PM, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'ipc_protocol_init()' GFP_KERNEL can be used
> because this flag is already used a few lines above and no lock is
> acquired in the between.
> 
> When memory is allocated in 'ipc_protocol_msg_prepipe_open()' GFP_ATOMIC
> should be used because this flag is already used a few lines above.

Thanks,
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>

Regards,
Chetan
