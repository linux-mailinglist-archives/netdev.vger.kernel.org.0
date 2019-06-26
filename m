Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A4571E7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZTkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:40:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZTkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:40:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0C3814A9086A;
        Wed, 26 Jun 2019 12:40:44 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:40:41 -0700 (PDT)
Message-Id: <20190626.124041.1890858416743784155.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net v2] ipv4: reset rt_iif for recirculated mcast/bcast
 out pkts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626062116.4319-1-ssuryaextr@gmail.com>
References: <20190626062116.4319-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 12:40:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Wed, 26 Jun 2019 02:21:16 -0400

> Multicast or broadcast egress packets have rt_iif set to the oif. These
> packets might be recirculated back as input and lookup to the raw
> sockets may fail because they are bound to the incoming interface
> (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
> returns rt_iif instead of skb_iif. Hence, the lookup fails.
> 
> v2: Make it non vrf specific (David Ahern). Reword the changelog to
>     reflect it.
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Applied and queued up for -stable, thanks.
