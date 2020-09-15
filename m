Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6861F26B1EA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgIOWhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbgIOWh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:37:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9BC06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:37:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0236113757C27;
        Tue, 15 Sep 2020 15:20:41 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:37:28 -0700 (PDT)
Message-Id: <20200915.153728.107358987807075865.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     andrew@lunn.ch, jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
From:   David Miller <davem@davemloft.net>
In-Reply-To: <734f0c4595a18ab136263b6e5c97e7f48a93abe1.camel@kernel.org>
References: <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
        <20200915140326.GG3485708@lunn.ch>
        <734f0c4595a18ab136263b6e5c97e7f48a93abe1.camel@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:20:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Tue, 15 Sep 2020 13:03:03 -0700

> On Tue, 2020-09-15 at 16:03 +0200, Andrew Lunn wrote:
>> I would prefer we just enable W=1 by default for everything under
>> driver/net. Maybe there is something we can set in
>> driver/net/Makefile?
>> 
> 
> 
> Yes we can have our own gcc options in the Makfile regardless of what
> you put in W command line argument.

I definitely would like to see W=1 in drivers/net/Makefile eventually.
