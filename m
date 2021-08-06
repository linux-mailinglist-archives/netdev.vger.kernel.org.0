Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C833E31FF
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbhHFW7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFW7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A030A60EE9;
        Fri,  6 Aug 2021 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628290758;
        bh=HU2xeowJBFARB+34Pp8jGrd/zZAOVyAJGJWh8YkA/Ho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=d3jngVQutsnEePS1XLx+uK1ceEvIan/3CPVuRqoMqeoPrlsJOhlRopE606S4OnOVL
         xYzOtTibLua3S6jLxK4i3hSqCV1cv3wGzPbpMmXJpB8Zkm47bdbZS4W2dCzYZJXvYD
         Y8mLDXTOt7g3Si/7HmQ6q8XBerUZdY7F2OzSPKFmwXRJUWbb3Io5LfYpcJ+4weLeY7
         YNlmo/DW9TX61aM0Mh6im9C5H/7U+8MZVT1rvvTAOmiUWd1HJVy5xnSUmVgd1dpM6P
         w0uujMI/8gsDaiYwjPm/Sc8xaOnw2LvOD1WrpDQGO8JPMBWqSSOBxb8rSEuTC+nWvq
         05X8uhCWFRHcA==
Date:   Fri, 6 Aug 2021 17:59:17 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 5/9] PCI/IOV: Enable 10-Bit tag support for PCIe VF
 devices
Message-ID: <20210806225917.GA1897594@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b7a9b7-2951-43c3-5e81-3461b6724955@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 04:03:58PM +0800, Dongdong Liu wrote:
> 
> On 2021/8/5 7:29, Bjorn Helgaas wrote:
> > On Wed, Aug 04, 2021 at 09:47:04PM +0800, Dongdong Liu wrote:
> > > Enable VF 10-Bit Tag Requester when it's upstream component support
> > > 10-bit Tag Completer.
> > 
> > I think "upstream component" here means the PF, doesn't it?  I don't
> > think the PF is really an *upstream* component; there's no routing
> > like with a switch.
>
> I want to say the switch and root port devices that support 10-Bit
> Tag Completer. Sure, VF also needs to have 10-bit Tag Requester
> Supported capability.

OK.  IIUC we're not talking about P2PDMA here; we're talking about
regular DMA to host memory, which means I *think* only the Root Port
is important, since it is the completer for DMA to host memory.  We're
not talking about P2PDMA to a switch BAR, where the switch would be
the completer.
