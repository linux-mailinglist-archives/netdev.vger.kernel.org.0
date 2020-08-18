Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5BA249121
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgHRWoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHRWoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:44:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52516C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:44:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A18BE127E2305;
        Tue, 18 Aug 2020 15:27:15 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:44:01 -0700 (PDT)
Message-Id: <20200818.154401.826640119439302130.davem@davemloft.net>
To:     cforno12@linux.ibm.com
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com
Subject: Re: [PATCH, net-next, v2] ibmvnic: store RX and TX subCRQ handle
 array in ibmvnic_adapter struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818215333.53183-1-cforno12@linux.ibm.com>
References: <20200818215333.53183-1-cforno12@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:27:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristobal Forno <cforno12@linux.ibm.com>
Date: Tue, 18 Aug 2020 16:53:33 -0500

> @@ -1524,7 +1519,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
>  	unsigned int offset;
>  	int num_entries = 1;
>  	unsigned char *dst;
> -	u64 *handle_array;
> +	u64 handle;
>  	int index = 0;
>  	u8 proto = 0;
>  	netdev_tx_t ret = NETDEV_TX_OK;

Please preserve the reverse christmas tree ordering of local variables here.

Otherwise the patch looks fine to me.
