Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3E3A0319
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhFHTMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:12:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53216 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbhFHTKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:10:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8AE204D30E6A0;
        Tue,  8 Jun 2021 12:08:43 -0700 (PDT)
Date:   Tue, 08 Jun 2021 12:08:39 -0700 (PDT)
Message-Id: <20210608.120839.259439633590059559.davem@davemloft.net>
To:     hch@lst.de
Cc:     geert@linux-m68k.org, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, okulkarni@marvell.com, hare@suse.de,
        dbalandin@marvell.com, himanshu.madhani@oracle.com,
        smalin@marvell.com, pmladek@suse.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: please drop the nvme code from net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210608134303.GA30977@lst.de>
References: <20210608121925.GA24201@lst.de>
        <CAMuHMdWgLf8GJfOaRUyx=AvOTnuOs8FS-2=C+OCk02OLDCyrDg@mail.gmail.com>
        <20210608134303.GA30977@lst.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Jun 2021 12:08:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 8 Jun 2021 15:43:03 +0200

> please drop the nvme-offload code from net-next.  Code for drivers/nvme/
> needs ACKs from us nvme maintainers and for something this significant
> also needs to go through the NVMe tree.  And this code is not ready yet.

Please send me a revert, and I will apply it, thank you.

It's tricky because at least one driver uses the new interfaces.

Thank you.
