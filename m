Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4837133DD
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 21:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfECTHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 15:07:35 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:14192 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfECTHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 15:07:34 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 0A3B13233;
        Fri,  3 May 2019 21:07:32 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 064ad94e;
        Fri, 3 May 2019 21:07:30 +0200 (CEST)
Date:   Fri, 3 May 2019 21:07:30 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 08/10] staging: octeon-ethernet: support
 of_get_mac_address new ERR_PTR error
Message-ID: <20190503190730.GH71477@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
 <1556870168-26864-9-git-send-email-ynezz@true.cz>
 <20190503103456.GF2269@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503103456.GF2269@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> [2019-05-03 13:34:56]:

Hi,

> On Fri, May 03, 2019 at 09:56:05AM +0200, Petr Štetiar wrote:
> > There was NVMEM support added to of_get_mac_address, so it could now
> > return NULL and ERR_PTR encoded error values, so we need to adjust all
> > current users of of_get_mac_address to this new fact.
> 
> Which commit added NVMEM support?  It hasn't hit net-next or linux-next
> yet...  Very strange.

this patch is a part of the patch series[1], where the 1st patch[2] adds this
NVMEM support to of_get_mac_address and follow-up patches are adjusting
current of_get_mac_address users to the new ERR_PTR return value.

> Why would of_get_mac_address() return a mix of NULL and error pointers?

I've introduced this misleading API in v3, but corrected it in v4, so it now
returns only valid pointer or ERR_PTR encoded error value.

Just FYI, changes for staging/octeon are currently at v5[3].

1. https://patchwork.ozlabs.org/project/netdev/list/?series=105972
2. https://patchwork.ozlabs.org/patch/1094916/
3. https://patchwork.ozlabs.org/patch/1094942/

-- ynezz
