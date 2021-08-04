Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103E63E0AFE
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhHDXw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhHDXw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7238B60E74;
        Wed,  4 Aug 2021 23:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628121132;
        bh=GaUVR4F7f+sFzr/xkqgZ6fCsqAi65wnqE2WixQ1qK7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FAAsayDdUZFt250jNPqVXgM2siua7E14+TF048p066UrjDZUaR3gVg+vcFfja+NLK
         tBNtFYS+Wmw53OnQbXPKTVeUKuZby9g6G494T1irxUrAQBhFyuBogx5vaDrrSG0U4s
         HhpOG+4i291MFDsPxqX31o5qVLQYb0arydLQJ6wE0/B8ywm/zgh65u0TyOQyS4wNcB
         OxkMBPMprre4WOLZVo+u375oUwwN0BZdjENTYVkm+rTGYDiaSJjkGSWIyYKjW3G2MM
         Veg4uuVFOUgwYtaAtNSY0B3+1yNxOSkD0iDLoiSCRK8nQ0GOLlJfOj/39rvdAtXGpG
         F7cR0CSlFwZaw==
Date:   Wed, 4 Aug 2021 18:52:11 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
Message-ID: <20210804235211.GA1693993@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:06PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> sending Requests to other Endpoints (as opposed to host memory), the
> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> unless an implementation-specific mechanism determines that the Endpoint
> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
> write 0 to disable 10-Bit Tag Requester when the driver does not bind
> the device if the peer device does not support the 10-Bit Tag Completer.
> This will make P2P traffic safe. the 10bit_tag file content indicate
> current 10-Bit Tag Requester Enable status.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>

> +		The file is also writeable, the value only accept by write 0
> +		to disable 10-Bit Tag Requester when the driver does not bind
> +		the deivce. The typical use case is for p2pdma when the peer
> +		device does not support 10-BIT Tag Completer.

s/10-BIT/10-Bit/
