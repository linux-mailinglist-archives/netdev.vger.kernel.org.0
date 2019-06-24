Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507AE51847
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfFXQUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:20:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFXQUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:20:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BADA1504D454;
        Mon, 24 Jun 2019 09:20:38 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:20:36 -0700 (PDT)
Message-Id: <20190624.092036.1996472048103001854.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ludovic.desroches@microchip.com,
        alexandre.belloni@bootlin.com
Subject: Re: [PATCH net-next] net: macb: use NAPI_POLL_WEIGHT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621152855.30330-1-antoine.tenart@bootlin.com>
References: <20190621152855.30330-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 09:20:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 21 Jun 2019 17:28:55 +0200

> Use NAPI_POLL_WEIGHT, the default NAPI poll() weight instead of
> redefining our own value (which turns out to be 64 as well).
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thanks.
