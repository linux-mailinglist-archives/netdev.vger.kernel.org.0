Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9314B2F5963
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhANDdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbhANDdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:33:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F012823359;
        Thu, 14 Jan 2021 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595183;
        bh=we/Fg9MEAlamR2ufuCkyUiKQ3FgaGPX58CNSKgCaH7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uw3OxiJG1t+jUWDa6xkM9dcRNvU0l9/ZUrrHHnwOVzwELp5Na63Xg4uA/cYbEHajZ
         l3Ip8Migw1K4bhFWfq7rF8ctSzW9jeIjtSBCUg8xuMQfefuFhSspMhbVsxLnvk/X7v
         RWrgdeFGZWbga74L2/fXZlfamM6F1SDb6BRZz/00IzXZ64WN7YlHtCGZWZrLGxUXEm
         11P0CQcIe4ODFK7Oi/5l6CBkftfoMkPK3k4Wv/OCN2uBEchgFR4NljuBPU24U/gGAs
         5Lwqu4L9I0INtJky5DgURQAcrY5EdOf9lN5zxjMzs/40INqHJzc0VBxlLyTOFRHGrC
         qnwPUn9axI5cg==
Date:   Wed, 13 Jan 2021 19:33:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>,
        manivannan.sadhasivam@linaro.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH net-next 1/3] bus: mhi: core: Add helper API to return
 number of free TREs
Message-ID: <20210113193301.2a9b7ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:07:40 +0100 Loic Poulain wrote:
> From: Hemant Kumar <hemantk@codeaurora.org>
> 
> Introduce mhi_get_free_desc_count() API to return number
> of TREs available to queue buffer. MHI clients can use this
> API to know before hand if ring is full without calling queue
> API.
> 
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Can we apply these to net-next or does it need to be on a stable branch
that will also get pulled into mhi-next?
