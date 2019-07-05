Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39AA60D93
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfGEWBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:01:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEWBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:01:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1168015040FF7;
        Fri,  5 Jul 2019 15:01:30 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:01:29 -0700 (PDT)
Message-Id: <20190705.150129.1445105190093420415.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2019-07-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:01:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 5 Jul 2019 10:46:01 +0200

> 1) A lot of work to remove indirections from the xfrm code.
>    From Florian Westphal.
> 
> 2) Fix a WARN_ON with ipv6 that triggered because of a
>    forgotten break statement. From Florian Westphal.
> 
> 3)  Remove xfrmi_init_net, it is not needed.
>     From Li RongQing.
> 
> Please pull or let me know if there are problems.

Pulled, thanks.
