Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C881076EE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:06:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKVSG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:06:58 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDB1C152828CA;
        Fri, 22 Nov 2019 10:06:57 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:06:57 -0800 (PST)
Message-Id: <20191122.100657.2043691592550032738.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH 1/3] net: inet_is_local_reserved_port() should return
 bool not int
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122072102.248636-1-zenczykowski@gmail.com>
References: <20191122072102.248636-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 10:06:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej, please repost this series with a proper introduction "[PATCH 0/3]" posting
so that I know what this series does at a high level, how it is doing it, and why
it is doing it that way.

That also gives me a single email to reply to when I apply your series instead of
having to respond to each and every one, which is more work, and error prone for
me.

Thanks.
