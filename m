Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57F6251DD2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgHYRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYRIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:08:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AD4C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:08:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A55A134A42D1;
        Tue, 25 Aug 2020 09:51:23 -0700 (PDT)
Date:   Tue, 25 Aug 2020 10:08:05 -0700 (PDT)
Message-Id: <20200825.100805.388932748785591114.davem@davemloft.net>
To:     drt@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mmc@linux.vnet.ibm.com
Subject: Re: [PATCH net v2] ibmvnic fix NULL tx_pools and rx_tools issue at
 do_reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825165606.806674-1-drt@linux.ibm.com>
References: <20200825165606.806674-1-drt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 09:51:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>
Date: Tue, 25 Aug 2020 12:56:06 -0400

> @@ -2011,7 +2017,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>  		    adapter->req_rx_add_entries_per_subcrq !=
>  		    old_num_rx_slots ||
>  		    adapter->req_tx_entries_per_subcrq !=
> -		    old_num_tx_slots) {
> +		    old_num_tx_slots ||
> +			!adapter->rx_pool ||
> +			!adapter->tso_pool ||
> +			!adapter->tx_pool) {

Please don't over indent these new lines, indent them identically as the
lines above where you are adding new conditions.

Thank you.
