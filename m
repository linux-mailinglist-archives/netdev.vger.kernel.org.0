Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B320A5F8
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406523AbgFYTiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406069AbgFYTiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:38:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC463C08C5C1;
        Thu, 25 Jun 2020 12:38:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35FA113B48C33;
        Thu, 25 Jun 2020 12:38:11 -0700 (PDT)
Date:   Thu, 25 Jun 2020 12:38:10 -0700 (PDT)
Message-Id: <20200625.123810.272736267545607911.davem@davemloft.net>
To:     t.martitz@avm.de
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, kuba@kernel.org, nbd@nbd.name,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] net: bridge: enfore alignment for ethernet address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625122602.2582222-1-t.martitz@avm.de>
References: <20200625065407.1196147-1-t.martitz@avm.de>
        <20200625122602.2582222-1-t.martitz@avm.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 12:38:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Martitz <t.martitz@avm.de>
Date: Thu, 25 Jun 2020 14:26:03 +0200

> The eth_addr member is passed to ether_addr functions that require
> 2-byte alignment, therefore the member must be properly aligned
> to avoid unaligned accesses.
> 
> The problem is in place since the initial merge of multicast to unicast:
> commit 6db6f0eae6052b70885562e1733896647ec1d807 bridge: multicast to unicast
> 
> Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Martitz <t.martitz@avm.de>

Applied and queued up for -stable.

Please do not explicitly CC: stable for networking changes, I take care
of those by hand.

Thank you.
