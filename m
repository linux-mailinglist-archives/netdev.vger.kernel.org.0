Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D47CF3C04
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfKGXPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:15:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:15:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28CAA1536A2A0;
        Thu,  7 Nov 2019 15:15:21 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:15:20 -0800 (PST)
Message-Id: <20191107.151520.40532955188357316.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     claudiu.manoil@nxp.com, sjarugum@cisco.com,
        xe-linux-external@cisco.com, dwalker@fifo99.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: gianfar: Shortest frame drops at
 Ethernet port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106170320.27662-1-danielwa@cisco.com>
References: <20191106170320.27662-1-danielwa@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:15:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Walker <danielwa@cisco.com>
Date: Wed,  6 Nov 2019 09:03:20 -0800

> NXP has provided the patch for packet drops  at ethernet port
> Frames shorter than 60bytes are getting dropped at ethernetport
> need to add padding for the shorter range frames to be transmit
> the function "eth_skb_pad(skb" provides padding (and CRC) for
> packets under 60 bytes
> 
> Signed-off-by: Sathish Jarugumalli <sjarugum@cisco.com>
> Cc: xe-linux-external@cisco.com
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>

Please repost with an appropriate Fixes: tag.

Thank you.
