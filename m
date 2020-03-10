Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A298A17ED98
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJBFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:05:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:05:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18EA615A01A9C;
        Mon,  9 Mar 2020 18:05:05 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:05:04 -0700 (PDT)
Message-Id: <20200309.180504.1416144561494778143.davem@davemloft.net>
To:     martin.varghese@nokia.com
Cc:     ap420073@gmail.com, netdev@vger.kernel.org,
        martinvarghesenokia@gmail.com
Subject: Re: 2baecda bareudp: remove unnecessary udp_encap_enable() in
 bareudp_socket_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <DB6PR07MB44089E7D737DE2A76C7EEBEDEDFF0@DB6PR07MB4408.eurprd07.prod.outlook.com>
References: <DB6PR07MB44089E7D737DE2A76C7EEBEDEDFF0@DB6PR07MB4408.eurprd07.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:05:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Date: Tue, 10 Mar 2020 01:03:49 +0000

> HI Taehee Yoo & David,
> 
> The commit "2baecda bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()" breaks the receive handler  of  bareudp device.
> setup_udp_tunnel_sock does not call udp_encap_enable() if the socket is ipv6. In bareudp v6 socket is used to receive v4 traffic also.
> Please let me know if I need to submit a patch again to put back the below lines
> 
> if (sock->sk->sk_family == AF_INET6)
>              udp_encap_enable();

So submit a fix.
