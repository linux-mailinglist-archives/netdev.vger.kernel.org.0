Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F6617ED94
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCJBEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:04:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgCJBEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:04:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75AE215A01A79;
        Mon,  9 Mar 2020 18:04:30 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:04:30 -0700 (PDT)
Message-Id: <20200309.180430.1182071186379257002.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        tlfalcon@linux.vnet.ibm.com
Subject: Re: [PATCH net] ibmvnic: Do not process device remove during
 device reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310000204.58596-1-julietk@linux.vnet.ibm.com>
References: <20200310000204.58596-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:04:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>
Date: Mon,  9 Mar 2020 19:02:04 -0500

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index c75239d8820f..7ef1ae0d49bc 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2144,6 +2144,8 @@ static void __ibmvnic_reset(struct work_struct *work)
>  	struct ibmvnic_adapter *adapter;
>  	u32 reset_state;
>  	int rc = 0;
> +	unsigned long flags;
> +	bool saved_state = false;

Please preserve the reverse christmas tree ordering of local variables.

Thank you.
