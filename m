Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2C2B4DF5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbgKPRkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:40:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:61014 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732936AbgKPRkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:40:20 -0500
IronPort-SDR: M6my6m3HklLmYMq/h+wCILblybsoprQdDxuzgb+7y5D3djOSwHcw8Ad0GOkMVat4M79qtMbBxy
 47uV9SRXugVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="255495556"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="255495556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 09:40:19 -0800
IronPort-SDR: wLbC/q5eQ82Ws3LH7O++UpZ29nmqHbCUJB3jzIIGJuxpQViDMqK5jEznR/r7egJXK5mJhkbdsh
 oQRY8oV2NVqA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="543685613"
Received: from franders-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.35.195])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 09:40:11 -0800
Subject: Re: [PATCH bpf-next v2 06/10] xsk: propagate napi_id to XDP socket Rx
 path
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        intel-wired-lan@lists.osuosl.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        sgoutham@marvell.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, thomas.petazzoni@bootlin.com,
        mcroce@microsoft.com, saeedm@nvidia.com, tariqt@nvidia.com,
        aelior@marvell.com, ecree@solarflare.com,
        ilias.apalodimas@linaro.org, grygorii.strashko@ti.com,
        sthemmin@microsoft.com, kda@linux-powerpc.org
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
 <20201116110416.10719-7-bjorn.topel@gmail.com>
 <20201116064953-mutt-send-email-mst@kernel.org>
 <614a7ce4-2b6b-129b-de7d-71428f7a71f6@intel.com>
 <20201116073848-mutt-send-email-mst@kernel.org>
 <585b011f-0817-a684-d1db-125bb55741fe@intel.com>
 <20201116085548-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <6dc830b3-4ca4-c349-4005-952cfa437328@intel.com>
Date:   Mon, 16 Nov 2020 18:40:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201116085548-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-11-16 14:55, Michael S. Tsirkin wrote:
[...]
> 
> tun too ;)
> 

:-) AFAIK tun doesn't use "Rx" napi, just netif_tx_napi_add() which
doesn't generate a napi_id.
