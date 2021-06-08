Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47E39F804
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhFHNpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:45:01 -0400
Received: from verein.lst.de ([213.95.11.211]:50832 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232768AbhFHNpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 09:45:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6299468AFE; Tue,  8 Jun 2021 15:43:03 +0200 (CEST)
Date:   Tue, 8 Jun 2021 15:43:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Shai Malin <smalin@marvell.com>,
        Petr Mladek <pmladek@suse.com>, linux-nvme@lists.infradead.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: please drop the nvme code from net-next
Message-ID: <20210608134303.GA30977@lst.de>
References: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be> <20210608121925.GA24201@lst.de> <CAMuHMdWgLf8GJfOaRUyx=AvOTnuOs8FS-2=C+OCk02OLDCyrDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWgLf8GJfOaRUyx=AvOTnuOs8FS-2=C+OCk02OLDCyrDg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please drop the nvme-offload code from net-next.  Code for drivers/nvme/
needs ACKs from us nvme maintainers and for something this significant
also needs to go through the NVMe tree.  And this code is not ready yet.
