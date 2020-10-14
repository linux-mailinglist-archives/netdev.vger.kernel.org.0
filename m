Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32AE28E95D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbgJNX7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNX7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:59:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B7D6214D8;
        Wed, 14 Oct 2020 23:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719981;
        bh=FfHibkEmYUCe/bQXHylwghTGPLsFZvJ03fiRBUTaOmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yQGYtX9+h6yNrskNtol3K35NJgu8zKnC+mMl2tw3C0YT71wJ0/lgT0ODq3C4Y0bDX
         tLPeOLvk/AV2REISI5w9/mpeYQVEQrnAv/EjbyVfFHgCkWgkW/9kNh+xBWllnjogve
         OTrkIYNx+L29Reb2tqG2ZaAuvUelXb6OfaQqx2QQ=
Date:   Wed, 14 Oct 2020 16:59:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
 OcteonTX2 CPT PF driver
Message-ID: <20201014165939.2cc81954@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-5-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-5-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:27:10 +0530 Srujana Challa wrote:
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));

dma_set_mask_and_coherent()
