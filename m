Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B844F146581
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAWKSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:18:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:17:59 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 732CA153DA507;
        Thu, 23 Jan 2020 02:17:52 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:17:42 +0100 (CET)
Message-Id: <20200123.111742.1881735229122461538.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        pablo@netfilter.org, syzkaller@googlegroups.com
Subject: Re: [PATCH net] gtp: make sure only SOCK_DGRAM UDP sockets are
 accepted
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122071714.150259-1-edumazet@google.com>
References: <20200122071714.150259-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:17:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 21 Jan 2020 23:17:14 -0800

> A malicious user could use RAW sockets and fool
> GTP using them as standard SOCK_DGRAM UDP sockets.
 ...
> Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira <pablo@netfilter.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Also applied and queued up for -stable, thanks.
