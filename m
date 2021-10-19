Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C1D433B72
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhJSQCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhJSQCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9EC61260;
        Tue, 19 Oct 2021 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634659228;
        bh=hnDaSyNP12HzzL3n9o6PK07jjMfNL3pKH5xcK3KdE2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCcF64wuXd2EOcfdTN5YcRfSW4rGgkDy3vPNWfp5DTQOELC9GC9neYn/9ZFOqX6d1
         NJFyTXneovoZGnwDSQQfE+P8tgvESnrQEgD32zu3PlOxvOKKnkYST2Ac93WS2/hLEs
         RE3nFdcxKSgsfKQD/6srnr8JazYkmvyR0dJGPXHo=
Date:   Tue, 19 Oct 2021 18:00:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev, loic.poulain@linaro.org,
        hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] bus: mhi: Add mhi_prepare_for_transfer_autoqueue API for
 DL auto queue
Message-ID: <YW7rmqTAxcF5hjEM@kroah.com>
References: <20211019134451.174318-1-manivannan.sadhasivam@linaro.org>
 <20211019074918.5b498937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019074918.5b498937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 07:49:18AM -0700, Jakub Kicinski wrote:
> On Tue, 19 Oct 2021 19:14:51 +0530 Manivannan Sadhasivam wrote:
> > Add a new API "mhi_prepare_for_transfer_autoqueue" for using with client
> > drivers like QRTR to request MHI core to autoqueue buffers for the DL
> > channel along with starting both UL and DL channels.
> > 
> > So far, the "auto_queue" flag specified by the controller drivers in
> > channel definition served this purpose but this will be removed at some
> > point in future.
> > 
> > Cc: netdev@vger.kernel.org
> > Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> > 
> > Dave, Jakub: This patch should go through MHI tree. But since the QRTR driver
> > is also modified, this needs an Ack from you.
> 
> CCing us wouldn't hurt.
> 
> Speaking of people who aren't CCed I've seen Greg nack the flags
> argument.

Yes, that type of api is not ok.
