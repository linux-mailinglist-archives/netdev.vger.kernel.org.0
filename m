Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5A343C01
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 09:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVIoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 04:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhCVIo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 04:44:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB5AC061574;
        Mon, 22 Mar 2021 01:44:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so18201636edu.10;
        Mon, 22 Mar 2021 01:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rnkMpGsCf/4BnBYAYXXRx86itQPydiaEV5BqDF9/qw=;
        b=PSp+DW8HY4S5LbW9uyOCmE/4pZe+0jMXvcLhKhdY5ccVq9Bjkhr1tm+fEbhH+iFiPm
         PpRvcUKmNAPztWu1lkTxTNT9einv/4U3b9wmVA5/lPvaRQVeKrUsm2DdvQZIDW1qgdax
         ZgCNQzHhoS55dWOIb+lqnq4cVzcGZrlRgjxzFhY6mWlp6UVcBiWFTDaNVR9Td2/vm3KU
         hnpWewO9lx2c9Uj+LvB8qJa7KzxAAXOs4tFO83cACUykDW0mcFM23T1aTeJQnzarSg24
         VgAJpVN/rilBtJjVcJGiVAMzytegbyBRIjUTTCl4X5pt2E1aqIOhY+VQPQiJ83E8Owf3
         I8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rnkMpGsCf/4BnBYAYXXRx86itQPydiaEV5BqDF9/qw=;
        b=HZC+O7z7pcVuQbjGVrqbwzBwR9aR37eynb7oS58kCFzn4VbiQ6qn6GP+SgQGE+Ml5s
         o2XEbJkEnmAjjZXSPxmnRt/1OBjKFcX4sDJt0b/BgIn49TXy9BE2a4pDUeWn9zS9b0+a
         DZmOQ5HxbMDIngsEb5BnlmaQokVmE7h0r7iElT09Dcb5PiD99p8Y6BVZKvZWuogBnR/j
         FAX3FApDYEWX19959Zlc2AZDt1JzXIzgERbjIhH7Iu1BpSO7tWvq+51cJITlGlxnwHTu
         LrPoeIHFwRrvnhAOKohjS5Cchrzv24pxK4F6npd+5R2slRwq1BRiQCPopmoe2bpurCY8
         B+lA==
X-Gm-Message-State: AOAM533N00YNQl/42UUq9R/BFmyAbCfFXp5XXswmXylTeP4uGXrOsOoX
        Rp0RVNRocsz1w1+xU0r3kYE=
X-Google-Smtp-Source: ABdhPJz41xCpO0VkuEmg6Jb1VNkaQeMfiyhoRJqY33tLy16EFE29vissNcZ5Ec4C8iIUDArvay0YaQ==
X-Received: by 2002:a05:6402:105a:: with SMTP id e26mr24256372edu.164.1616402664114;
        Mon, 22 Mar 2021 01:44:24 -0700 (PDT)
Received: from BV030612LT ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id hd8sm9111614ejc.92.2021.03.22.01.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 01:44:23 -0700 (PDT)
Date:   Mon, 22 Mar 2021 10:44:20 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210322084420.GA1503756@BV030612LT>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
 <17876c6e-4688-59e6-216f-445f91a8b884@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17876c6e-4688-59e6-216f-445f91a8b884@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, Mar 21, 2021 at 08:30:07PM -0700, Florian Fainelli wrote:
> Hi Christian,
> 
> On 3/21/2021 4:29 PM, Cristian Ciocaltea wrote:
> > Add new driver for the Ethernet MAC used on the Actions Semi Owl
> > family of SoCs.
> > 
> > Currently this has been tested only on the Actions Semi S500 SoC
> > variant.
> > 
> > Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> 
> [snip]
> 
> Do you know the story behind this Ethernet controller? 

I just happened to get a board based on the S500 SoC, so I took this
opportunity to help improving the mainline kernel support, but other
than that I do not really know much about the hardware history.

> The various
> receive/transmit descriptor definitions are 99% those defined in
> drivers/net/ethernet/stmmicro/stmmac/descs.h for the normal descriptor.

That's an interesting observation. I could only assume the vendor did
not want to reinvent the wheel here, but I cannot say if this is a
common design scheme or is something specific to STMicroelectronics
only.

> The register layout of the MAC looks completely different from a
> dwmac100 or dwmac1000 however.

Most probably this is Actions specific.. 

> -- 
> Florian
