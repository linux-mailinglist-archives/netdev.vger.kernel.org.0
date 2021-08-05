Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A23E1618
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbhHENyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241778AbhHENyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4CE61157;
        Thu,  5 Aug 2021 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628171638;
        bh=ZalQG662IXTcyh3MsfHL5bDf1isxgd8l9UI/IjdZ6B4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aiY7GdTjJKfhSf96A3bqXb/p1a43jtGaD4oiZT6yst961vXXAgj/EaQNGjjTIyoam
         EQc6U5whqoMp0u6D8u/ZFO50NTQDpoYKymUIowzlLCpZazcqIDp1FyRvRC44DOXeTc
         qILxLyZNc6XUetrGlUzcY+iaCr+v1x6ccHBKijgC1SBTuMHezRF8p2yIUwH+XwSZSH
         1ZBT1dx1/7ixHmQNCwYibl/+ITrQK3t5g09CPT8LWbKyQ8Zk5dCLHSUjlSFZcwI8NR
         Yhtmn3ywcUl8YBWc92+LJB3Kz38azkkin/HrSOxmtiqLdvDpO4nHfhYHa84UCu7bQN
         kYeckWD4v9+ww==
Date:   Thu, 5 Aug 2021 16:53:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
Message-ID: <YQvtcjudPQQ8LToU@unreal>
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
 <75243571-3213-6ae2-040f-ae1b1f799e42@deltatee.com>
 <8758a42b-233b-eb73-dce4-493e0ce8eed5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8758a42b-233b-eb73-dce4-493e0ce8eed5@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 09:14:50PM +0800, Dongdong Liu wrote:
> On 2021/8/4 23:51, Logan Gunthorpe wrote:
> > 
> > 
> > 
> > On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
> > > PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> > > sending Requests to other Endpoints (as opposed to host memory), the
> > > Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> > > unless an implementation-specific mechanism determines that the Endpoint
> > > supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
> > > write 0 to disable 10-Bit Tag Requester when the driver does not bind
> > > the device if the peer device does not support the 10-Bit Tag Completer.
> > > This will make P2P traffic safe. the 10bit_tag file content indicate
> > > current 10-Bit Tag Requester Enable status.
> > 
> > Can we not have both the sysfs file and the command line parameter? If
> > the user wants to disable it always for a specific device this sysfs
> > parameter is fairly awkward. A script at boot to unbind the driver, set
> > the sysfs file and rebind the driver is not trivial and the command line
> > parameter offers additional options for users.
> Does the command line parameter as "[PATCH V6 7/8] PCI: Add
> "pci=disable_10bit_tag=" parameter for peer-to-peer support" does?
> 
> Do we also need such command line if we already had sysfs file?
> I think we may not need.

I think the same.

> 
> Thanks,
> Dongdong
> > 
> > Logan
> > .
> > 
