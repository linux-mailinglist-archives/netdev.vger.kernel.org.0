Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7295D3FA808
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 02:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhH2AKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 20:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhH2AKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 20:10:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBD1C061756;
        Sat, 28 Aug 2021 17:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=EaN8NsPelxHrvU9ofAOrjRtk0WsMGCySofzS1ta0LL8=; b=rFQSsr9R9EiuFOn4iq4RDbszO7
        fyAMZk8WbJPtAI5zR8nO3a/p5REX476tl9mC/UH8580CwSQfLkMSlgN2ofiTAfvpvHYLvVGLgNj3q
        fUyByVWWnobgsvT/b1BFUsbw30727eWMcT0TBqpNfsEmY+hd40IqiJZDZfeqD9qtMgTgHDb69Y40j
        PrDWB2Eckw+rxIiKParyR5aKp5+phAvcgnQkT15EfsMUnEEuiu1iKO5MC0TqLhWbs5x1BV3m7nn3/
        h41FF2qzwS1rRMm9wVruv/GESqJVJBuSuenrOFDSvNiell4ywVuotbiUnt+wQTXcL7mHgmGGlSwUu
        24a09n6Q==;
Received: from [2602:306:c5a2:a380:1dfb:b2e0:5ace:2d5]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mK8OU-00DzjX-2F; Sun, 29 Aug 2021 00:09:50 +0000
Subject: Re: [PATCH] net: spider_net: switch from 'pci_' to 'dma_' API
From:   Geoff Levand <geoff@infradead.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kou.ishizaki@toshiba.co.jp, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
 <4f3113d1-b76e-a085-df2d-fd97d4b45faf@infradead.org>
Message-ID: <2b1a0085-de94-dc41-9b9d-3ba1fcdbb6f4@infradead.org>
Date:   Sat, 28 Aug 2021 17:09:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4f3113d1-b76e-a085-df2d-fd97d4b45faf@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On 8/27/21 6:34 PM, Geoff Levand wrote:
> On 8/27/21 12:56 PM, Christophe JAILLET wrote:
>> It has *not* been compile tested because I don't have the needed
>> configuration or cross-compiler.
> 
> The powerpc ppc64_defconfig has CONFIG_SPIDER_NET set. My
> tdd-builder Docker image has the needed gcc-powerpc-linux-gnu
> cross compiler to build ppc64_defconfig:
> 
>   https://hub.docker.com/r/glevand/tdd-builder

Just to follow up, I applied your patch to v5.14-rc7 and built
ppc64_defconfig. No warnings or errors were seen.

Thanks for your contribution.

Acked-by: Geoff Levand <geoff@infradead.org>

