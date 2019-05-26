Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831342AC0B
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfEZUXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:23:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfEZUXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 16:23:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A81B3140ADA7D;
        Sun, 26 May 2019 13:23:35 -0700 (PDT)
Date:   Sun, 26 May 2019 13:23:35 -0700 (PDT)
Message-Id: <20190526.132335.1937144810229440950.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     paul.burton@mips.com, ralf@linux-mips.org, jhogan@kernel.org,
        robh+dt@kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        mark.rutland@arm.com, kernel@pengutronix.de,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, nbd@nbd.name,
        netdev@vger.kernel.org, andrew@lunn.ch, gch981213@gmail.com,
        info@freifunk-bad-gandersheim.net
Subject: Re: [PATCH v6 0/3] MIPS: ath79: add ag71xx support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524111224.24819-1-o.rempel@pengutronix.de>
References: <20190524111224.24819-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 13:23:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 24 May 2019 13:12:21 +0200

 ...
> This patch series provide ethernet support for many Atheros/QCA
> MIPS based SoCs.
> 
> I reworked ag71xx driver which was previously maintained within OpenWRT
> repository. So far, following changes was made to make upstreaming
> easier:
> - everything what can be some how used in user space was removed. Most
>   of it was debug functionality.
> - most of deficetree bindings was removed. Not every thing made sense
>   and most of it is SoC specific, so it is possible to detect it by
>   compatible.
> - mac and mdio parts are merged in to one driver. It makes easier to
>   maintaine SoC specific quirks.

Series applied, thanks.
