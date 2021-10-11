Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15AD42931A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhJKP05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhJKP04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 11:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041BA60EB4;
        Mon, 11 Oct 2021 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633965896;
        bh=QICPWRWgKBNfltV/grWstV9POfgX0CqukNbyle4Lpt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EKKpOUSLK4V340SQWmwdK1Nm2zfrhVtQ6br0uA5XHvTBoo6ZblN1drRWoIZk15n/x
         5nt8E5q/Ft9Q2v09AEZ0PhJElfIFujBrkXs4PIPY1MMlzHZev2X1mYfrm2AkJhTtqU
         PtNONmA4GYu5zUO037WWNmgP1Jxp98u0ywjPTfClOo9wCAOTe0C2iIzEqyPGbD5KsR
         4blAoZD/VuQU4FWKE2uCcCHmveH3d8JYoyMk229dB0DaWmuVQYmRrgUSJz65drzgwl
         ConipSloZhcvu/Cji0a8c6PZVTZixwMgFEdBLdgD8Zkadth9XT79NhlJQ4bv9JvTcH
         W5mc19JlAQWPw==
Date:   Mon, 11 Oct 2021 08:24:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alexandru.tachici@analog.com>
Cc:     <andrew@lunn.ch>, <o.rempel@pengutronix.de>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v3 4/8] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20211011082455.52c5532e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011142215.9013-5-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
        <20211011142215.9013-5-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 17:22:11 +0300 alexandru.tachici@analog.com wrote:
> +/**
> + * struct adin_priv - ADIN PHY driver private data
> + * tx_level_2v4_able		set if the PHY supports 2.4V TX levels (10BASE-T1L)
> + * tx_level_2v4			set if the PHY requests 2.4V TX levels (10BASE-T1L)
> + * tx_level_prop_present	set if the TX level is specified in DT
> + */

This is not correct kdoc format. Should be

 * @member:	description

scripts/kernel-doc -none is your friend:

drivers/net/phy/adin1100.c:44: warning: Function parameter or member 'tx_level_2v4_able' not described in 'adin_priv'
drivers/net/phy/adin1100.c:44: warning: Function parameter or member 'tx_level_2v4' not described in 'adin_priv'
drivers/net/phy/adin1100.c:44: warning: Function parameter or member 'tx_level_prop_present' not described in 'adin_priv'
