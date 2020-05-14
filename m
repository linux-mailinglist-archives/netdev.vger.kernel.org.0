Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6751D3E3B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgENT6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:58:16 -0400
Received: from verein.lst.de ([213.95.11.211]:53604 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgENT6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 15:58:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5710E68BEB; Thu, 14 May 2020 21:58:13 +0200 (CEST)
Date:   Thu, 14 May 2020 21:58:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christoph Hellwig <hch@lst.de>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, john.fastabend@gmail.com, yhs@fb.com
Subject: Re: [PATCH bpf 0/3] Restrict bpf_probe_read{,str}() and
 bpf_trace_printk()'s %s
Message-ID: <20200514195813.GA14720@lst.de>
References: <20200514161607.9212-1-daniel@iogearbox.net> <20200514165802.GA3059@lst.de> <cb0749ab-e37b-6fe4-5830-a40fb4fca995@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0749ab-e37b-6fe4-5830-a40fb4fca995@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 09:54:06PM +0200, Daniel Borkmann wrote:
> On 5/14/20 6:58 PM, Christoph Hellwig wrote:
>> On Thu, May 14, 2020 at 06:16:04PM +0200, Daniel Borkmann wrote:
>>> Small set of fixes in order to restrict BPF helpers for tracing which are
>>> broken on archs with overlapping address ranges as per discussion in [0].
>>> I've targetted this for -bpf tree so they can be routed as fixes. Thanks!
>>
>> Does that mean you are targeting them for 5.7?
>
> Yes, it would make most sense to me based on the discussion we had in the
> other thread. If there is concern wrt latency we could route these to DaveM's
> net tree in a timely manner (e.g. still tonight or so).

I don't think we should rush this too much.  I just want to make sure
it either goes into 5.7 or that we have a coordinated tree that I can
base the maccess series on.
