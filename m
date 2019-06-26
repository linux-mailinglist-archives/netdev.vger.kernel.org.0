Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069DB567C4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfFZLhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:37:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:44512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbfFZLhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 07:37:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96F2AAB9B;
        Wed, 26 Jun 2019 11:37:32 +0000 (UTC)
Date:   Wed, 26 Jun 2019 20:37:26 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
Message-ID: <20190626113726.GB27420@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-3-bpoirier@suse.com>
 <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/26 09:24, Manish Chopra wrote:
> > -----Original Message-----
> > From: Benjamin Poirier <bpoirier@suse.com>
> > Sent: Monday, June 17, 2019 1:19 PM
> > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > Subject: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_order is
> > present once in the ql_adapter structure. All rings use the same buf size, keep
> > only one copy of it. Also factor out the calculation of lbq_buf_size instead of
> > having two copies.
> > 
> > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > ---
[...]
> 
> Not sure if this change is really required, I think fields relevant to rx_ring should be present in the rx_ring structure.
> There are various other fields like "lbq_len" and "lbq_size" which would be same for all rx rings but still under the relevant rx_ring structure. 

Indeed, those members are also removed by this patch series, in patch 11.
