Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE81AAB15
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371166AbgDOO4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:56:32 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:37943 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371093AbgDOO4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:56:23 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 2A021100BE798;
        Wed, 15 Apr 2020 16:56:21 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B5C5E11B185; Wed, 15 Apr 2020 16:56:20 +0200 (CEST)
Date:   Wed, 15 Apr 2020 16:56:20 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 17/19] net: ks8851: Separate SPI operations into
 separate file
Message-ID: <20200415145620.43mhdpqak7e36p23@wunner.de>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-18-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414182029.183594-18-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:20:27PM +0200, Marek Vasut wrote:
> +static void __maybe_unused ks8851_done_tx(struct ks8851_net *ks,

If I'm not mistaken, the __maybe_unused is unnecessary here.
Was added in v3.


> +#endif

A "/* __KS8851_H__ */" comment here would be nice.

Thanks,

Lukas
