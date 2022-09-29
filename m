Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9FC5EEE55
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiI2HEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiI2HEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:25 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6DE131987
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:04:11 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lh5so831021ejb.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=d5cWEHp4FPuxbC+ChRAeF1CHpCFEFDxD9mJ2sCg0o1o=;
        b=BSX3+UNKE2j8Vx8FhBUoATgQVelpLxurXIQoKnXjD4Dhl+j2RN7lZTVff/j+75TdgI
         GzTtowDpuComrCo/BfsfI1FO575+mtMhGS1iuluM6Ojdo5nhYHo/kNObCtHWQHQ5udim
         5SxiewkfmawNsRI5JHkqqJoo7H/igPlPjfcFS7AMaDFrTpZI1vxzn6+n22CHaLqXKE9t
         BBazstTZIkZxOwogiJG6c47DrJ5jjPnE1f0h3FmPY+6bN3CNiyhop8qiDvlMQWivEGOI
         ZTHFlKx6Cls+c1qmSUMcEZStRLSWP/fiFMkyO3EEWZsa6jp+/au0vxDV6E2w36HMELiF
         fbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=d5cWEHp4FPuxbC+ChRAeF1CHpCFEFDxD9mJ2sCg0o1o=;
        b=QVyGcAl4+kSH2PjU8fk9gzcdMnIeFu4wHeIUxqgJXvY1GG/otGoJmXSSqPtxNpZbeQ
         2b7RQyvOMlGZWkqpCHXZJ4w2kOe8rHH5K0NAkwj4R8e7e1TUFUYmw5MkVJcSdInZL/aZ
         GpqbR2OPLuuEvGunRRbLfJlP0Ao1fZCIrJnR0K5vEKz/7LU4wAy4/B/v72R/CXXuuyNK
         xAxoU/FgGUwFUSFyhqV5sYEEa/4gyLpw2MadvwpMjIH5h82xvykStmG2RlsB+3lI0MJb
         6K598rF/g0d2MAQmN+I/IIxinzhgagEDPkQfXsVnHM9kysT/N6m1HHIcUIVvZQ7X9nlT
         n/Tw==
X-Gm-Message-State: ACrzQf0rkpuIxVkFXBXvjnosgdKknq+oTt+9pNQtMTft2DN/u6hejMsC
        iCxyXts+KE3isI54X+Tkd80aoA==
X-Google-Smtp-Source: AMsMyM5fa9Xa2tUqRXJuhcYA/+6KKcB+gt0Efh89vHUkgZ04yC+uPJmiFnj8CY6StWd+mRw+Zb4mhw==
X-Received: by 2002:a17:907:162a:b0:783:d11a:a553 with SMTP id hb42-20020a170907162a00b00783d11aa553mr1498203ejc.482.1664435049707;
        Thu, 29 Sep 2022 00:04:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l16-20020aa7d950000000b00456c9619ed8sm2105725eds.1.2022.09.29.00.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:04:08 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:04:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: PHY firmware update method
Message-ID: <YzVDZ4qrBnANEUpm@nanopsycho>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzQ96z73MneBIfvZ@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 28, 2022 at 02:28:27PM CEST, andrew@lunn.ch wrote:
>On Wed, Sep 28, 2022 at 01:27:13PM +0200, Michael Walle wrote:
>> Hi,
>> 
>> There are PHYs whose firmware can be updated. Usually, they have
>> an internal ROM and you can add patches on top of that, or there
>> might be an external flash device which can have a more recent
>> firmware version installed which can be programmed in-place
>> through the PHY.
>> 
>> The firmware update for a PHY is usually quite simple, but there
>> seems to be no infrastructure in the kernel for that. There is the
>> ETHTOOL_FLASHDEV ioctl for upgrading the firmware of a NIC it seems.
>> Other than that I haven't found anything. And before going in a wrong
>> directions I'd like to hear your thoughts on how to do it. I.e. how
>> should the interface to the userspace look like.
>> 
>> Also I think the PHY should be taken offline, similar to the cable
>> test.
>
>I've seen a few different ways of doing this.
>
>One is to load the firmware from disk every boot using
>request_firmware(). Then parse the header, determine if it is newer
>than what the PHY is already using, and if so, upgrade the PHY. If you
>do this during probe, it should be transparent, no user interaction
>required.
>
>I've also seen the FLASH made available as just another mtd
>device. User space can then write to it, and then do a {cold} boot.
>
>devlink has become the standard way for upgrading firmware on complex
>network devices, like NICs and TOR switches. That is probably a good
>solution here. The problem is, what devlink instance to use. Only a
>few MAC drivers are using devlink, so it is unlikely the MAC driver
>the PHY is attached to has a devlink instance. Do we create a devlink
>instance for the PHY?

Ccing Jakub. I don't think it is good idea to create a devlink instance
per-PHY. However, on the other hand, we have a devlink instance per
devlink linecard now. The devlink linecard however has devlink
representation, which PHY does not have.

Perhaps now is the time to dust-off my devlink components implementation
and use it for PHYs? IDF. Jakub, WDYT.


>
>You might want to talk to Jiri about this.
>
>The other issue is actually getting the firmware. Many manufactures
>seem reluctant to allow redistribution as required by linux-firmware.
>There is no point adding firmware upgrade if you cannot redistribute
>the firmware.
>
>    Andrew
