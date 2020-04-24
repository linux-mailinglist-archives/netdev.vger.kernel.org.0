Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003F1B827E
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgDXXl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXXl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:41:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64F1C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:41:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9484F14F36391;
        Fri, 24 Apr 2020 16:41:56 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:41:53 -0700 (PDT)
Message-Id: <20200424.164153.1118176286557922062.davem@davemloft.net>
To:     mao-linux@maojianwei.com
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, dave.taht@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net-next v2] net: ipv6: support Application-aware IPv6
 Network (APN6)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a9a64f23-ed11-4b8d-b7be-75c686ad87fb.mao-linux@maojianwei.com>
References: <49178de1-75cc-4736-b572-1530a0d5fccf.mao-linux@maojianwei.com>
        <a9a64f23-ed11-4b8d-b7be-75c686ad87fb.mao-linux@maojianwei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:41:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jianwei Mao (Mao)" <mao-linux@maojianwei.com>
Date: Wed, 22 Apr 2020 17:43:03 +0800

> After that, network can provide specific performance for Apps, such as,
> low-lattency for online Games, low-jitter for industrial control,
> enough-bandwidth for video conference/remote medical system, etc.

This sounds like a feature that would allow governments to track users
and their activities without their consent.

I'm really not a big fan of this kind of technology and therefore I
think I'm going to pass on this patch for now.

Sorry.
