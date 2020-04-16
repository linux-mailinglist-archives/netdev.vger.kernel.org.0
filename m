Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C891AC70C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394730AbgDPOsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:48:31 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51355 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394701AbgDPOsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 10:48:22 -0400
Received: from tarshish (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 94C084408B0;
        Thu, 16 Apr 2020 17:48:20 +0300 (IDT)
References: <1eca8c654679764a64252072509ddc1bf59938a0.1587047556.git.baruch@tkos.co.il> <20200416143858.GO657811@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH] net: phy: marvell10g: disable temperature sensor on 2110
In-reply-to: <20200416143858.GO657811@lunn.ch>
Date:   Thu, 16 Apr 2020 17:48:20 +0300
Message-ID: <87v9lzcwqz.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Apr 16 2020, Andrew Lunn wrote:
> On Thu, Apr 16, 2020 at 05:32:36PM +0300, Baruch Siach wrote:
>> The 88E2110 temperature sensor is in a different location than 88X3310,
>> and it has no enable/disable option.
>
> Hi Buruch
>
> How easy would it be to support the new location? These things can get
> warm, specially if there is no heat sink attached. So it would be nice
> to support it, if possible.

Adding support should not be too hard. I might find some time to work on
this in the next few days.

I think this patch should go to -stable, so it is useful on its
own. Support for 2110 hwmon sensor is net-next material.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
