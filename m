Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDC582403
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHERaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:30:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59576 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfHERaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:30:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23CE5154080F5;
        Mon,  5 Aug 2019 10:30:03 -0700 (PDT)
Date:   Mon, 05 Aug 2019 10:30:02 -0700 (PDT)
Message-Id: <20190805.103002.641507066504156536.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     socketcan@hartkopp.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: can: Fix compiling warnings for two
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805115744.112440-1-maowenan@huawei.com>
References: <6fd68e9b-a8ae-4e5e-9b23-c099b5ca9aa4@web.de>
        <20190805115744.112440-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 10:30:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 5 Aug 2019 19:57:44 +0800

> @@ -1680,7 +1680,7 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  	return size;
>  }
>  
> -int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
> +static int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
>  			 unsigned long arg)

The alignment of the second line here needs to be adjusted, it must start
precisely at the first column after the openning parenthesis of the first
line.

Same for the other change in this patch.
