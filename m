Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4223616332A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgBRUfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:35:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRUfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:35:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C843712357E95;
        Tue, 18 Feb 2020 12:35:46 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:35:46 -0800 (PST)
Message-Id: <20200218.123546.666027846950664712.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     zbr@ioremap.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218163030.GR24152@zorba>
References: <20200217175209.GM24152@zorba>
        <20200217.185235.495219494110132658.davem@davemloft.net>
        <20200218163030.GR24152@zorba>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:35:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
Date: Tue, 18 Feb 2020 16:30:36 +0000

> It's multicast and essentially broadcast messages .. So everyone gets every
> message, and once it's on it's likely it won't be turned off. Given that, It seems
> appropriate that the system administrator has control of what messages if any
> are sent, and it should effect all listening for messages.
> 
> I think I would agree with you if this was unicast, and each listener could tailor
> what messages they want to get. However, this interface isn't that, and it would
> be considerable work to convert to that.

You filter at recvmsg() on the specific socket, multicast or not, I
don't understand what the issue is.
