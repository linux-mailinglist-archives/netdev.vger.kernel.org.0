Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7F134DDE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgAHUsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:48:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgAHUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:48:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78ADE1584C8C6;
        Wed,  8 Jan 2020 12:48:00 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:48:00 -0800 (PST)
Message-Id: <20200108.124800.1070329260095359642.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net 0/2] When ungrafting from PRIO, replace child with
 FIFO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87eewcfoe0.fsf@mellanox.com>
References: <cover.1578333529.git.petrm@mellanox.com>
        <87eewcfoe0.fsf@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:48:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 6 Jan 2020 18:09:14 +0000

> Dave, when / if you decide to take this, note that it applies cleanly to
> net-next, however the code ends up being wrong and does not build. I put
> a patch with resolution here:
> 
>     https://github.com/jpirko/linux_mlxsw/commit/733d628ce37c38abab486c13a35b83da4b3ed161.patch
> 
> It's meant to be squashed to the merge commit.

Thanks, this will help me a lot when I do my next merge.
