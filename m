Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B780154536
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBFNpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgBFNpf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 08:45:35 -0500
Received: from localhost (unknown [122.178.198.215])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC66521775;
        Thu,  6 Feb 2020 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580996734;
        bh=21B1htHlSXP+EtSU9SC4zC69SofeXvGLzj2qSGbg6VA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tlwz94dY/S6h58vaVEkN+y235uq3TjML3gxqp6SJtVBoSAknq3GnQuw3EEuvrPuzl
         k0/FZIoXE1a7Dgl0VfvfAcX5sgo0UhNS4+BMYhgUS6os2SJyoE4k9CM4ctBh+dERXF
         VvzrVuMB841uk/o/zxU59YNS3srmNGn9Yoj/kXmA=
Date:   Thu, 6 Feb 2020 19:15:30 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     zhengdejin5@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: fix a possible endless loop
Message-ID: <20200206134530.GP2618@vkoul-mobl>
References: <20200206132147.22874-1-zhengdejin5@gmail.com>
 <20200206133554.GO2618@vkoul-mobl>
 <20200206.143753.1516354381077365451.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206.143753.1516354381077365451.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06-02-20, 14:37, David Miller wrote:
> > 
> > Also, I think this should be CCed stable
> 
> Networking patches do not CC: stable, I queued them up myself manually.
> 
> Please read the netdev FAQ under Documentation/ for details.

Oops sorry I forgot about that part.

Thanks
-- 
~Vinod
