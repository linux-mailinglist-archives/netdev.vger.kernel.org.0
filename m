Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92093AD24
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfFJCoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:44:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFJCoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:44:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3688614EAD05A;
        Sun,  9 Jun 2019 19:44:20 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:44:19 -0700 (PDT)
Message-Id: <20190609.194419.1092823681840105677.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-06-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:44:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri,  7 Jun 2019 23:15:32 +0200

> this is a pull reqeust of 9 patches for net/master.
> 
> The first patch is by Alexander Dahl and removes a duplicate menu entry from
> the Kconfig. The next patch by Joakim Zhang fixes the timeout in the flexcan
> driver when setting small bit rates. Anssi Hannula's patch for the xilinx_can
> driver fixes the bittiming_const for CAN FD core. The two patches by Sean
> Nyekjaer bring mcp25625 to the existing mcp251x driver. The patch by Eugen
> Hristev implements an errata for the m_can driver. YueHaibing's patch fixes the
> error handling ing can_init(). The patch by Fabio Estevam for the flexcan
> driver removes an unneeded registration message during flexcan_probe(). And the
> last patch is by Willem de Bruijn and adds the missing purging the  socket
> error queue on sock destruct.

Pulled, thanks Marc.
