Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AE23EFF8
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHGPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGPYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 11:24:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB6B21744;
        Fri,  7 Aug 2020 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596813879;
        bh=MYuQqoMFVxzRIi+Ns8NKI4SRbBu+5QOTi8qefsLQM2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XUlKlHjqjAy1Bn5qyhlXLIOu78vQQO5G+DKLPZ2xiIHpb0RZVoxuq6tHK5WlGpvS0
         0tlTTUADwC/rIO2Vl/un4bp/ivj/4En8wtmjm/mqCGB8KZlC1hMA+I/EaxH2hPmrfC
         MYfCCYQnyejk+DMA1NaEbgACCzFt/VuWS9lFLGJg=
Date:   Fri, 7 Aug 2020 08:24:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <schandran@marvell.com>, <pathreya@marvell.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>
Subject: Re: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Message-ID: <20200807082437.246a9f1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596809360-12597-3-git-send-email-schalla@marvell.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
        <1596809360-12597-3-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Aug 2020 19:39:19 +0530 Srujana Challa wrote:
> Add support for the cryptographic acceleration unit (CPT) on
> OcteonTX2 CN96XX SoC.

Please address the W=1 C=1 build warnings

../drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c:475:51: warning: cast removes address space '__iomem' of expression
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:158:39: warning: incorrect type in assignment (different address spaces)
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:158:39:    expected void *lmtline
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:158:39:    got void [noderef] __iomem *
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:161:37: warning: incorrect type in assignment (different address spaces)
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:161:37:    expected void *ioreg
../drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c:161:37:    got void [noderef] __iomem *
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:394:22: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1025:23: warning: cast to restricted __be32
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1887:29: warning: incorrect type in assignment (different base types)
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1887:29:    expected unsigned short [assigned] [usertype] opcode
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1887:29:    got restricted __be16 [usertype]
