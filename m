Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0453531F663
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhBSJPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:15:51 -0500
Received: from verein.lst.de ([213.95.11.211]:51109 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhBSJN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 04:13:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EA70E67373; Fri, 19 Feb 2021 10:12:37 +0100 (CET)
Date:   Fri, 19 Feb 2021 10:12:37 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Shai Malin <smalin@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Erik.Smith@dell.com" <Erik.Smith@dell.com>,
        "Douglas.Farley@dell.com" <Douglas.Farley@dell.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Nikolay Assa <nassa@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN Device Driver
Message-ID: <20210219091237.GA4036@lst.de>
References: <20210207181324.11429-1-smalin@marvell.com> <PH0PR18MB3845E15A62826C9B5A520628CC859@PH0PR18MB3845.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB3845E15A62826C9B5A520628CC859@PH0PR18MB3845.namprd18.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 06:38:07PM +0000, Shai Malin wrote:
> So, as there are no more comments / questions, we understand the direction 
> is acceptable and will proceed to the full series.

I do not think we should support offloads at all, and certainly not onces
requiring extra drivers.  Those drivers have caused unbelivable pain for
iSCSI and we should not repeat that mistake.
