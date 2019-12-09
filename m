Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABF41173F0
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLISTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:19:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfLISTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:19:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 645451543AF08;
        Mon,  9 Dec 2019 10:19:09 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:19:08 -0800 (PST)
Message-Id: <20191209.101908.304423094932497092.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_router: Remove unlikely
 user-triggerable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209065520.337136-1-idosch@idosch.org>
References: <20191209065520.337136-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:19:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon,  9 Dec 2019 08:55:20 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> In case the driver vetoes the addition of an IPv6 multipath route, the
> IPv6 stack will emit delete notifications for the sibling routes that
> were already added to the FIB trie. Since these siblings are not present
> in hardware, a warning will be generated.
> 
> Have the driver ignore notifications for routes it does not have.
> 
> Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for v5.3 -stable, thanks.
