Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC3D2CF704
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgLDWme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgLDWmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:42:33 -0500
Date:   Fri, 4 Dec 2020 14:41:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607121713;
        bh=cXraMIllQ0BxspbkYWQ2t55jDSNDGY/+W/56CuZEGWg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=fxudoXZkihYKJ0KDeAbUltqKepcsRddmFJCF4RVw4tevwN8OyPHuLrcOHU2CZeQzt
         IOXBVcwYjRGgGVH2Il2E04fuAuVuSL7EvPFpv89ws08IkcWu2LMWoIz4QWK5Kg50Ei
         lPbTzJqHBXw0M7xLFk9HVbztWsbxI6KohAmAYNURRieUbGOorRizFtShiRITADwjom
         KQxnODNngvHYCDC9Y0nzdJWD2d/H0Dc4zmTzW6z/lYWCwvyCnuIgp76zdPYIs65Q63
         6AIt5jEgl7xp3PW5Joihg/6hkeW5NPsiVO6OVnA/eTLd0O5qrAmym0cTq7WE7W3I6U
         60PB1+O6yRMiA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        swboyd@chromium.org, sujitka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: ipa: pass the correct size when freeing
 DMA memory
Message-ID: <20201204144152.70274859@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <X8l0kGv2uvo4ueOn@builder.lan>
References: <20201203215106.17450-1-elder@linaro.org>
        <X8l0kGv2uvo4ueOn@builder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 17:28:16 -0600 Bjorn Andersson wrote:
> > When the coherent memory is freed in gsi_trans_pool_exit_dma(), we
> > are mistakenly passing the size of a single element in the pool
> > rather than the actual allocated size.  Fix this bug.
> > 
> > Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
> > Reported-by: Stephen Boyd <swboyd@chromium.org>
> > Tested-by: Sujit Kautkar <sujitka@chromium.org>
> > Signed-off-by: Alex Elder <elder@linaro.org>  
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Applied, thanks!
