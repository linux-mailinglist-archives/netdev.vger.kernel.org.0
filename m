Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00D2128752
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLUFTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:19:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:19:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F8D7153CA10D;
        Fri, 20 Dec 2019 21:19:05 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:19:05 -0800 (PST)
Message-Id: <20191220.211905.1068223395536470966.davem@davemloft.net>
To:     john.rutherford@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: make legacy address flag readable over netlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219050357.22583-1-john.rutherford@dektech.com.au>
References: <20191219050357.22583-1-john.rutherford@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:19:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: john.rutherford@dektech.com.au
Date: Thu, 19 Dec 2019 16:03:57 +1100

> From: John Rutherford <john.rutherford@dektech.com.au>
> 
> To enable iproute2/tipc to generate backwards compatible
> printouts and validate command parameters for nodes using a
> <z.c.n> node address, it needs to be able to read the legacy
> address flag from the kernel.  The legacy address flag records
> the way in which the node identity was originally specified.
> 
> The legacy address flag is requested by the netlink message
> TIPC_NL_ADDR_LEGACY_GET.  If the flag is set the attribute
> TIPC_NLA_NET_ADDR_LEGACY is set in the return message.
> 
> Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
