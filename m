Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB975F8DB
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfGDNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:06:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40338 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfGDNGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:06:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so6081668wmj.5
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 06:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C0G7rBJyorAv/Go9XW+5KlxgxsrwAo4Lw8h4E0AK/9g=;
        b=MhGHCbNxmBGEX9gNxaF9U5CCJT+qFuz/qiepbdulPX4tk3cpmHk4Nr1cvq+wO4v/6O
         +ybPFIWjxCRzO1VplawtIKym3JIWT6EL6KCC/kXweTg1xEDf6xWNuutL6xnTVP49ECPa
         2IkTuBaIC5U5cDvAdCksqgV+emWw2anAu4XaajfBHQH+ALVYgz1c6h+ms+nDnaWgQOva
         rqS7dM0i2zAeunc7L6TMtRFiWjbF3j2AT0T4kRNj/OsD5XYRsUZqdy268I4EZYTBHRYU
         uIRnNbFdGgRz8D3Ch5iqC9sB+WrvfT8Jn9Q1LiX+atRzygQnXvRv4EHdOsgMgxoxXFdA
         tX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C0G7rBJyorAv/Go9XW+5KlxgxsrwAo4Lw8h4E0AK/9g=;
        b=RtLoFSAP2D+NJ1BuVUV67hOgNE1px2raHZUq4GEf1pCw0RB+bbhHqAWBF9NKZoP+xf
         Ea0O9CKf1D8yX4rfJw0nJXnNUdVBhfdUN/ZcPK8qVfGjx/pru7cqbsRNrQL1TypKHtpp
         TlRm2tICqZcNHmDcvfKJ7auvmtBInqmozCiK8rsyVnq4CTm6RLYwe+0+1LrCNMTxlmA2
         FNb9Ro8FrOrKjtLTtgQtLrpGSbQMW7KukPkglEZsIQVzbyz9G6171FtII1fIguz20K+C
         0mdTS+QuD8vZ+uZyX/52KjQjRBkSFOQ7HUi0sGJhq1eAhAq0VqjEeqTNaWyLeOuYZxxC
         32+w==
X-Gm-Message-State: APjAAAWMyEyaG+QKYnW7hazByR3fIpBxq5xCh2bOSA7Q6mT4KYYl8Q0U
        tkjI7YA0VIIe2AyNKNw+A/3vfA==
X-Google-Smtp-Source: APXvYqwpVkbCltdiX25gOjc+VVQOWtlzTko4TXdJA9hHxN3MnWxEKL9t/rTxGIvJpQMJWxILKQIjYA==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr11648016wmc.22.1562245599046;
        Thu, 04 Jul 2019 06:06:39 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id p4sm4889734wrs.35.2019.07.04.06.06.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 06:06:38 -0700 (PDT)
Date:   Thu, 4 Jul 2019 16:06:35 +0300
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
Message-ID: <20190704130635.GA10412@apalos>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon>
 <BN8PR12MB3266BC5322AADFAC49D9BAFAD3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190704135414.0dd5df76@carbon>
 <20190704120441.GA6866@apalos>
 <BYAPR12MB3269D4FAAC5307A224D60A08D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3269D4FAAC5307A224D60A08D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose, 

> Thank you all for your review comments !
> 
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> 
> > That's why i was concerned on what will happen on > 1000b frames and what the
> > memory pressure is going to be. 
> > The trade off here is copying vs mapping/unmapping.
> 
> Well, the performance numbers I mentioned are for TSO with default MTU 
> (1500) and using iperf3 with zero-copy. Here follows netperf:
> 

Ok i guess this should be fine. Here's why.
You'll allocate an extra memory from page pool API which equals
the number of descriptors * 1 page.
You also allocate SKB's to copy the data and recycle the page pool buffers.
So page_pool won't add any significant memory pressure since we expect *all*
it's buffers to be recycled. 
The SKBs are allocated anyway in the current driver so bottom line you trade off
some memory (the page_pool buffers) + a memcpy per packet and skip the dma
map/unmap which is the bottleneck in your hardware. 
I think it's fine

Cheers
/Ilias
