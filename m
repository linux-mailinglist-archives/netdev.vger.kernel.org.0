Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAB75F7A1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfGDMEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:04:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40169 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfGDMEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:04:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so5861761wmj.5
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 05:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=amr/MLN9cI5Ec8HWgSABL9rUXzQlcR+yO98qbl8sqQQ=;
        b=reCYBa/HDiyEd6CU/NQNeECZ0TGiSTj8f8SEw4WFvGQo59bH5871qj/oJ9PYzgM4GP
         zA95ZBUcbKacoYmCK12EVNylEKYfkwbrorMv9FA5F0SvbjQHxdo8QpW1OmqvBTDGYNak
         zkF4lXTMeJnHNJRfmUlhCwG7yFK7GzrKEx2gRXlMS6sgu712/cFTieIviLBBe/2wP+x6
         oBfEeXDD9MTQs5r9JnNseOOa9Q4u0PoebNFFoi4vfhDYpljevyDegYuh1dD1kWAYAmsL
         8tQjrV6Klmf/TwqngR513k5F/mMIIr1dUgGU4aw0KWGD5w7OQcLph+aEc3Tt0DgWYslh
         mZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=amr/MLN9cI5Ec8HWgSABL9rUXzQlcR+yO98qbl8sqQQ=;
        b=Cn6oVQisGP4ScXlrS2VFjN4sjQcMNg8YU694tEgsbowS1ur8pOA2j4iaOlEAWAya+H
         NX7X2w6AIN/fvk6pk74LiVDfKsv8ESP55lXkFjAJ3yAkobLpre7FSG3HgefQ2YtEheNM
         GhFPEltJcAI5+QPVQRNhsQUOe0ZdpykT05gV0MzDMAjNINfxhu3ZIF03WuTXpYy/fu3g
         w6pgn9weeYIpwKJjI9a9u7r+wx8CKT3gmx0piAtIRtluUnRCaGRKb2OVzopG+CywM+Mz
         upNqqqHS+2MYJoXctfIx0BcO3Niu56HZvA6o/mswWr7W/iO2g3mDNFZZFtlRIdazwSsO
         a6Bw==
X-Gm-Message-State: APjAAAWHiGWA5KbKpnagUs5O1P+UEA2gI00iMLMs6jtVJADVOE8vCbXE
        uSmvCSNSD4cIuC51O8fBt7yKdw==
X-Google-Smtp-Source: APXvYqyT6y+9T+/VeJfNymSjJVbJMJkxGcTutUA49l/YNxwHZmt9KNlRem6wZWge7DDaiLLPkOPVCA==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr12611948wmj.65.1562241885365;
        Thu, 04 Jul 2019 05:04:45 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id z9sm7475960wrs.14.2019.07.04.05.04.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:04:44 -0700 (PDT)
Date:   Thu, 4 Jul 2019 15:04:41 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
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
Message-ID: <20190704120441.GA6866@apalos>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon>
 <BN8PR12MB3266BC5322AADFAC49D9BAFAD3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190704135414.0dd5df76@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704135414.0dd5df76@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

> On Thu, 4 Jul 2019 10:13:37 +0000
> Jose Abreu <Jose.Abreu@synopsys.com> wrote:
> > > The page_pool DMA mapping cannot be "kept" when page traveling into the
> > > network stack attached to an SKB.  (Ilias and I have a long term plan[1]
> > > to allow this, but you cannot do it ATM).  
> > 
> > The reason I recycle the page is this previous call to:
> > 
> > 	skb_copy_to_linear_data()
> > 
> > So, technically, I'm syncing to CPU the page(s) and then memcpy to a 
> > previously allocated SKB ... So it's safe to just recycle the mapping I 
> > think.
> 
> I didn't notice the skb_copy_to_linear_data(), will copy the entire
> frame, thus leaving the page unused and avail for recycle.

Yea this is essentially a 'copybreak' without the byte limitation that other
drivers usually impose (remember mvneta was doing this for all packets < 256b)

That's why i was concerned on what will happen on > 1000b frames and what the
memory pressure is going to be. 
The trade off here is copying vs mapping/unmapping.

> 
> Then it looks like you are doing the correct thing.  I will appreciate
> if you could add a comment above the call like:
> 
>    /* Data payload copied into SKB, page ready for recycle */
>    page_pool_recycle_direct(rx_q->page_pool, buf->page);
> 
> 
> > Its kind of using bounce buffers and I do see performance gain in this 
> > (I think the reason is because my setup uses swiotlb for DMA mapping).
> > 
> > Anyway, I'm open to some suggestions on how to improve this ...
> 
> I was surprised to see page_pool being used outside the surrounding XDP
> APIs (included/net/xdp.h).  For you use-case, where you "just" use
> page_pool as a driver-local fast recycle-allocator for RX-ring that
> keeps pages DMA mapped, it does make a lot of sense.  It simplifies the
> driver a fair amount:
> 
>   3 files changed, 63 insertions(+), 144 deletions(-)
> 
> Thanks for demonstrating a use-case for page_pool besides XDP, and for
> simplifying a driver with this.

Same here thanks Jose,

> 
> 
> > > Also remember that the page_pool requires you driver to do the
> > > DMA-sync operation.  I see a dma_sync_single_for_cpu(), but I
> > > didn't see a dma_sync_single_for_device() (well, I noticed one
> > > getting removed). (For some HW Ilias tells me that the
> > > dma_sync_single_for_device can be elided, so maybe this can still
> > > be correct for you).  
> > 
> > My HW just needs descriptors refilled which are in different coherent 
> > region so I don't see any reason for dma_sync_single_for_device() ...
> 
> For you use-case, given you are copying out the data, and not writing
> into it, then I don't think you need to do sync for device (before
> giving the device the page again for another RX-ring cycle).
> 
> The way I understand the danger: if writing to the DMA memory region,
> and not doing the DMA-sync for-device, then the HW/coherency-system can
> write-back the memory later.  Which creates a race with the DMA-device,
> if it is receiving a packet and is doing a write into same DMA memory
> region.  Someone correct me if I misunderstood this...

Similar understanding here

Cheers
/Ilias
