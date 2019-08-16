Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CE990B25
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfHPWm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:42:56 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:49138 "EHLO
        mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbfHPWm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:42:56 -0400
Received: from mx1.fh-giessen.de ([212.201.18.40])
        by mout2.fh-giessen.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hykvq-0007N2-AQ; Sat, 17 Aug 2019 00:42:50 +0200
Received: from mailgate-2.its.fh-giessen.de ([212.201.18.14])
        by mx1.fh-giessen.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hykvq-008QGk-5h; Sat, 17 Aug 2019 00:42:50 +0200
Received: from p2e561b42.dip0.t-ipconnect.de ([46.86.27.66] helo=[192.168.1.24])
        by mailgate-2.its.fh-giessen.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hykvp-000Exn-SB; Sat, 17 Aug 2019 00:42:49 +0200
Subject: Re: regression in ath10k dma allocation
To:     Nicolin Chen <nicoleotsuka@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kvalo@codeaurora.org,
        davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
 <20190816164301.GA3629@lst.de>
 <af96ea6a-2b17-9b66-7aba-b7dae5bcbba5@mni.thm.de>
 <20190816222506.GA24413@Asurada-Nvidia.nvidia.com>
From:   Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Message-ID: <3f7475e3-e27b-aca7-c21e-71cac6cafc1c@mni.thm.de>
Date:   Sat, 17 Aug 2019 00:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:70.0) Gecko/20100101
 Thunderbird/70.0a1
MIME-Version: 1.0
In-Reply-To: <20190816222506.GA24413@Asurada-Nvidia.nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolin,

On 17.08.19 00:25, Nicolin Chen wrote:
> Hi Tobias
>
> On Fri, Aug 16, 2019 at 10:16:45PM +0200, Tobias Klausmann wrote:
>>> do you have CONFIG_DMA_CMA set in your config?  If not please make sure
>>> you have this commit in your testing tree, and if the problem still
>>> persists it would be a little odd and we'd have to dig deeper:
>>>
>>> commit dd3dcede9fa0a0b661ac1f24843f4a1b1317fdb6
>>> Author: Nicolin Chen <nicoleotsuka@gmail.com>
>>> Date:   Wed May 29 17:54:25 2019 -0700
>>>
>>>       dma-contiguous: fix !CONFIG_DMA_CMA version of dma_{alloc, free}_contiguous()
>> yes CONFIG_DMA_CMA is set (=y, see attached config), the commit you mention
>> above is included, if you have any hints how to go forward, please let me
>> know!
> For CONFIG_DMA_CMA=y, by judging the log with error code -12, I
> feel this one should work for you. Would you please check if it
> is included or try it out otherwise?
>
> dma-contiguous: do not overwrite align in dma_alloc_contiguous()
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c6622a425acd1d2f3a443cd39b490a8777b622d7


Thanks for the hint, yet the commit is included and does not fix the 
problem!

Greetings,

Tobias

