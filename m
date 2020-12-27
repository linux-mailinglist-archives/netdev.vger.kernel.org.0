Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8612E3298
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 20:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgL0Tff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 14:35:35 -0500
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:49160 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgL0Tff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 14:35:35 -0500
Received: from MTA-06-3.privateemail.com (mta-06.privateemail.com [68.65.122.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 0CF3C805A5
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 14:34:54 -0500 (EST)
Received: from MTA-06.privateemail.com (localhost [127.0.0.1])
        by MTA-06.privateemail.com (Postfix) with ESMTP id B8E2D6005C;
        Sun, 27 Dec 2020 14:34:12 -0500 (EST)
Received: from [192.168.0.46] (unknown [10.20.151.241])
        by MTA-06.privateemail.com (Postfix) with ESMTPA id 1A77B60059;
        Sun, 27 Dec 2020 19:34:11 +0000 (UTC)
Date:   Sun, 27 Dec 2020 14:34:05 -0500
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: Fwd: Solidrun ClearFog Base and Huawei MA5671A SFP
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Message-Id: <TOJ0MQ.ZNYLUGUM091D@effective-light.com>
In-Reply-To: <20201226222740.GE1551@shell.armlinux.org.uk>
References: <GXUYLQ.NU2JKDF3FRP51@effective-light.com>
        <8394f1c8-0b27-c1aa-37d4-77d65bdccade@gmail.com>
        <20201226222740.GE1551@shell.armlinux.org.uk>
X-Mailer: geary/3.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would it not be possible to disable dying gasp (assuming I can access 
the module using some other hardware)?

On Sat, Dec 26, 2020 at 10:27 pm, Russell King - ARM Linux admin 
<linux@armlinux.org.uk> wrote:
> Sorry, this will not work. The MA5671A modules are configured to use
> dying gasp on pin 7, and pin 7 is grounded on the Armada 388 Clearfog
> platforms, resulting in the module not booting.
> 
> I'm sorry, I can't recommend a module; I don't use SFP GPON modules
> myself.
> 
> On Sat, Dec 26, 2020 at 11:15:18PM +0100, Heiner Kallweit wrote:
>>  Sounds like something where you may be able to help.
>> 
>>  Heiner
>> 
>>  -------- Forwarded Message --------
>>  Subject: Solidrun ClearFog Base and Huawei MA5671A SFP
>>  Date: Sat, 26 Dec 2020 16:41:40 -0500
>>  From: Hamza Mahfooz <someguy@effective-light.com>
>>  To: netdev@vger.kernel.org
>> 
>>  Hey, has anyone got the ClearFog (ARMADA 388 SoC) to work with the
>>  MA5671A? I've to been trying to get the ClearFog to read the 
>> MA5671A's
>>  EEPROM however it always throws the following error:
>> 
>>  > # dmesg | grep sfp
>>  > [ 4.550651] sfp sfp: Host maximum power 2.0W
>>  > [ 5.875047] sfp sfp: please wait, module slow to respond
>>  > [ 61.295045] sfp sfp: failed to read EEPROM: -6
>> 
>>  I've tried to increase the retry timeout in `/drivers/net/phy/sfp.c`
>>  (i.e. T_PROBE_RETRY_SLOW) so far, any suggestions would be 
>> appreciated.
>>  Also, I'm on kernel version 5.9.13.
>> 
>> 
>> 
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


