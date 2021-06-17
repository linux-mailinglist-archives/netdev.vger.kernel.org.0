Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE13AB9B4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhFQQbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:31:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhFQQbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 12:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wKKVhPiz/c99/Aot49JXhSgZm5nwDFI+TVyS7BHrs1Q=; b=ugZ6HqjGG4twSb8tgaPw0U7Z/d
        +Ylbpn6jS3+2eQkfq/kXIZeM+3/rA+LHR7IQZwl8PHilTtVU+CcJx2WDLk4jv0BiJWwHk5xumkGno
        A0LTLtc+c/ebg3V3LczcPo3tewzTrUr0TTq2qsDu+DW360k5HeX1R/ydzjME0OpmVZgs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltutQ-009wAz-Mo; Thu, 17 Jun 2021 18:29:24 +0200
Date:   Thu, 17 Jun 2021 18:29:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peng Li <lipeng321@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huangguangbin2@huawei.com
Subject: Re: [PATCH net-next 5/6] net: hostess_sv11: fix the comments style
 issue
Message-ID: <YMt4ZMuPfjeesnRK@lunn.ch>
References: <1623941615-26966-1-git-send-email-lipeng321@huawei.com>
 <1623941615-26966-6-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623941615-26966-6-git-send-email-lipeng321@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -152,12 +146,12 @@ static int hostess_close(struct net_device *d)
>  static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
>  {
>  	/* struct z8530_dev *sv11=dev_to_sv(d);
> -	   z8530_ioctl(d,&sv11->chanA,ifr,cmd) */
> +	 * z8530_ioctl(d,&sv11->chanA,ifr,cmd)
> +	 */
>  	return hdlc_ioctl(d, ifr, cmd);
>  }

That looks more like dead code than anything else. I would suggest you
do a git blame to see if there is anything interesting about this, and
if not, remove it.

   Andrew
