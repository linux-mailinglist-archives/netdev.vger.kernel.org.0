Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9184A25DAD5
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgIDOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:01:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:24095 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgIDOA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:00:27 -0400
IronPort-SDR: 65VZGG23/E5V9kb830Tieb47qOVf6h81xhPI86ce1hYsykPuutVLA1Sj/0NWv/+V1QlMWXPUYW
 k/wMzqpCzjzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="157006154"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="157006154"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 06:59:48 -0700
IronPort-SDR: j93R8aZlSJKjGofhcd7+Qe56JKeSs7yvFb/NB1UsFzWZbhr5n8bouR1ytzk9K1Y3p2HjqwK59S
 HoiGUNFCbCDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="332171253"
Received: from andreyfe-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.37.82])
  by orsmga008.jf.intel.com with ESMTP; 04 Sep 2020 06:59:43 -0700
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0257f769-0f43-a5b7-176d-7c5ff8eaac3a@intel.com>
Date:   Fri, 4 Sep 2020 15:59:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 15:53, Björn Töpel wrote:
> This series addresses a problem that arises when AF_XDP zero-copy is 
> enabled, and the kernel softirq Rx processing and userland process
> is running on the same core.
> 
[...]
> 

@Maxim I'm not well versed in Mellanox drivers. Would this be relevant 
to mlx5 as well?


Cheers,
Björn
