Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D7220F61E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbgF3Nri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:47:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:36798 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgF3Nri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:47:38 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGbZ-00070l-Fh; Tue, 30 Jun 2020 15:47:21 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGbZ-0003zd-6p; Tue, 30 Jun 2020 15:47:21 +0200
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
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
 <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
 <20200630050712.GA26840@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7bd1f3ad-f1c7-6f8c-ef14-ec450050edf2@iogearbox.net>
Date:   Tue, 30 Jun 2020 15:47:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630050712.GA26840@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 7:07 AM, Christoph Hellwig wrote:
> On Mon, Jun 29, 2020 at 05:18:38PM +0200, Daniel Borkmann wrote:
>> On 6/29/20 5:10 PM, Björn Töpel wrote:
>>> On 2020-06-29 15:52, Daniel Borkmann wrote:
>>>>
>>>> Ok, fair enough, please work with DMA folks to get this properly integrated and
>>>> restored then. Applied, thanks!
>>>
>>> Daniel, you were too quick! Please revert this one; Christoph just submitted a 4-patch-series that addresses both the DMA API, and the perf regression!
>>
>> Nice, tossed from bpf tree then! (Looks like it didn't land on the bpf list yet,
>> but seems other mails are currently stuck as well on vger. I presume it will be
>> routed to Linus via Christoph?)
> 
> I send the patches to the bpf list, did you get them now that vger
> is unclogged?  Thinking about it the best route might be through
> bpf/net, so if that works for you please pick it up.

Yeah, that's fine, I just applied your series to the bpf tree. Thanks!
