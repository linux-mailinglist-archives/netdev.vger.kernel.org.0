Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B326C3083A6
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhA2CSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhA2CR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:17:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE35964E04;
        Fri, 29 Jan 2021 02:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886624;
        bh=7uij+CoGN+Vep2uS4iRenX1r+oRCFWqawT+RX615Sno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hBPL4PxE7BBvLdvPoio39TOrRgx/dP1MTdL/Vm9qEME7pZpFUq4lWZdKBBs1hrxsi
         Bn2HdTJ2Y/hBKtARjpAIf35ynHoYj0i/nDvrCh9GwytekdwR0k5DO2QVkvrhnVvUaT
         zTrLBUl2bWIDHsrp+B+NhoHdyikHzlUauQudFrZmn1IjoFWJ3ApAlniRmKZ7ziuv3q
         VImjzkDOukghn94do7g5flLbUsmCOjDMGouaJ9XNdfMDoFkzuX4XRRl2oMP7erGkIj
         Z1p0Si2P15H5rXsxW0WJ7mkRljx0Ot04QTEXh9s8K89FVSxN9CdmyX2NmTKfg8GQUq
         keC/Yl503JUFw==
Date:   Thu, 28 Jan 2021 18:17:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: remove h from printk format specifier
Message-ID: <20210128181702.32b20a81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125164528.2101360-1-trix@redhat.com>
References: <20210125164528.2101360-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 08:45:28 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
>   unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

As I mentioned before I personally don't care much for these changes so
please expect me to be tossing them out of patchwork silently if the
maintainer does not ack in time. YMMV with Dave (he should be back soon)
