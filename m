Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62BA5F71C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 13:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfGDLLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 07:11:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45314 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfGDLLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 07:11:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so6162578wre.12
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 04:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l8xOwRoeewzebcQAt1yKxsHLrRV9J9YjppTfdC6bYO4=;
        b=AcU/Og0Im9zeCUoAjQfz6t1TPM7Mfh0ysWoMMrnoAxopui+jfwRP+8ITrmS17IrY1C
         KEs0UE42QQXFtM3Plib24n04BsaZx7YpdSdT+lXwkDmW5UXo5AVmjENp8T4Yk5L4W3qL
         ya3qtdkWWGhERgwew7vMxaZiQ0oib0yFn8XnrueuwqH8INdv94RXEj/zk8dU3Gtn4O0A
         6EwHajqBOaWPjJJmtSLrm8PZE5Ma9nIUkyig0AkkUrnFH46TF6oLK4F+36SuPCPJzrid
         vsMqp3WqEkNc7NWqF0JoS9TZcj/Wt9C7JFdlMtv8VS6Ms36Kj4I2IsGthBfqv69AJ3yx
         KAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l8xOwRoeewzebcQAt1yKxsHLrRV9J9YjppTfdC6bYO4=;
        b=kdMslk5d7NlbQ+/X5QiDqwvM1JdBBQjFE4yr4IEybCT61zjACNGGgfoLczn1uRKpJ9
         rFHdBEwjKr5zb6ZhDsD5bN2DanRRI58sGXCeVTG6OOrUYZPaPz3c03+O7kPESVrmfk7B
         3tubnHJxW3sRJzJM5PSq3DlimFvtmdkqVI52k/UhidOStAgfLmi1m4W9/r461eDQH5mM
         Maop3z21hsaG6DDvV9ecXkwYXlyTbCtAKPxYBDUP4R1SdaDK/SdhfIv4t0f6myh8hHNX
         ENgOK6ZpzTFFGoth7MXv4zS7e4L6IpKdeH588jfw2LTuYZindeuqJOA8U3L4ppxtG5gM
         Of/A==
X-Gm-Message-State: APjAAAU5TM6gM5a/DI3fxP6gg+1wbfMotz81tiU+F+/PHyuMV0CcTwZm
        /9PRv6Qe7r8/pZbYoMnvGUbEDQ==
X-Google-Smtp-Source: APXvYqwc3n6Z1DTK4DI0irtOTjnyQp+cY9JrkG89Fk1+0XQ7A/1JudehcvBrF5/bUdDdbNSumzT99A==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr32763692wrn.54.1562238673665;
        Thu, 04 Jul 2019 04:11:13 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id r4sm4942586wrv.34.2019.07.04.04.11.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 04:11:12 -0700 (PDT)
Date:   Thu, 4 Jul 2019 14:11:09 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190704111109.GA12011@apalos>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon>
 <BN8PR12MB3266BC5322AADFAC49D9BAFAD3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266BC5322AADFAC49D9BAFAD3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 10:13:37AM +0000, Jose Abreu wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> > The page_pool DMA mapping cannot be "kept" when page traveling into the
> > network stack attached to an SKB.  (Ilias and I have a long term plan[1]
> > to allow this, but you cannot do it ATM).
> 
> The reason I recycle the page is this previous call to:
> 
> 	skb_copy_to_linear_data()
> 
> So, technically, I'm syncing to CPU the page(s) and then memcpy to a 
> previously allocated SKB ... So it's safe to just recycle the mapping I 
> think.
> 
> Its kind of using bounce buffers and I do see performance gain in this 
> (I think the reason is because my setup uses swiotlb for DMA mapping).

Maybe. Have you tested this on big/small packets?
Can you do a test with 64b/128b and 1024b for example?
The memcpy might be cheap for the small sized packets (and cheaper than the dma
map/unmap)

> 
> Anyway, I'm open to some suggestions on how to improve this ...
> 
> > Also remember that the page_pool requires you driver to do the DMA-sync
> > operation.  I see a dma_sync_single_for_cpu(), but I didn't see a
> > dma_sync_single_for_device() (well, I noticed one getting removed).
> > (For some HW Ilias tells me that the dma_sync_single_for_device can be
> > elided, so maybe this can still be correct for you).
> 
> My HW just needs descriptors refilled which are in different coherent 
> region so I don't see any reason for dma_sync_single_for_device() ...
I am abit overloaded at the moment. I'll try to have a look at this and get back
to you

Cheers
/Ilias
