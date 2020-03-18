Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E24189E35
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCROpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgCROpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 10:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF5C320714;
        Wed, 18 Mar 2020 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584542751;
        bh=ZQkQoIgg/xqhZVGUaTIFz/2fg+YFJ3FuYTecjDyDUso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfEKCu4CPRb2sAstSeiCqvxyvbWIMZh0wfec5kMJHltA0kmN4BmbkqjB3rSh9boTP
         Im97KyzEF9niiA0VOxKg96tuq5mKiw0EKNRpt5P0lrV7lqhwVC8Cs3tyNkysxDWADJ
         hzcqndB4g8l7LBqj8j//VRUdMaWN/k3y/dex250s=
Date:   Wed, 18 Mar 2020 15:42:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     arnd@arndb.de, smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 14/16] net: qrtr: Add MHI transport layer
Message-ID: <20200318144246.GA2859404@kroah.com>
References: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
 <20200220095854.4804-15-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220095854.4804-15-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 03:28:52PM +0530, Manivannan Sadhasivam wrote:
> MHI is the transport layer used for communicating to the external modems.
> Hence, this commit adds MHI transport layer support to QRTR for
> transferring the QMI messages over IPC Router.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/Kconfig  |   7 ++
>  net/qrtr/Makefile |   2 +
>  net/qrtr/mhi.c    | 209 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 218 insertions(+)
>  create mode 100644 net/qrtr/mhi.c

I stopped here in this series, as I do not feel comfortable merging
stuff under net/.

Can you get some review by the networking developers and then I will be
ok with taking it through my tree.

thanks,

greg k-h
