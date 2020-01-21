Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831E114382E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgAUI0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:26:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUI0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 03:26:22 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A0C31584F8D5;
        Tue, 21 Jan 2020 00:26:21 -0800 (PST)
Date:   Tue, 21 Jan 2020 09:26:16 +0100 (CET)
Message-Id: <20200121.092616.2220134914754730334.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-01-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121071631.25188-1-steffen.klassert@secunet.com>
References: <20200121071631.25188-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 00:26:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Tue, 21 Jan 2020 08:16:27 +0100

> 1) Fix packet tx through bpf_redirect() for xfrm and vti
>    interfaces. From Nicolas Dichtel.
> 
> 2) Do not confirm neighbor when do pmtu update on a virtual
>    xfrm interface. From Xu Wang.
> 
> 3) Support output_mark for offload ESP packets, this was
>    forgotten when the output_mark was added initially.
>    From Ulrich Weber.
> 
> Please pull or let me know if there are problems.

Pulled, thanks.
