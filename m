Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F7117D892
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgCIEW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:22:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIEW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:22:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53584158B582F;
        Sun,  8 Mar 2020 21:22:57 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:22:56 -0700 (PDT)
Message-Id: <20200308.212256.639211299362051258.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, martinvarghesenokia@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] bareudp: several code cleanup for bareudp
 module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308011849.6672-1-ap420073@gmail.com>
References: <20200308011849.6672-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:22:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sun,  8 Mar 2020 01:18:49 +0000

> This patchset is to cleanup bareudp module code.
> 
> 1. The first patch is to add module alias
> In the current bareudp code, there is no module alias.
> So, RTNL couldn't load bareudp module automatically.
> 
> 2. The second patch is to add extack message.
> The extack error message is useful for noticing specific errors
> when command is failed.
> 
> 3. The third patch is to remove unnecessary udp_encap_enable().
> In the bareudp_socket_create(), udp_encap_enable() is called.
> But, the it's already called in the setup_udp_tunnel_sock().
> So, it could be removed.

Series applied, thanks.
