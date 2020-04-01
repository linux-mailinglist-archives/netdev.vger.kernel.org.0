Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C3519A4A4
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 07:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgDAFSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 01:18:03 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52458 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbgDAFSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 01:18:03 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id F08A34409E2;
        Wed,  1 Apr 2020 08:18:01 +0300 (IDT)
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il> <8f4ecf61-ed50-9de6-f20a-0ade5f3dcb9a@gmail.com> <ae83f479-a3cf-30c9-68dc-45e27a5515f2@gmail.com>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Shmuel Hazan <sh@tkos.co.il>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
In-reply-to: <ae83f479-a3cf-30c9-68dc-45e27a5515f2@gmail.com>
Date:   Wed, 01 Apr 2020 08:18:01 +0300
Message-ID: <871rp7dbsm.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, Mar 31 2020, Florian Fainelli wrote:
> On 3/31/2020 11:16 AM, Heiner Kallweit wrote:
>> On 31.03.2020 19:47, Baruch Siach wrote:
>>> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
>>> bit is pulled up, the host must load firmware to the PHY after reset.
>>> Add support for loading firmware.
>>>
>>> Firmware files are available from Marvell under NDA.
>> 
>> Loading firmware files that are available under NDA only in GPL-licensed
>> code may be problematic. I'd expect firmware files to be available in
>> linux-firmware at least.
>> I'd be interested in how the other phylib maintainers see this.
>
> I second that, having the firmware available in linux-firmware is
> necessary for this code to be accepted.

That's your decision to make. In any case I'll post an updated version
of this patch with fixes for reference to anyone who needs this
functionality to make these PHYs work.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
