Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1748372A2B
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 14:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhEDMgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 08:36:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhEDMgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 08:36:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lduGY-002Tme-0l; Tue, 04 May 2021 14:35:06 +0200
Date:   Tue, 4 May 2021 14:35:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        'Michal Kubecek' <mkubecek@suse.cz>,
        'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool-next 2/4] ethtool: Refactor human-readable module
 EEPROM output
Message-ID: <YJE/etYozqB7GZaK@lunn.ch>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
 <1619162596-23846-3-git-send-email-moshe@nvidia.com>
 <008601d73e09$211d11e0$635735a0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008601d73e09$211d11e0$635735a0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Don

Please trim the text of the email when replying. Standard netiquette
best practices.

> > -#define PAG01H_UPPER_OFFSET			(0x01 * 0x80)
> > +#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
> > 
> >  /* Supported Link Length (Page 1) */
> > -#define QSFP_DD_SMF_LEN_OFFSET
> > 	(PAG01H_UPPER_OFFSET + 0x84)
> > -#define QSFP_DD_OM5_LEN_OFFSET
> > 	(PAG01H_UPPER_OFFSET + 0x85)
> > -#define QSFP_DD_OM4_LEN_OFFSET
> > 	(PAG01H_UPPER_OFFSET + 0x86)
> > -#define QSFP_DD_OM3_LEN_OFFSET
> > 	(PAG01H_UPPER_OFFSET + 0x87)
> > -#define QSFP_DD_OM2_LEN_OFFSET
> > 	(PAG01H_UPPER_OFFSET + 0x88)
> > +#define QSFP_DD_SMF_LEN_OFFSET			0x4
> > +#define QSFP_DD_OM5_LEN_OFFSET			0x5
> > +#define QSFP_DD_OM4_LEN_OFFSET			0x6
> > +#define QSFP_DD_OM3_LEN_OFFSET			0x7
> > +#define QSFP_DD_OM2_LEN_OFFSET			0x8
> 
> I see here you have switched from offsets from the beginning of flat linear
> memory to offsets within the upper half page.  I recommend actually using
> the values in the spec, which are offset from the base of the page.

I agree with this. Being able to easily map between spec and code is
important.

	Andrew
