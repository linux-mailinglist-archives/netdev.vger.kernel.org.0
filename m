Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9747A9C5
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbfG3Ngd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:36:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfG3Ngd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RC6tIGwZC6KZ5xjgsAj/6/FxTVS/oIHkMk0TVJBI0t4=; b=NPTsPRllk0O6lF3vymU3DqlDO3
        jAkE+qu1eomwPDxkBAXbLqDioo7M326DnwK+lAbJb0FiukxRBEub7/HQpjJ5HAeruE4sU5NS4mVCp
        zU/RD11ZUSY57jZb3GWH7OQ5fr2eLTbbvkZZfTxYNSFbStJj9GRJpZDL5cX616tIArBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSIl-0007kn-Nf; Tue, 30 Jul 2019 15:36:27 +0200
Date:   Tue, 30 Jul 2019 15:36:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 1/4] net: dsa: mv88e6xxx: add support for MV88E6220
Message-ID: <20190730133627.GE28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-2-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-2-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:26PM +0200, Hubert Feurstein wrote:
> The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
> not routed to pins. So the usable ports are 0, 1, 5 and 6.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
>  drivers/net/dsa/mv88e6xxx/port.h |  1 +
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6b17cd961d06..c4982ced908e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -4283,6 +4283,31 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.ops = &mv88e6240_ops,
>  	},

Hi Hubert

We try to keep all these lists in strict numerical order. Please can
you add 6220 before 6240, in all the places you have added it.

    Thanks
	Andrew
