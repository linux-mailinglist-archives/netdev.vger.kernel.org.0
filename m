Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192E55C760
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGBCfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:35:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBCfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:35:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5271C14DEC60D;
        Mon,  1 Jul 2019 19:35:17 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:35:16 -0700 (PDT)
Message-Id: <20190701.193516.551631803622082346.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, dja@axtens.net, mahesh@bandewar.net
Subject: Re: [PATCHv3 next 0/3] blackhole device to invalidate dst
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701213843.102002-1-maheshb@google.com>
References: <20190701213843.102002-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:35:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Mon,  1 Jul 2019 14:38:43 -0700

 ...
> The idea here is to not alter the data-path with additional
> locks or smb()/rmb() barriers to avoid racy assignments but
> to create a new device that has really low MTU that has
> .ndo_start_xmit essentially a kfree_skb(). Make use of this
> device instead of 'lo' when marking the dst dead.
> 
> First patch implements the blackhole device and second
> patch uses it in IPv4 and IPv6 stack while the third patch
> is the self test that ensures the sanity of this device.
 ...

Series applied to net-next, thanks.
