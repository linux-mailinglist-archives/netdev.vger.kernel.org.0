Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5F30C67B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhBBQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236848AbhBBQs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:48:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A44C864F05;
        Tue,  2 Feb 2021 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284468;
        bh=yR9QtEnmzQiWPaCImO44YhTed9Xwix1VuCOPtz7yPI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UE1zupJK7XM53twXvIZmO8NoqJPsvOdzgw3/U8L26GV7RYNqW8Y7TjKChwBoV4ILH
         ZXZGk07VYLXvfF4Kgxp33rfptotx/XU4sFZnwcPUPa/lC7I8b9srA/Hn1Cx3Ma0sbS
         NWZUQOh/A0QehH3uKprYGUQ4pkOCT1C3pb1knYG+QY1ewu8vOs2dKlw0cM3qUmY19R
         gW/0Ih462Qd6pgwygdG9uwtxjl7it5UO0mlXWArYB3uRPY5v4MBCicXArjiCZqETO4
         hNYzIYkkmdRHBhTAhpGpNgQGkPTbgSIr8P4+RhG5sG+yA19CezQdSux6Wg3agkWXBM
         SBk9i0L/2SVfg==
Date:   Tue, 2 Feb 2021 08:47:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@ieee.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: pass correct dma_handle to
 dma_free_coherent()
Message-ID: <20210202084746.28c12d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cc689bd3-90d8-5ad5-661b-e2c3b76c7341@ieee.org>
References: <YBjpTU2oejkNIULT@mwanda>
        <cc689bd3-90d8-5ad5-661b-e2c3b76c7341@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 05:48:11 -0600 Alex Elder wrote:
> On 2/1/21 11:55 PM, Dan Carpenter wrote:
> > The "ring->addr = addr;" assignment is done a few lines later so we
> > can't use "ring->addr" yet.  The correct dma_handle is "addr".
> > 
> > Fixes: 650d1603825d ("soc: qcom: ipa: the generic software interface")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>  
> 
> Yikes.  Thank you for the fix.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>

Applied, thanks!
