Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C943A0496
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhFHTnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237902AbhFHTmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D3C261182;
        Tue,  8 Jun 2021 19:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623181245;
        bh=qfuqQmybyoljq64r0RNXg0MCacqzHKintngcUPoNU1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rukof2lFlIsdSSLRDf4Yj8FgPS3MrVjads+/4I7R4vNh0NXly9Q7ysZp2K+c+6Hnj
         KG+9IQlpJsntLINn+QZIfOiObQivVWFi7RaYRQNEEwbCuosAcPp9PJy13Ps+4JQEPR
         3tzPehb9+Mm/EoPtn1jtVeKFPgTx0ooMJCLyZE7zGfCXjA8NVlWVdA2VAisTKRK+ZN
         zDeycpNcLjpreu7E231pj1rMJPtHk1Bp4tVNTssqfhbAptLBkiWEe274ucwvQ6c/+s
         2N3DQ9v0BmL5YMdmYGt08R2jnzceHyuUBXwqBEPVekYDczYzH8ioZ5Fyu8iOclJTOv
         NrsGwGE9Hf6mA==
Date:   Tue, 8 Jun 2021 12:40:42 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, geert@linux-m68k.org, axboe@fb.com, sagi@grimberg.me,
        okulkarni@marvell.com, hare@suse.de, dbalandin@marvell.com,
        himanshu.madhani@oracle.com, smalin@marvell.com, pmladek@suse.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: please drop the nvme code from net-next
Message-ID: <20210608194042.GA339628@dhcp-10-100-145-180.wdc.com>
References: <20210608121925.GA24201@lst.de>
 <CAMuHMdWgLf8GJfOaRUyx=AvOTnuOs8FS-2=C+OCk02OLDCyrDg@mail.gmail.com>
 <20210608134303.GA30977@lst.de>
 <20210608.120839.259439633590059559.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608.120839.259439633590059559.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 12:08:39PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 8 Jun 2021 15:43:03 +0200
> 
> > please drop the nvme-offload code from net-next.  Code for drivers/nvme/
> > needs ACKs from us nvme maintainers and for something this significant
> > also needs to go through the NVMe tree.  And this code is not ready yet.
> 
> Please send me a revert, and I will apply it, thank you.
> 
> It's tricky because at least one driver uses the new interfaces.

Shouldn't whoever merged un-ACK'ed patches from a different subsystem
get to own the tricky revert?
