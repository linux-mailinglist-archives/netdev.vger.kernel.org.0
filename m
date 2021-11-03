Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0629444097
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhKCL3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:29:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45942 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhKCL3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 07:29:54 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D71022191C;
        Wed,  3 Nov 2021 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635938836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tHDQTPPlwCBAfRJ/hGFL2abVzTPFrE2eh29ZrCMP+eo=;
        b=zgN6OeaJMiUC71gW8J3hYQmmu98d2zj6I18FMXfCe4igQpLSMpZVJ55RrmVufK3f0itps0
        ieGtgAgFh97DC4dzfBhYoGi+62uGJUMV9xB37jhWkhJyNcCaqw6T9P5X4z6mlO29+v8+0/
        6ixTmeaPCa+GhjZ56uR5J7Ttg8KKRpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635938836;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tHDQTPPlwCBAfRJ/hGFL2abVzTPFrE2eh29ZrCMP+eo=;
        b=zlJfnthIOJPrejOKglZy+LPazj7KEMSF2GIQQH12rYNR/q5COlwhfvPTtBnEz8TViuWyDH
        zMtRZdbRck8AO/Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47DBC13DC1;
        Wed,  3 Nov 2021 11:27:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B1ipDhRygmGCMwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 03 Nov 2021 11:27:16 +0000
Subject: Re: [PATCH 0/2] This is a patch series of ethernet driver for Sunplus
 SP7021 SoC.
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <588dea1c-db2e-8e6c-d559-3ba53b0ae820@suse.de>
Date:   Wed, 3 Nov 2021 14:27:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/3/21 2:02 PM, Wells Lu пишет:
> Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
> many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
> etc.) into a single chip. It is designed for industrial control
> applications.

The series should pe prefixes with net-next

> 
> Refer to:
> https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
> https://tibbo.com/store/plus1.html
> 
> Wells Lu (2):
>    devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
>    net: ethernet: Add driver for Sunplus SP7021
> 
>   .../bindings/net/sunplus,sp7021-l2sw.yaml          | 123 ++++
>   MAINTAINERS                                        |   8 +
>   drivers/net/ethernet/Kconfig                       |   1 +
>   drivers/net/ethernet/Makefile                      |   1 +
>   drivers/net/ethernet/sunplus/Kconfig               |  20 +
>   drivers/net/ethernet/sunplus/Makefile              |   6 +
>   drivers/net/ethernet/sunplus/l2sw_define.h         | 221 ++++++
>   drivers/net/ethernet/sunplus/l2sw_desc.c           | 233 ++++++
>   drivers/net/ethernet/sunplus/l2sw_desc.h           |  21 +
>   drivers/net/ethernet/sunplus/l2sw_driver.c         | 779 +++++++++++++++++++++
>   drivers/net/ethernet/sunplus/l2sw_driver.h         |  23 +
>   drivers/net/ethernet/sunplus/l2sw_hal.c            | 422 +++++++++++
>   drivers/net/ethernet/sunplus/l2sw_hal.h            |  47 ++
>   drivers/net/ethernet/sunplus/l2sw_int.c            | 326 +++++++++
>   drivers/net/ethernet/sunplus/l2sw_int.h            |  16 +
>   drivers/net/ethernet/sunplus/l2sw_mac.c            |  68 ++
>   drivers/net/ethernet/sunplus/l2sw_mac.h            |  24 +
>   drivers/net/ethernet/sunplus/l2sw_mdio.c           | 118 ++++
>   drivers/net/ethernet/sunplus/l2sw_mdio.h           |  19 +
>   drivers/net/ethernet/sunplus/l2sw_register.h       |  99 +++
>   20 files changed, 2575 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
>   create mode 100644 drivers/net/ethernet/sunplus/Kconfig
>   create mode 100644 drivers/net/ethernet/sunplus/Makefile
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_define.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_register.h
> 
