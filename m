Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0352587E9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 08:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgIAGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 02:13:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:24145 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgIAGNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 02:13:01 -0400
IronPort-SDR: N3Wjuo5KVDTqZoySiHLcqO31UpHuzvT2TWHvaq2kIkjecVGSXDleJGFgjn6/H9LE64YDmtPSuU
 yLDuni3Xl7tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="144856125"
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="144856125"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 23:13:00 -0700
IronPort-SDR: fcveK4Xd1ok6qSKSg/ca8jUiUE07Je+bJ/dmvDLANkrE0zdq7zyJ8zdvVK94A9AhJkVE4ag0z2
 zYV2DdTFzoTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="375051416"
Received: from swulich-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.34.221])
  by orsmga001.jf.intel.com with ESMTP; 31 Aug 2020 23:12:57 -0700
Subject: Re: [PATCH bpf-next] bpf: change bq_enqueue() return type from int to
 void
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        brouer@redhat.com
References: <20200831150730.35530-1-bjorn.topel@gmail.com>
 <8eda320b-3e32-d0c2-7746-cdef52b2468e@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <cca6e437-678d-2048-0bed-5e688566f45b@intel.com>
Date:   Tue, 1 Sep 2020 08:12:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8eda320b-3e32-d0c2-7746-cdef52b2468e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-31 18:07, David Ahern wrote:
> On 8/31/20 9:07 AM, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The bq_enqueue() functions for {DEV, CPU}MAP always return
>> zero. Changing the return type from int to void makes the code easier
>> to follow.
>>
> 
> You can expand that to a few other calls in this code path - both
> bq_flush_to_queue and bq_xmit_all always return 0 as well.
> 

Indeed! I'll spin a new rev!
