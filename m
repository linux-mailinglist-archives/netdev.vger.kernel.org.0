Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E1320ED1F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgF3FHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:07:17 -0400
Received: from verein.lst.de ([213.95.11.211]:34411 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgF3FHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 01:07:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 04C636736F; Tue, 30 Jun 2020 07:07:13 +0200 (CEST)
Date:   Tue, 30 Jun 2020 07:07:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        maximmi@mellanox.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
Message-ID: <20200630050712.GA26840@lst.de>
References: <20200626134358.90122-1-bjorn.topel@gmail.com> <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net> <20200627070406.GB11854@lst.de> <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com> <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net> <81aec200-c1a0-6d57-e3b6-26dad30790b8@intel.com> <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 05:18:38PM +0200, Daniel Borkmann wrote:
> On 6/29/20 5:10 PM, Björn Töpel wrote:
>> On 2020-06-29 15:52, Daniel Borkmann wrote:
>>>
>>> Ok, fair enough, please work with DMA folks to get this properly integrated and
>>> restored then. Applied, thanks!
>>
>> Daniel, you were too quick! Please revert this one; Christoph just submitted a 4-patch-series that addresses both the DMA API, and the perf regression!
>
> Nice, tossed from bpf tree then! (Looks like it didn't land on the bpf list yet,
> but seems other mails are currently stuck as well on vger. I presume it will be
> routed to Linus via Christoph?)

I send the patches to the bpf list, did you get them now that vger
is unclogged?  Thinking about it the best route might be through
bpf/net, so if that works for you please pick it up.
