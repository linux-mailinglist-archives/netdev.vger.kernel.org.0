Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1520D42F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgF2TGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbgF2TCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:43 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Jun 2020 07:16:46 PDT
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337D4C02E2E8;
        Mon, 29 Jun 2020 07:16:46 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpuDM-0001DH-6o; Mon, 29 Jun 2020 15:52:52 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpuDL-0002Xa-QH; Mon, 29 Jun 2020 15:52:51 +0200
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net>
Date:   Mon, 29 Jun 2020 15:52:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25857/Sun Jun 28 15:28:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/20 7:16 PM, Björn Töpel wrote:
> On 2020-06-27 09:04, Christoph Hellwig wrote:
>> On Sat, Jun 27, 2020 at 01:00:19AM +0200, Daniel Borkmann wrote:
>>> Given there is roughly a ~5 weeks window at max where this removal could
>>> still be applied in the worst case, could we come up with a fix / proposal
>>> first that moves this into the DMA mapping core? If there is something that
>>> can be agreed upon by all parties, then we could avoid re-adding the 9%
>>> slowdown. :/
>>
>> I'd rather turn it upside down - this abuse of the internals blocks work
>> that has basically just missed the previous window and I'm not going
>> to wait weeks to sort out the API misuse.  But we can add optimizations
>> back later if we find a sane way.
> 
> I'm not super excited about the performance loss, but I do get
> Christoph's frustration about gutting the DMA API making it harder for
> DMA people to get work done. Lets try to solve this properly using
> proper DMA APIs.

Ok, fair enough, please work with DMA folks to get this properly integrated and
restored then. Applied, thanks!
