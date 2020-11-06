Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F982A8BB4
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbgKFA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbgKFA5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:57:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C7520759;
        Fri,  6 Nov 2020 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604624230;
        bh=PB7SA2wWt19NGMrXUv1KhHg/G8S+ggzPiON/0p7IfDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wYNDtTZbgL70VZdCTzsBQ6VsBjaya3WIvOUjTw2rpFB6h4C9cvwcp/0BogRIgrgra
         BTGfcRpJR8BKV7gJ0zQvQpYXwT2p88ZhY7f/9qdXced5vTLwPVWLWu/ssWz5Jhtu4l
         q/um3O8Sh9zdeMb3pozaMaiZaK7pYFBG28uIIOTQ=
Date:   Thu, 5 Nov 2020 16:57:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bbhatt@codeaurora.org,
        willemdebruijn.kernel@gmail.com, jhugo@codeaurora.org,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Subject: Re: [PATCH v10 1/2] bus: mhi: Add mhi_queue_is_full function
Message-ID: <20201105165708.31d24782@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
References: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 18:23:53 +0100 Loic Poulain wrote:
> This function can be used by client driver to determine whether it's
> possible to queue new elements in a channel ring.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied.
