Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617B52272D6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGTX12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTX12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:27:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD7DC061794;
        Mon, 20 Jul 2020 16:27:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C82311E8EC0A;
        Mon, 20 Jul 2020 16:27:27 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:27:26 -0700 (PDT)
Message-Id: <20200720.162726.1756372964350832473.davem@davemloft.net>
To:     srirakr2@cisco.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, mbumgard@cisco.com, ugm@cisco.com,
        nimm@cisco.com, xe-linux-external@cisco.com, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720164551.14153-1-srirakr2@cisco.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 16:27:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Krishnan <srirakr2@cisco.com>
Date: Mon, 20 Jul 2020 22:15:51 +0530

> +	if (skb->protocol == htons(ETH_P_8021Q)) {
> +		u16 vlan_tci = 0;
> +		skb_reset_mac_header(skb);

Please place an empty line between basic block local variable declarations
and actual code.

> +				netdev_err(net,"Pop vlan err %x\n",pop_err);

A space is necessary before "pop_err".
