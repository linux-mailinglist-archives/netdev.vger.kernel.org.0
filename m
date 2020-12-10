Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D247F2D55D3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgLJIzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388502AbgLJIyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 03:54:53 -0500
Date:   Thu, 10 Dec 2020 09:55:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607590452;
        bh=xIgVJvAlVCJKs4E82O3GqG7+LHjFNMuiHbinDzdeBfE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=12qGSl6F2u3dhjHpFyxAOrcmayyyL/HpeQol392+zZWqOLkpTNsbaxiH/TIagnEe5
         c6ugbivK+7Afok7l+STVpiZmlJsQBMfTKPKKyuE+QvS2pitlakuFgWVMoGqxBzqN/v
         VGHEWYrv+J/6rJvNx4uu7l9mI+Z1/1aVQkFfTFL8=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v16 4/4] bus: mhi: Add userspace client interface driver
Message-ID: <X9HifqAntBUBV0Ce@kroah.com>
References: <1607584885-23824-1-git-send-email-hemantk@codeaurora.org>
 <1607584885-23824-5-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607584885-23824-5-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:21:25PM -0800, Hemant Kumar wrote:
> This MHI client driver allows userspace clients to transfer
> raw data between MHI device and host using standard file operations.
> Driver instantiates UCI device object which is associated to device
> file node. UCI device object instantiates UCI channel object when device
> file node is opened. UCI channel object is used to manage MHI channels
> by calling MHI core APIs for read and write operations. MHI channels
> are started as part of device open(). MHI channels remain in start
> state until last release() is called on UCI device file node. Device
> file node is created with format
> 
> /dev/<mhi_device_name>
> 
> Currently it supports QMI channel.
> 
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> Tested-by: Loic Poulain <loic.poulain@linaro.org>
> ---

Can you provide a pointer to the open-source userspace program that will
be talking to this new kernel driver please?  That should be part of the
changelog here.

thanks,

greg k-h
