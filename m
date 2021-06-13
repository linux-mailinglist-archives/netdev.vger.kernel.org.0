Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D33A598A
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhFMQZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 12:25:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhFMQZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 12:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5RksiTEuqrcQH/x1ZKeSyWXWfMMc3Shg0IwC+El1H2k=; b=cQFMtn3EIwJxSg3KMtag2QW5wF
        bvK1o0IpojsGU/VDnO0fAGgiuaK0K3TXNzCwJZ2MNlu/PObEbadUBjVR6iHORtDuxXwzRiM5qnRPc
        OsD2llQXoatvK1rBbGcmIIkqgwnSVtQSH/mkGPqRd7vwV4WHsrtalnS+L2OYT//+lJ14=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsSt0-009B1p-Kp; Sun, 13 Jun 2021 18:22:58 +0200
Date:   Sun, 13 Jun 2021 18:22:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH net-next 04/11] net: z85230: remove redundant
 initialization for statics
Message-ID: <YMYw4kJ/Erq6fbVh@lunn.ch>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
 <1623569903-47930-5-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623569903-47930-5-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 03:38:16PM +0800, Guangbin Huang wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> Should not initialise statics to 0.
> 
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/wan/z85230.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
> index 94ed9a2..f815bb5 100644
> --- a/drivers/net/wan/z85230.c
> +++ b/drivers/net/wan/z85230.c
> @@ -685,7 +685,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
>  {
>  	struct z8530_dev *dev=dev_id;
>  	u8 intr;
> -	static volatile int locker=0;
> +	static int locker;

Is the volatile unneeded? Please document that in the commit message.

   Andrew
