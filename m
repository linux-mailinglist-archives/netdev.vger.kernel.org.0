Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F137191279
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgCXOIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:08:15 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:51229 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgCXOIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:08:15 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 32FBC100DA1C2;
        Tue, 24 Mar 2020 15:08:13 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BCC2A10D0C9; Tue, 24 Mar 2020 15:08:12 +0100 (CET)
Date:   Tue, 24 Mar 2020 15:08:12 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 14/14] net: ks8851: Remove ks8851_mll.c
Message-ID: <20200324140812.e4xv6eelquzmm3bs@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-15-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-15-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:43:03AM +0100, Marek Vasut wrote:
> The ks8851_mll.c is replaced by ks8851_par.c, which is using common code
> from ks8851.c, just like ks8851_spi.c . Remove this old ad-hoc driver.

Hm, have you checked whether ks8851_mll.c contains functionality
that is currently missing in ks8851.c and which is worth salvaging?

Thanks,

Lukas
