Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A439313C52
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhBHSFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbhBHSBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:01:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43B0C06178C
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=MnHx+6OqNYGrQaMqs/3p4P8jUMaYpTZeoSWmjdztnUo=; b=d0HmsUj97tcOhSDVZs3CCWv/SK
        lDyMaf8pnGdUjScqbgkGW0xOCPY1ihltD2rvCuOAQTjcT6dL+j7nPH3puxpaYod4LdbDEhwWNybsW
        83VW6nY9SyhQoiQHaUVZDZsx5EXgMsL/zmFq8THxUkGLmmqQfyEAureArvOajdqQNrWbeWZ0eGp0T
        nG2TiDR3EDpnaN27BiF3WflbeBudMMTXjqLEJO6Moi0dPgtgSODM2lrVFq88aBAt0IDqUz4ZMdvG7
        wxzVEcNhRbo89AEaS9asquP9U7wGOhJIrgYz3RYj2Qt2m6/Tv7M0Rucdlnz6JyQsDkYL14Vths6XI
        YaVFtfBg==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9AqC-0007xm-QX; Mon, 08 Feb 2021 18:00:53 +0000
Subject: Re: [PATCH 4/4] batman-adv: Fix names for kernel-doc blocks
To:     Simon Wunderlich <sw@simonwunderlich.de>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
References: <20210208165938.13262-1-sw@simonwunderlich.de>
 <20210208165938.13262-5-sw@simonwunderlich.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <44df86a7-e7a9-246a-e941-a7ec6f4c8774@infradead.org>
Date:   Mon, 8 Feb 2021 10:00:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208165938.13262-5-sw@simonwunderlich.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 8:59 AM, Simon Wunderlich wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> kernel-doc can only correctly identify the documented function or struct
> when the name in the first kernel-doc line references it. But some of the
> kernel-doc blocks referenced a different function/struct then it actually
> documented.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  net/batman-adv/distributed-arp-table.c | 2 +-
>  net/batman-adv/multicast.c             | 2 +-
>  net/batman-adv/netlink.c               | 4 ++--
>  net/batman-adv/tp_meter.c              | 2 +-
>  net/batman-adv/types.h                 | 3 ++-
>  5 files changed, 7 insertions(+), 6 deletions(-)


-- 
~Randy

