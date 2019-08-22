Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30363989CC
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfHVDZn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 23:25:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37610 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHVDZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:25:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94B3314FD1E53;
        Wed, 21 Aug 2019 20:25:42 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:25:42 -0700 (PDT)
Message-Id: <20190821.202542.800433879227385529.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next 01/10] net: dsa: mv88e6xxx: support 2500base-x
 in SGMII IRQ handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821232724.1544-2-marek.behun@nic.cz>
References: <20190821232724.1544-1-marek.behun@nic.cz>
        <20190821232724.1544-2-marek.behun@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:25:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>
Date: Thu, 22 Aug 2019 01:27:15 +0200

> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 20c526c2a9ee..0f3d7cbb696b 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -506,9 +506,11 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
>  					    int port, int lane)
>  {
>  	struct dsa_switch *ds = chip->ds;
> +	u8 cmode = chip->ports[port].cmode;
>  	int duplex = DUPLEX_UNKNOWN;
>  	int speed = SPEED_UNKNOWN;
>  	int link, err;
> +	phy_interface_t mode;
>  	u16 status;

Please retain the reverse christmas tree ordering of local variables here.

Thank you.
