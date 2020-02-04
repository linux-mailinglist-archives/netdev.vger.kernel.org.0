Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9461519DF
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBDLao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:30:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgBDLao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:30:44 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E28C1133A87CE;
        Tue,  4 Feb 2020 03:30:42 -0800 (PST)
Date:   Tue, 04 Feb 2020 12:30:41 +0100 (CET)
Message-Id: <20200204.123041.1506575968362096923.davem@davemloft.net>
To:     raeds@mellanox.com
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
References: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 03:30:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>
Date: Sun,  2 Feb 2020 13:22:52 +0200

> This patch to handle the asynchronous unregister
> device event so the device tls offload resources
> could be cleanly released.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

As per Jakub's feedback, only devices which are UP can have TLS
rules installed to them.

Therefore we will always get the NETDEV_DOWN event first, to release
the TLS resources.

So I am tossing this patch.  If there is a real problem, you must
describe it in detail in the commit message.
