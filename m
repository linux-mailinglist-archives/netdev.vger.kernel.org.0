Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4016965C
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 07:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgBWGAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 01:00:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWGAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 01:00:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C4E71016E1F9;
        Sat, 22 Feb 2020 22:00:31 -0800 (PST)
Date:   Sat, 22 Feb 2020 22:00:30 -0800 (PST)
Message-Id: <20200222.220030.1329521446022083128.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net] net: genetlink: return the error code when
 attribute parsing fails.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <933cec10232417777c5a214e25a31d1f299d1489.1582310461.git.pabeni@redhat.com>
References: <933cec10232417777c5a214e25a31d1f299d1489.1582310461.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Feb 2020 22:00:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 21 Feb 2020 19:42:13 +0100

> Currently if attribute parsing fails and the genl family
> does not support parallel operation, the error code returned
> by __nlmsg_parse() is discarded by genl_family_rcv_msg_attrs_parse().
> 
> Be sure to report the error for all genl families.
> 
> Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> Fixes: ab5b526da048 ("net: genetlink: always allocate separate attrs for dumpit ops")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable.
