Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74E3558E1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfFYUb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:31:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50634 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:31:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21C05126A7DA9;
        Tue, 25 Jun 2019 13:31:27 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:31:23 -0700 (PDT)
Message-Id: <20190625.133123.667513822232767903.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625103359.31102-1-ssuryaextr@gmail.com>
References: <20190625103359.31102-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:31:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Tue, 25 Jun 2019 06:33:59 -0400

> Multicast egress packets has skb_rtable(skb)->rt_iif set to the oif.
> Depending on the socket, these packets might be recirculated back as
> input and raw sockets that are opened for them are bound to the VRF. But
> since skb_rtable(skb) is set and its rt_iif is non-zero, inet_iif()
> function returns rt_iif instead of skb_iif (the VRF netdev). Hence, the
> socket lookup fails.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

David A., please review.

Thank you.
