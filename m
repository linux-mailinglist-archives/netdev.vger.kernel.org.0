Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE931F3236
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgFICLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgFICLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:11:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFCFC03E969;
        Mon,  8 Jun 2020 19:11:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A060128A6AE4;
        Mon,  8 Jun 2020 19:11:09 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:11:08 -0700 (PDT)
Message-Id: <20200608.191108.1901661787245617914.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, pabeni@redhat.com, peter.krystad@linux.intel.com,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] mptcp: bugfix for RM_ADDR option parsing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5ec9759a19d4eba5f7f9006354da2cfeb39fa839.1591612830.git.geliangtang@gmail.com>
References: <5ec9759a19d4eba5f7f9006354da2cfeb39fa839.1591612830.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:11:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Mon,  8 Jun 2020 18:47:54 +0800

> In MPTCPOPT_RM_ADDR option parsing, the pointer "ptr" pointed to the
> "Subtype" octet, the pointer "ptr+1" pointed to the "Address ID" octet:
> 
>   +-------+-------+---------------+
>   |Subtype|(resvd)|   Address ID  |
>   +-------+-------+---------------+
>   |               |
>  ptr            ptr+1
> 
> We should set mp_opt->rm_id to the value of "ptr+1", not "ptr". This patch
> will fix this bug.
> 
> Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  Changes in v2:
>   - Add "-net" subject and "Fixes" tag as Matt suggested.

Applied and queued up for v5.7 -stable, thanks!
