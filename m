Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F70D21830F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGHJBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:01:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:36960 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGHJBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:01:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jt5xQ-0002sR-Fr; Wed, 08 Jul 2020 11:01:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jt5xQ-000Xy5-8p; Wed, 08 Jul 2020 11:01:36 +0200
Subject: Re: add an API to check if a streamming mapping needs sync calls
To:     Christoph Hellwig <hch@lst.de>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629130359.2690853-1-hch@lst.de>
 <b97104e1-433c-8e35-59c6-b4dad047464c@intel.com>
 <20200708074418.GA6815@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ce7dc444-534e-636b-81d8-dbad249ad6aa@iogearbox.net>
Date:   Wed, 8 Jul 2020 11:01:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200708074418.GA6815@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25866/Tue Jul  7 15:47:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 9:44 AM, Christoph Hellwig wrote:
> On Mon, Jun 29, 2020 at 03:39:01PM +0200, Björn Töpel wrote:
>> On 2020-06-29 15:03, Christoph Hellwig wrote:
>>> Hi all,
>>>
>>> this series lifts the somewhat hacky checks in the XSK code if a DMA
>>> streaming mapping needs dma_sync_single_for_{device,cpu} calls to the
>>> DMA API.
>>>
>>
>> Thanks a lot for working on, and fixing this, Christoph!
>>
>> I took the series for a spin, and there are (obviously) no performance
>> regressions.
>>
>> Would the patches go through the net/bpf trees or somewhere else?
> 
> Where did this end up?  I still don't see it in Linus' tree and this
> is getting urgent now.

It was merged into bpf tree and we sent the PR to DaveM which was merged into
net tree around a week ago [0]; I assume the PR for net might go to Linus soon
this week.

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=e708e2bd55c921f5bb554fa5837d132a878951cf
