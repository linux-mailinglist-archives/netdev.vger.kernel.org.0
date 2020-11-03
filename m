Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C612A3DC3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgKCHf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:35:29 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53752 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKCHf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:35:28 -0500
Received: from [192.168.0.114] (unknown [49.207.216.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 681AC20B4905;
        Mon,  2 Nov 2020 23:35:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 681AC20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1604388928;
        bh=ih9ZiV/+m1a4u66NjJRUECF/WudDRLXa9Ud3sqbo1wU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fngvWTf5lX/PQrgJi0VtxZ5dfaIhHlQcoxLhWUSksXKq3J0YjeJMvR0wRt1bNwEbS
         KFSK/hRuuLQ6QGMj0gBvFxSMmNtaXMxfqjv+3wBbAwqC7EQkEkgdbRfhvCBhDoZRy8
         C/8Iwe6LSz3hZwNFTl+S6ezNQRgzo7ftmvUxBP28=
Subject: Re: [PATCH v2 0/3] wireless: convert tasklets to use new
To:     Allen Pais <allen.lkml@gmail.com>, kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20201007103309.363737-1-allen.lkml@gmail.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <c3d71677-a428-f215-2ba8-4dd277a69fb6@linux.microsoft.com>
Date:   Tue, 3 Nov 2020 13:05:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201007103309.363737-1-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 
> This series converts the remaining drivers to use new
> tasklet_setup() API.
> 
> The patches are based on wireless-drivers-next (c2568c8c9e63)

  Is this series queue? I haven't seen any email. This is the last
series as part of the tasklet conversion effort.

Thanks.

> 
> v2:
>    Split mt76 and mt7601u
> 
> Allen Pais (3):
>    wireless: mt76: convert tasklets to use new tasklet_setup() API
>    wireless: mt7601u: convert tasklets to use new tasklet_setup() API
>    ath11k: convert tasklets to use new tasklet_setup() API
> 
>   drivers/net/wireless/ath/ath11k/pci.c              |  7 +++----
>   drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  4 ++--
>   drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  3 +--
>   drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
>   drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  6 +++---
>   drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   | 10 +++++-----
>   drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  7 +++----
>   drivers/net/wireless/mediatek/mt76/usb.c           |  6 +++---
>   drivers/net/wireless/mediatek/mt7601u/dma.c        | 12 ++++++------
>   9 files changed, 27 insertions(+), 30 deletions(-)
> 
