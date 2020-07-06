Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC4215F39
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGFTQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgGFTQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:16:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE802C061755;
        Mon,  6 Jul 2020 12:16:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2F151274B9CD;
        Mon,  6 Jul 2020 12:16:39 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:16:36 -0700 (PDT)
Message-Id: <20200706.121636.148338846008093922.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, madhuparnabhowmik04@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Fixed the value of
 hard_header_len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706004521.78091-1-xie.he.0141@gmail.com>
References: <20200706004521.78091-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:16:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Sun,  5 Jul 2020 17:45:21 -0700

> When this driver transmits data,
>   first this driver will remove a pseudo header of 1 byte,
>   then the lapb module will prepend the LAPB header of 2 or 3 bytes,
>   then this driver will prepend a length field of 2 bytes,
>   then the underlying Ethernet device will prepend its own header.
> 
> So, the header length required should be:
>   -1 + 3 + 2 + "the header length needed by the underlying device".
> 
> This patch fixes kernel panic when this driver is used with AF_PACKET
> SOCK_DGRAM sockets.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
