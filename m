Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094228D86B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfHNQtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:49:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfHNQtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:49:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88394154CC66D;
        Wed, 14 Aug 2019 09:49:39 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:49:39 -0400 (EDT)
Message-Id: <20190814.124939.490620650140226969.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v6 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812144537.14497-7-antoine.tenart@bootlin.com>
References: <20190812144537.14497-1-antoine.tenart@bootlin.com>
        <20190812144537.14497-7-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:49:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Mon, 12 Aug 2019 16:45:37 +0200

> This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
> switch for both PTP 1-step and 2-step modes.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Richard, I really need your review on this patch.

Thank you.
