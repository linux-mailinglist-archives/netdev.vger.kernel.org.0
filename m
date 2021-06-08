Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE94D39F647
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFHMVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:21:22 -0400
Received: from verein.lst.de ([213.95.11.211]:50559 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhFHMVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 08:21:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E93F468AFE; Tue,  8 Jun 2021 14:19:25 +0200 (CEST)
Date:   Tue, 8 Jun 2021 14:19:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Shai Malin <smalin@marvell.com>,
        Petr Mladek <pmladek@suse.com>, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvme: NVME_TCP_OFFLOAD should not default to m
Message-ID: <20210608121925.GA24201@lst.de>
References: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 12:56:09PM +0200, Geert Uytterhoeven wrote:
> The help text for the symbol controlling support for the NVM Express
> over Fabrics TCP offload common layer suggests to not enable this
> support when unsure.
> 
> Hence drop the "default m", which actually means "default y" if
> CONFIG_MODULES is not enabled.
> 
> Fixes: f0e8cb6106da2703 ("nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Err, where did this appear from?  This code has not been accepted into
the NVMe tree and is indeed not acceptable in this form.
