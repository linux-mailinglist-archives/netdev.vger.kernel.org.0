Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C09517CB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbfFXP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:58:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfFXP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:57:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BDA715049FD1;
        Mon, 24 Jun 2019 08:57:59 -0700 (PDT)
Date:   Mon, 24 Jun 2019 08:57:58 -0700 (PDT)
Message-Id: <20190624.085758.654339729118496029.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ludovic.desroches@microchip.com,
        alexandre.belloni@bootlin.com
Subject: Re: [PATCH net] net: macb: do not copy the mac address if NULL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621152635.29689-1-antoine.tenart@bootlin.com>
References: <20190621152635.29689-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 08:57:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 21 Jun 2019 17:26:35 +0200

> This patch fixes the MAC address setup in the probe. The MAC address
> retrieved using of_get_mac_address was checked for not containing an
> error, but it may also be NULL which wasn't tested. Fix it by replacing
> IS_ERR with IS_ERR_OR_NULL.
> 
> Fixes: 541ddc66d665 ("net: macb: support of_get_mac_address new ERR_PTR error")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thanks.

