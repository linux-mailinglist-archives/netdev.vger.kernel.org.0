Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A914B2F59C1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhANED3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbhANED2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:03:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FEBD238E2;
        Thu, 14 Jan 2021 04:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610596967;
        bh=rLDlZhE4clh7wpTKiQtra2JxDSb5P8nhufyun18HY1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBtNq1UtW/zDFFv0IgHKKher6fmVdWMrn32l9PDpOJTl5Ph1DOCexoWjt3NqD5x1d
         4BzAeCUvqyeIrBPFXoUFriTRVMuooV9C4ieedi4FNiZT4wv9IYEnam6lnzpWBNHdum
         V/CDST98IeTcyvFVmLIqRDwfACfidDTDM+UfIGmfERstlVfbdVC6f6VCUoOJLApqRf
         Dkxv5xKW+oKqbIBQb7QqFOpf7+3dF+4CAILe7rxjxAjYAqYjqKvcMe7k4405XCNLMC
         yf4sLMmd/sq9HHTvUVbGjdCwMJyye2ftoigPYgyCTDYe+IpmgwD0k3w8z+29UPWtZC
         bDFH+7Wmhd2gA==
Date:   Wed, 13 Jan 2021 20:02:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH net-next 1/3] bus: mhi: core: Add helper API to return
 number of free TREs
Message-ID: <20210113200246.526d4dc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114035749.GA4607@work>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
        <20210113193301.2a9b7ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114035749.GA4607@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 09:27:49 +0530 Manivannan Sadhasivam wrote:
> On Wed, Jan 13, 2021 at 07:33:01PM -0800, Jakub Kicinski wrote:
> > On Mon, 11 Jan 2021 19:07:40 +0100 Loic Poulain wrote:  
> > > From: Hemant Kumar <hemantk@codeaurora.org>
> > > 
> > > Introduce mhi_get_free_desc_count() API to return number
> > > of TREs available to queue buffer. MHI clients can use this
> > > API to know before hand if ring is full without calling queue
> > > API.
> > > 
> > > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > > Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>  
> > 
> > Can we apply these to net-next or does it need to be on a stable branch
> > that will also get pulled into mhi-next?  
> 
> We should use the immutable branch for this so that I can pull into
> mhi-next.

Thanks for a quire reply!

Loic, FWIW git merge-base is your friend.
