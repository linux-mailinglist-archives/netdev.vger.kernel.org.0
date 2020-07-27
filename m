Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF422F907
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgG0T1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgG0T1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:27:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B067EC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:27:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3408F1276833A;
        Mon, 27 Jul 2020 12:10:29 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:27:13 -0700 (PDT)
Message-Id: <20200727.122713.1004169793309015068.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 00/16] sfc: driver for EF100 family NICs,
 part 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:10:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 27 Jul 2020 12:53:54 +0100

> EF100 is a new NIC architecture under development at Xilinx, based
>  partly on existing Solarflare technology.  As many of the hardware
>  interfaces resemble EF10, support is implemented within the 'sfc'
>  driver, which previous patch series "commonised" for this purpose.
> 
> In order to maintain bisectability while splitting into patches of a
>  reasonable size, I had to do a certain amount of back-and-forth with
>  stubs for things that the common code may try to call, mainly because
>  we can't do them until we've set up MCDI, but we can't set up MCDI
>  without probing the event queues, at which point a lot of the common
>  machinery becomes reachable from event handlers.
> Consequently, this first series doesn't get as far as actually sending
>  and receiving packets.  I have a second series ready to follow it
>  which implements the datapath (and a few other things like ethtool).
 ...

Series applied, thank you.
