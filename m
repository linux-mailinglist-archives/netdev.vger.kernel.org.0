Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA5F567CF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZLkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:40:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:44904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfFZLkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 07:40:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6105AB9B;
        Wed, 26 Jun 2019 11:40:04 +0000 (UTC)
Date:   Wed, 26 Jun 2019 20:39:59 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
Message-ID: <20190626113959.GC27420@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-5-bpoirier@suse.com>
 <DM6PR18MB269776CBA6B979855AD215A8ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB269776CBA6B979855AD215A8ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/26 09:36, Manish Chopra wrote:
> > -----Original Message-----
> > From: Benjamin Poirier <bpoirier@suse.com>
> > Sent: Monday, June 17, 2019 1:19 PM
> > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > Subject: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > Tx rings have sbq_buf_size = 0 but there's no case where the code actually
> > tests on that value. We can remove sbq_buf_size and use a constant instead.
> > 
> 
> Seems relevant to RX ring, not the TX ring ?

qlge uses "struct rx_ring" for rx and for tx completion rings.

The driver's author is probably laughing now at the success of his plan
to confuse those who would follow in his footsteps.
