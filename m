Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D61076B4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVRqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:46:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKVRqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:46:08 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E46A21527DCCB;
        Fri, 22 Nov 2019 09:46:07 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:46:07 -0800 (PST)
Message-Id: <20191122.094607.2168889001623078802.davem@davemloft.net>
To:     andrea.mayer@uniroma2.it
Cc:     sergei.shtylyov@cogentembedded.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, dav.lebrun@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next, v3 1/1] seg6: allow local packet processing for
 SRv6 End.DT6 behavior
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122162242.2574-2-andrea.mayer@uniroma2.it>
References: <20191122162242.2574-1-andrea.mayer@uniroma2.it>
        <20191122162242.2574-2-andrea.mayer@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:46:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>
Date: Fri, 22 Nov 2019 17:22:42 +0100

> End.DT6 behavior makes use of seg6_lookup_nexthop() function which drops
> all packets that are destined to be locally processed. However, DT* should
> be able to deliver decapsulated packets that are destined to local
> addresses. Function seg6_lookup_nexthop() is also used by DX6, so in order
> to maintain compatibility I created another routing helper function which
> is called seg6_lookup_any_nexthop(). This function is able to take into
> account both packets that have to be processed locally and the ones that
> are destined to be forwarded directly to another machine. Hence,
> seg6_lookup_any_nexthop() is used in DT6 rather than seg6_lookup_nexthop()
> to allow local delivery.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

Applied to net-next
