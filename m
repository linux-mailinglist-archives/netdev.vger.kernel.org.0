Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE513FB9AF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfKMUXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:23:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMUXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:23:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFCCF120477DB;
        Wed, 13 Nov 2019 12:23:07 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:23:07 -0800 (PST)
Message-Id: <20191113.122307.27797700143710756.davem@davemloft.net>
To:     cforno12@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH net-next] ibmveth: Detect unsupported packets before
 sending to the hypervisor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113154407.50653-1-cforno12@linux.vnet.ibm.com>
References: <20191113154407.50653-1-cforno12@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 12:23:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cris Forno <cforno12@linux.vnet.ibm.com>
Date: Wed, 13 Nov 2019 09:44:07 -0600

> @@ -1011,6 +1011,29 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
>  	return 0;
>  }
>  
> +static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
> +					 struct net_device *netdev)
> +{
> +	int ret = 0;
> +	struct ethhdr *ether_header;

Please use reverse christmas tree ordering for these local variables.

Thanks.
