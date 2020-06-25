Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93F20A89C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407665AbgFYXMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403984AbgFYXMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:12:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBA1C08C5C1;
        Thu, 25 Jun 2020 16:12:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65E94153D60A3;
        Thu, 25 Jun 2020 16:12:07 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:12:06 -0700 (PDT)
Message-Id: <20200625.161206.1619464748667177222.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, lucien.xin@gmail.com,
        Michael.Tuexen@lurchi.franken.de, vyasevich@gmail.com,
        nhorman@tuxdriver.com, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, cminyard@mvista.com
Subject: Re: [PATCH net] sctp: Don't advertise IPv4 addresses if ipv6only
 is set on the socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
References: <20200623160417.12418-1-minyard@acm.org>
        <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:12:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 24 Jun 2020 17:34:18 -0300

> If a socket is set ipv6only, it will still send IPv4 addresses in the
> INIT and INIT_ACK packets. This potentially misleads the peer into using
> them, which then would cause association termination.
> 
> The fix is to not add IPv4 addresses to ipv6only sockets.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Corey Minyard <cminyard@mvista.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thank you.
