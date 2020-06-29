Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DB320E361
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390401AbgF2VNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730123AbgF2S5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:57:43 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D088C030787;
        Mon, 29 Jun 2020 08:18:51 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvYN-0003Oq-V0; Mon, 29 Jun 2020 17:18:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvYN-000POt-Hi; Mon, 29 Jun 2020 17:18:39 +0200
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        maximmi@mellanox.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
 <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net>
 <81aec200-c1a0-6d57-e3b6-26dad30790b8@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
Date:   Mon, 29 Jun 2020 17:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <81aec200-c1a0-6d57-e3b6-26dad30790b8@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 5:10 PM, Björn Töpel wrote:
> On 2020-06-29 15:52, Daniel Borkmann wrote:
>>
>> Ok, fair enough, please work with DMA folks to get this properly integrated and
>> restored then. Applied, thanks!
> 
> Daniel, you were too quick! Please revert this one; Christoph just submitted a 4-patch-series that addresses both the DMA API, and the perf regression!

Nice, tossed from bpf tree then! (Looks like it didn't land on the bpf list yet,
but seems other mails are currently stuck as well on vger. I presume it will be
routed to Linus via Christoph?)

Thanks,
Daniel
