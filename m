Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DEF123F77
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfLRGSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:18:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRGSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:18:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC4F915005616;
        Tue, 17 Dec 2019 22:18:46 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:18:46 -0800 (PST)
Message-Id: <20191217.221846.1864258542284733289.davem@davemloft.net>
To:     alexchan@task.com.hk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] llc2: Remove the condition operator in
 llc_stat_ev_rx_null_dsap_xid_c and llc_stat_ev_rx_null_dsap_test_c.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576555237-4037-1-git-send-email-alexchan@task.com.hk>
References: <1576340820-4929-1-git-send-email-alexchan@task.com.hk>
        <1576555237-4037-1-git-send-email-alexchan@task.com.hk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:18:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chan Shu Tak, Alex" <alexchan@task.com.hk>
Date: Tue, 17 Dec 2019 12:00:36 +0800

> @@ -32,7 +32,7 @@ static int llc_stat_ev_rx_null_dsap_xid_c(struct sk_buff *skb)
>  	return LLC_PDU_IS_CMD(pdu) &&			/* command PDU */
>  	       LLC_PDU_TYPE_IS_U(pdu) &&		/* U type PDU */
>  	       LLC_U_PDU_CMD(pdu) == LLC_1_PDU_CMD_XID &&
> -	       !pdu->dsap ? 1 : 0;			/* NULL DSAP value */
> +	       !pdu->dsap;				/* NULL DSAP value */

This isn't a v2 of your patch, it's a patch against v1 of your patch.

Please do this properly, thank you.
