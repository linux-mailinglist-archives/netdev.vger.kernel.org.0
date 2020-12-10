Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA3A2D5120
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgLJDHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgLJDHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:07:49 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFCCC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 19:07:09 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B78D84D259C1F;
        Wed,  9 Dec 2020 19:07:07 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:07:07 -0800 (PST)
Message-Id: <20201209.190707.1273769613807925702.davem@davemloft.net>
To:     drt@linux.ibm.com
Cc:     kuba@kernel.org, dnbanerg@us.ibm.com, ljp@linux.ibm.com,
        sukadev@linux.ibm.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ibmvnic: fix rx buffer tracking and index
 management in replenish_rx_pool partial success
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210015331.44966-1-drt@linux.ibm.com>
References: <20201210015331.44966-1-drt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:07:08 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>
Date: Wed,  9 Dec 2020 20:53:31 -0500

> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
> 
> We observed that in the error case for batched send_subcrq_indirect() the
> driver does not account for the partial success case. This caused Linux to
> crash when free_map and pool index are inconsistent.
> 
> Driver needs to update the rx pools "available" count when some batched
> sends worked but an error was encountered as part of the whole operation.
> Also track replenish_add_buff_failure for statistic purposes.
> 
> Fixes: 4f0b6812e9b9a ("ibmvnic: Introduce batched RX buffer descriptor transmission")
> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
> Reviewed-by: Dany Madden <drt@linux.ibm.com>

Applied, thanks.
