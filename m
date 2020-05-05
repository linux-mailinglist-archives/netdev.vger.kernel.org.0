Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286AC1C4DCA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 07:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgEEFve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 01:51:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:41497 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEFve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 01:51:34 -0400
IronPort-SDR: L6Hgm2HZlpn94KWtdft9QcWZ/MM85XYLAmZ+bC3wdJ5YnQMi4OBRuE9o6BJ8kDM3aBTatN0qVF
 CStRXoSAH7Kg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 22:51:33 -0700
IronPort-SDR: 7Y9jHygZnKSnAZbtwIh0VdUyRJfLV2zvyiNKZqvfjxN/rlyrkV/verR61t41KXveQoPpOKbwVd
 furVy/m1qY8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="338548394"
Received: from wpross-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.33.167])
  by orsmga001.jf.intel.com with ESMTP; 04 May 2020 22:51:30 -0700
Subject: Re: [RFC PATCH bpf-next 13/13] MAINTAINERS, xsk: update AF_XDP
 section after moves/adds
To:     Joe Perches <joe@perches.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     maximmi@mellanox.com, maciej.fijalkowski@intel.com
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
 <20200504113716.7930-14-bjorn.topel@gmail.com>
 <5ae86fa9e7fbb92e08055dd60526bf9802217f5f.camel@perches.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <7472483f-e3e4-0a47-f903-b5986e2832d8@intel.com>
Date:   Tue, 5 May 2020 07:51:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5ae86fa9e7fbb92e08055dd60526bf9802217f5f.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-05 05:02, Joe Perches wrote:
> On Mon, 2020-05-04 at 13:37 +0200, Björn Töpel wrote:
>> Update MAINTAINERS to correctly mirror the current AF_XDP socket file
>> layout. Also, add the AF_XDP files of libbpf.
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -18451,8 +18451,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
>>   L:	netdev@vger.kernel.org
>>   L:	bpf@vger.kernel.org
>>   S:	Maintained
>> -F:	kernel/bpf/xskmap.c
>>   F:	net/xdp/
>> +F:	include/net/xdp_sock*
>> +F:	include/net/xsk_buffer_pool.h
>> +F:	include/uapi/linux/if_xdp.h
>> +F:	tools/lib/bpf/xsk*
>> +F:	samples/bpf/xdpsock*
> 
> Alphabetic order in file patterns please
>

Thanks for pointing this out, Joe. I'll fix this in the next revision.

