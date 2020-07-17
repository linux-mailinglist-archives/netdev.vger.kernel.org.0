Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F592242C7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgGQSC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:02:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgGQSCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:02:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwUh9-005ds1-RW; Fri, 17 Jul 2020 20:02:51 +0200
Date:   Fri, 17 Jul 2020 20:02:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Message-ID: <20200717180251.GC1339445@lunn.ch>
References: <20200717134759.8268-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717134759.8268-1-vishal@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 07:17:55PM +0530, Vishal Kulkarni wrote:
> This series of patches add support for below tests.
> 1. Adapter status test
> 2. Link test
> 3. Link speed test
> 4. Loopback test

Hi Vishal

The loopback test is pretty usual for an ethtool self test. But the
first 3 are rather odd. They don't really seem to be self tests. What
reason do you have for adding these? Are you trying to debug a
specific problem?

	 Andrew
