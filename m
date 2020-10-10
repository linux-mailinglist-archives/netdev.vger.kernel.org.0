Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C691A289DA5
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgJJCoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbgJJBhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:37:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5521321D43;
        Sat, 10 Oct 2020 01:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602293866;
        bh=TImQnumvAsuIvB6ZjobGjyHEklCSDfcLpLW8oqlYYgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6weeN3oR0Vv4iCvav77zhUmvie+4vb02KfZ7c5fQbXh4raMCGsITrc+Tjib6BJrz
         b1Gd1TkuB5RNgqgGMiWpvkaUQmLjtBWH2eXeFSj8CLGMKGKxdZcmFR+8mcP3QOyLDS
         3AH4gJROj8IDnaJnNNAbLRK8Ue3fbJDisi4sjggE=
Date:   Fri, 9 Oct 2020 18:37:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v4,net-next,00/13] Add Support for Marvell OcteonTX2
 Cryptographic
Message-ID: <20201009183744.7504cfc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 21:04:08 +0530 Srujana Challa wrote:
> This series introduces crypto(CPT) drivers(PF & VF) for Marvell OcteonTX2
> CN96XX Soc.
> 
> OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
> physical and virtual functions. Each of the PF/VF's functionality is
> determined by what kind of resources are attached to it. When the CPT
> block is attached to a VF, it can function as a security device.
> The following document provides an overview of the hardware and
> different drivers for the OcteonTX2 SOC: 
> https://www.kernel.org/doc/Documentation/networking/device_drivers/marvell/octeontx2.rst
> 
> The CPT PF driver is responsible for:
> - Forwarding messages to/from VFs from/to admin function(AF),
> - Enabling/disabling VFs,
> - Loading/unloading microcode (creation/deletion of engine groups).
> 
> The CPT VF driver works as a crypto offload device.
> 
> This patch series includes:
> - Patch to update existing Marvell sources to support the CPT driver.
> - Patch that adds mailbox messages to the admin function (AF) driver,
> to configure CPT HW registers.
> - CPT PF driver patches that include AF<=>PF<=>VF mailbox communication,
> sriov_configure, and firmware load to the acceleration engines.
> - CPT VF driver patches that include VF<=>PF mailbox communication and
> crypto offload support through the kernel cryptographic API.
> 
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.

Please rebase and resend, this doesn't apply to net-next:

error: patch failed: drivers/net/ethernet/marvell/octeontx2/af/Makefile:8
error: drivers/net/ethernet/marvell/octeontx2/af/Makefile: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: octeontx2-pf: move lmt flush to include/linux/soc
Applying: octeontx2-af: add mailbox interface for CPT
Patch failed at 0002 octeontx2-af: add mailbox interface for CPT
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

