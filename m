Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4D2C73ED
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbgK1Vtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731963AbgK1S5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 13:57:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6691522261;
        Sat, 28 Nov 2020 08:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606550661;
        bh=JMAcI3P9B3e2NrhGJ4Knm8qZWQF1fXXwg07Qn6920p4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x6gyt8xwbsgF5jVHSsBvirencplyvBolXNZ3qQsda55N2+O4SrhofXHkv3OEsxTE6
         Pfot055dpwOKUIXq+Bf38d+/ZjQ/pfYHw/G2WlkeKBGiB8JMWVj3l7QN86snRH72Ey
         WFIo2jrABweQ0ClNUjK+KgvuufrSI7lf7UDeuy1o=
Date:   Sat, 28 Nov 2020 09:05:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v12 1/5] bus: mhi: core: Add helper API to return number
 of free TREs
Message-ID: <X8IErAoTjvnTliCv@kroah.com>
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
 <1605566782-38013-2-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi-qxKgs==kXXuSY3Y-GTfcGb7WjQuzn3tXMt2NZNuzriA@mail.gmail.com>
 <20201128062946.GL3077@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128062946.GL3077@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 11:59:46AM +0530, Manivannan Sadhasivam wrote:
> On Wed, Nov 18, 2020 at 10:32:45AM +0100, Loic Poulain wrote:
> > On Mon, 16 Nov 2020 at 23:46, Hemant Kumar <hemantk@codeaurora.org> wrote:
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
> > In case this series get new comments to address, I would suggest
> > merging that patch in mhi-next separately so that other drivers can
> > start benefiting this function (I would like to use it in mhi-net).
> > 
> 
> Greg doesn't like that. He asked me to pick APIs only when there an in-tree
> consumer available.

If someone wants to use it, then yes, by all means merge it.  I can't
just take new apis without any user.

thanks,

greg k-h
