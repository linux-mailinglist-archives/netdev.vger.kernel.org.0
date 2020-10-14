Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FFD28E94D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbgJNXyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNXyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:54:00 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA7120704;
        Wed, 14 Oct 2020 23:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719640;
        bh=DngqMG6DSZJ3Ue//QnIJBhbxs2msvhqqkMtIrwpjiTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2imd3AC4CoJTYluKpbUfdxZ2a1aikEIUM0XQZIXPRMAIBXR6eP43ezt60fhKIXQkW
         wX/YAtuJEk6M5tMyOj0v7k7NThxqzSW1aCGcvEcGDbYhsynFMBf0IpGKG6t2DVPxnM
         cOuIJRYrU3v3pcpI1bZB7c7Q/N629JdWEP8wFk9s=
Date:   Wed, 14 Oct 2020 16:53:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>
Subject: Re: [PATCH v7,net-next,02/13] octeontx2-af: add mailbox interface
 for CPT
Message-ID: <20201014165358.14f27808@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-3-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-3-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:27:08 +0530 Srujana Challa wrote:
> On OcteonTX2 SoC, the admin function (AF) is the only one with all
> priviliges to configure HW and alloc resources, PFs and it's VFs
> have to request AF via mailbox for all their needs. This patch adds
> a mailbox interface for CPT PFs and VFs to allocate resources
> for cryptography and inline-IPsec.
> Inline-IPsec mailbox messages are added here to provide the interface
> to Marvell VFIO drivers to allocate and configure HW resources
> for inline IPsec feature.
> 
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Vidya Sagar Velumuri <vvelumuri@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>

Please drop the IPsec support from this series, and limit it to just
what's needed to get the Linux crypto API working.
