Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD861225799
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgGTG3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:29:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:41371 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGTG3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 02:29:06 -0400
Received: from localhost (bharat.asicdesigners.com [10.193.177.155] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06K6SciR031082;
        Sun, 19 Jul 2020 23:28:52 -0700
Date:   Mon, 20 Jul 2020 11:58:37 +0530
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Message-ID: <20200720062837.GA22415@chelsio.com>
References: <20200717134759.8268-1-vishal@chelsio.com>
 <20200717180251.GC1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717180251.GC1339445@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, July 07/17/20, 2020 at 20:02:51 +0200, Andrew Lunn wrote:
> On Fri, Jul 17, 2020 at 07:17:55PM +0530, Vishal Kulkarni wrote:
> > This series of patches add support for below tests.
> > 1. Adapter status test
> > 2. Link test
> > 3. Link speed test
> > 4. Loopback test
> 
> Hi Vishal
> 
> The loopback test is pretty usual for an ethtool self test. But the
> first 3 are rather odd. They don't really seem to be self tests. What
> reason do you have for adding these? Are you trying to debug a
> specific problem?
> 
> 	 Andrew
Hi Andrew,

Our requirement is to add a list of self tests that can summarize if the adapter is functioning
properly in a single command during system init. The above tests are the most common ones run by
our on-field diagnostics team. Besides, these tests seem to be the most common among other drivers as well.

Hence we have added
1. Adapter status test: Tests whether the adapter is alive or crashed
2. Link test: Adapter PHY is up or not.
3. Link speed test: Adapter has negotiated link speed correctly or not.

-Vishal
