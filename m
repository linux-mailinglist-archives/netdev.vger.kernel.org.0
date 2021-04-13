Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1E835E1A3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbhDMOen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:34:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343956AbhDMOeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:34:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWK6s-00GU5e-Nq; Tue, 13 Apr 2021 16:33:46 +0200
Date:   Tue, 13 Apr 2021 16:33:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 5/5] net: phy: marvell: add support for Amethyst
 internal PHY
Message-ID: <YHWryrYS+h6E8+L4@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
 <20210413075538.30175-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413075538.30175-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  #define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_ONESHOT	(0x2 << 14)
>  #define MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE		(0x3 << 14)
>  #define MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK			(0x3 << 14)
> +#define MII_88E6393_MISC_TEST_SAMPLES_4096	0x0000
> +#define MII_88E6393_MISC_TEST_SAMPLES_8192	0x0800
> +#define MII_88E6393_MISC_TEST_SAMPLES_16384	0x1000
> +#define MII_88E6393_MISC_TEST_SAMPLES_32768	0x1800
> +#define MII_88E6393_MISC_TEST_SAMPLES_MASK	0x1800

Please represent these as (0x0 << 11), (0x1 << 11) etc. It makes it
easier to map it back to the datasheet which always talks about values
in bit fields, now the complete word.

> +#define MII_88E6393_MISC_TEST_RATE_2_3MS	0x0500
> +#define MII_88E6393_MISC_TEST_RATE_6_4MS	0x0600
> +#define MII_88E6393_MISC_TEST_RATE_11_9MS	0x0700
> +#define MII_88E6393_MISC_TEST_RATE_MASK		0x0700

Same here.

     Andrew
