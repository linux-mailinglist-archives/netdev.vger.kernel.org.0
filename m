Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1824A503D8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfFXHnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:43:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:59507 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfFXHnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 03:43:00 -0400
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5O7guox010740;
        Mon, 24 Jun 2019 00:42:57 -0700
Date:   Mon, 24 Jun 2019 13:12:55 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/4] cxgb4: Re-work the logic for mps refcounting
Message-ID: <20190624074254.GA10420@chelsio.com>
References: <20190621143636.20422-1-rajur@chelsio.com>
 <20190621143636.20422-2-rajur@chelsio.com>
 <20190623.113423.151452943171499414.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623.113423.151452943171499414.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, June 06/23/19, 2019 at 11:34:23 -0700, David Miller wrote:
> From: Raju Rangoju <rajur@chelsio.com>
> Date: Fri, 21 Jun 2019 20:06:33 +0530
> 
> > +struct mps_entries_ref {
> > +	struct list_head list;
> > +	u8 addr[ETH_ALEN];
> > +	u8 mask[ETH_ALEN];
> > +	u16 idx;
> > +	atomic_t refcnt;
> > +};
> 
> Since you're making this change, please use refcnt_t.

Sure. Will send out v2 with suggested changes.

Thanks,
Raju

