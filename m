Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F8719A89D
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 11:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgDAJ14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 05:27:56 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52514 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAJ14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 05:27:56 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 6800C440813;
        Wed,  1 Apr 2020 12:27:53 +0300 (IDT)
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il> <20200331180346.GS25745@shell.armlinux.org.uk> <874ku3dcki.fsf@tarshish> <1ad954a5-5cfc-caa3-5aca-0810223e5ac3@tkos.co.il> <d2017ccc-c85a-2e6d-4578-eaff530665fe@tkos.co.il>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>, "Shmuel H." <sh@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
In-reply-to: <d2017ccc-c85a-2e6d-4578-eaff530665fe@tkos.co.il>
Date:   Wed, 01 Apr 2020 12:27:53 +0300
Message-ID: <87wo6zblnq.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shmuel, Russell,

On Wed, Apr 01 2020, Shmuel H. wrote:
> On 01/04/2020 08:07, Shmuel H. wrote:
>> On 01/04/2020 08:01, Baruch Siach wrote:
>>> On Tue, Mar 31 2020, Russell King - ARM Linux admin wrote:
>>>> On Tue, Mar 31, 2020 at 08:47:38PM +0300, Baruch Siach wrote:
>>>>> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
>>>>> bit is pulled up, the host must load firmware to the PHY after reset.
>>>>> Add support for loading firmware.
>>>>>
>>>>> Firmware files are available from Marvell under NDA.
>>>> As I understand it, the firmware for the different revisions of the
>>>> 88x3310 are different, so I think the current derivation of filenames
>>>> is not correct.
>>> I was not aware of that.
>>>
>>> Shmuel, have you seen different firmware revisions from Marvell for 88x3310?
>> There are many firmware revisions, but I didn't see any mention of one
>> being compatible with a specific HW revision on the changelog / datasheets.
> Sorry,
> Apparently, Marvell do provide multiple firmware versions for the
> MVx3310 (REV A1, REV A0, latest).

I checked the Marvell website again. The text on the links leading to
firmware files appear to hint at different hardware revisions. But the
firmware release notes don't mention any hardware revision dependency.

Russell, have you seen any indication that the latest firmware file does
not support all current PHY revisions?

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
