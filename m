Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0738134CE6C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhC2LDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhC2LD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 07:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C4060190;
        Mon, 29 Mar 2021 11:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617015807;
        bh=dcnQW234dKs4Ot/XFvSdFE8GfnqOmIe4OCj0zgGBaPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=arqdeqC/2MB8LNRjAih/Rji4HFoE6csZYM75iIH3+9qSuUS/BbCGeCuKBlpXTHmut
         SF0phHEsC04zXB94Hl006vvhA+5UmF3ReE0WeEJZjHLijhC5gUMvRRxlXHO0eXlPPR
         jUENprb5hOQBXpfOd/V9ykp9xSaFH13l+Pk1QVfY=
Date:   Mon, 29 Mar 2021 13:03:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <YGGz/BaibxykzxOW@kroah.com>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <CAMZdPi_3B9Bxg=7MudFq+RnhD10Mm5QbX_pBb5vyPsZAC_bNOQ@mail.gmail.com>
 <20210329105236.GB2763@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329105236.GB2763@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 04:22:36PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> On Mon, Mar 29, 2021 at 11:47:12AM +0200, Loic Poulain wrote:
> > Hi Greg,
> > 
> > On Sun, 28 Mar 2021 at 14:28, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > wrote:
> > 
> > > There does not seem to be any developers willing to maintain the
> > > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > > from the kernel tree entirely in a few kernel releases if no one steps
> > > up to maintain it.
> > >
> > > Reported-by: Matthew Wilcox <willy@infradead.org>
> > > Cc: Du Cheng <ducheng2@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > 
> > As far as I know, QRTR/IPCR is still commonly used with Qualcomm-based
> > platforms for accessing various components of the SoC.
> > CCing Bjorn and Mani, In case they are interested in taking maintenance of
> > that.
> > 
> 
> As Loic said, QRTR is an integral component used in various Qualcomm based
> upstream supported products like ChromeOS, newer WLAN chipsets (QCA6390) etc...
> 
> It is unfortunate that no one stepped up so far to maintain it. After
> having an internal discussion, I decided to pitch in as a maintainer. I'll
> send the MAINTAINERS change to netdev list now.

Great, can you also fix up the reported problems with the codebase that
resulted in this "ask for removal"?

thanks,

greg k-h
