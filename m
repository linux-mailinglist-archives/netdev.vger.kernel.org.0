Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133AD116704
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 07:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfLIGlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 01:41:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfLIGlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 01:41:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1F00153D7313;
        Sun,  8 Dec 2019 22:41:14 -0800 (PST)
Date:   Sun, 08 Dec 2019 22:41:12 -0800 (PST)
Message-Id: <20191208.224112.2234468529480733416.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     andrew.hendry@gmail.com, edumazet@google.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: add new state X25_STATE_5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3841dcf6dab454445da7b225e0d45212@dev.tdt.de>
References: <20191206133418.14075-1-ms@dev.tdt.de>
        <20191207.115922.532322440743611081.davem@davemloft.net>
        <3841dcf6dab454445da7b225e0d45212@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Dec 2019 22:41:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Mon, 09 Dec 2019 06:28:53 +0100

> On 2019-12-07 20:59, David Miller wrote:
>> From: Martin Schiller <ms@dev.tdt.de>
>> Date: Fri,  6 Dec 2019 14:34:18 +0100
>> 
>>> +	switch (frametype) {
>>> +
>>> +		case X25_CLEAR_REQUEST:
>> Please remove this unnecessary empty line.
>> 
>>> +			if (!pskb_may_pull(skb, X25_STD_MIN_LEN + 2))
>>> +				goto out_clear;
>> A goto path for a single call site?  Just inline the operations here.
> 
> Well, I was guided by the code style of the other states.
> I could add a patch to also clean up the other states.
> What do you think?

Leave the other states and existing code alone.

Make your new code reasonable.
