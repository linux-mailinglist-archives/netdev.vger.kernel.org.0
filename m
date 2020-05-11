Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC7D1CE8D8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEKXJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgEKXJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:09:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A5BC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:09:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2472E1210BB6C;
        Mon, 11 May 2020 16:09:53 -0700 (PDT)
Date:   Mon, 11 May 2020 16:09:50 -0700 (PDT)
Message-Id: <20200511.160950.1210644073123836829.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7e8f6c9831244d2bb7c39f9aa4204e90@AcuMS.aculab.com>
References: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
        <20200511.134938.651986318503897703.davem@davemloft.net>
        <7e8f6c9831244d2bb7c39f9aa4204e90@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 16:09:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 11 May 2020 21:28:18 +0000

> In this case the "modified in userspace meanwhile" just breaks the
> application - it isn't any kind of security issue.

The kernel must provide correct behavior based upon the stable IP
header that it copies into userspace.  I'm not moving on this
requirement, sorry.

I'm sure you have great reasons why you can't use normal UDP sockets
for RTP traffic, but that's how you will get a cached route and avoid
this exact problem.
