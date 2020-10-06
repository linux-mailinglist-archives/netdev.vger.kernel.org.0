Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F41F2848D4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgJFIxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:53:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:57228 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFIxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:53:40 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPiiu-0008NA-2X; Tue, 06 Oct 2020 10:53:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPiit-0000Io-S3; Tue, 06 Oct 2020 10:53:27 +0200
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Hellwig <hch@lst.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <20201006145847.14093e47@canb.auug.org.au>
 <20201006051301.GA5917@lst.de> <20201006164124.1dfa2543@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <173e6f80-2211-a614-2953-0f3df35491a9@iogearbox.net>
Date:   Tue, 6 Oct 2020 10:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201006164124.1dfa2543@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25948/Mon Oct  5 16:02:22 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 7:41 AM, Stephen Rothwell wrote:
> On Tue, 6 Oct 2020 07:13:01 +0200 Christoph Hellwig <hch@lst.de> wrote:
>>
>> On Tue, Oct 06, 2020 at 02:58:47PM +1100, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> After merging the net-next tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>
>> It actually doesn't need that or the two other internal headers.
>> Bjoern has a fixed, and it was supposed to be queued up according to
>> patchwork.
> 
> Yeah, it is in the bpf-next tree but not merged into the net-next tree
> yet.

Yep, applied yesterday. Given a3cf77774abf ("dma-mapping: merge <linux/dma-noncoherent.h>
into <linux/dma-map-ops.h>") is in dma-mapping tree and not yet affecting bpf-next
nor net-next, we were planning to ship bpf-next at the usual cadence this week, so it'll
be in net-next end of week for sure. (If there is urgent reason to have it in net-next
today, please let us know of course.)

Thanks,
Daniel
