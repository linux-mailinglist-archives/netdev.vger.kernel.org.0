Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0DB5C6F7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGBCM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:12:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBCM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:12:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1B8E14DE8844;
        Mon,  1 Jul 2019 19:12:27 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:12:27 -0700 (PDT)
Message-Id: <20190701.191227.1363312826504012690.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     Jason@zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: use 48 byte ctx instead of 6 signed longs for
 callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0092b0b405e02ac7401ceaad2ea650abc44559ea.camel@sipsolutions.net>
References: <20190628144022.31376-1-Jason@zx2c4.com>
        <0092b0b405e02ac7401ceaad2ea650abc44559ea.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:12:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Jun 2019 16:42:26 +0200

> On Fri, 2019-06-28 at 16:40 +0200, Jason A. Donenfeld wrote:
>> People are inclined to stuff random things into cb->args[n] because it
>> looks like an array of integers. Sometimes people even put u64s in there
>> with comments noting that a certain member takes up two slots. The
>> horror! Really this should mirror the usage of skb->cb, which are just
>> 48 opaque bytes suitable for casting a struct. Then people can create
>> their usual casting macros for accessing strongly typed members of a
>> struct.
>> 
>> As a plus, this also gives us the same amount of space on 32bit and 64bit.
>> 
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Applied to net-next.
