Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD2D1702F2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgBZPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:44:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54434 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgBZPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:44:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id z12so3594645wmi.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 07:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WkuuApb4ooD9Lvo0SBfgUdLJhUHw9W2INI90sT56+1g=;
        b=AWOuQPCvIB4G8KyK5XFtllQXPmyHdiWK/acB2eEW6E/bSxZljeFMjk0M5p800sUHCv
         8tFkEpBnT4687LZYC8B/ZmMXspDff9tlHEuwiTpkgctHi1arXvL4ROtICv74KbU4fTmr
         TFI70LIyos94jE+W6JgIqNi9Vpe/zQUlMz7JXiLizL4YIa7w5jNvoXtA6mmxriTytzdy
         zq8S22FRbxP5wKaSWheGO/cmTcQ/5ruZ5axJWevvnpr9i1gvm5sTVYMovoEay4vgf3nN
         PT5IwjzsZQ6v2R9u9q6S8EZopcOf2GoVjgeddC2xDkDygnOSZb3y6Q6AaofK/Glt8A1N
         1ebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WkuuApb4ooD9Lvo0SBfgUdLJhUHw9W2INI90sT56+1g=;
        b=pf/yX8kZZdarnXHU5z15EvMkSAIvfk7r1oEzcl2h7wpnsU4YqK3ir4SS+4YFWIts5E
         ynfU9AA9SsbD+1qpD65Bxs6Vrv6c1doWaocxCwmRuJrVQ7Vztfo2dxUMW55DcL6ltu/4
         PQxZ97liF2qccv9QWFdEe/JwqduMV44N0AIfk7fxAruiXghJXfVkalNvAivX9+fyAkBa
         rjNiJfxkXRcJWyquNtQuZ9oJe1S/+UzsgG7slM56ZDbLM5VkFRhvc9kTr3Sn6v5+r6pi
         Dl/rWC9wtDtIpVYqg2njFaz1JDn2qe8pHcrf1Os0VRj0jZAQ3O6BdKxk2gfudiRBvuM/
         2Q9Q==
X-Gm-Message-State: APjAAAUpJXPe0fQh7T9QrpMaf8C+Ui91sjWWW+lIvDZGYJTeKM+/wZ1q
        VDgsJ9lDV0VZy2kC+FH+C80FWA==
X-Google-Smtp-Source: APXvYqyXuQa53EDL9x0a59GDmGb3ZTg7KHJHnHa92ubhBBCOC//HBukQGykTcbtVYG5VM9t1h7DVWA==
X-Received: by 2002:a1c:720a:: with SMTP id n10mr6176346wmc.103.1582731877236;
        Wed, 26 Feb 2020 07:44:37 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id w1sm3399610wmc.11.2020.02.26.07.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:44:36 -0800 (PST)
Date:   Wed, 26 Feb 2020 16:44:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200226154435.GB26061@nanopsycho>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:30:52PM CET, vadym.kochan@plvision.eu wrote:
>Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
>ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
>wireless SMB deployment.
>
>Prestera Switchdev is a firmware based driver which operates via PCI
>bus. The driver is split into 2 modules:
>
>    - prestera_sw.ko - main generic Switchdev Prestera ASIC related logic.
>
>    - prestera_pci.ko - bus specific code which also implements firmware

It is unusual to see ".ko" in patchset cover letter...


>                        loading and low-level messaging protocol between
>                        firmware and the switchdev driver.
>
>This driver implementation includes only L1 & basic L2 support.
>
>The core Prestera switching logic is implemented in prestera.c, there is
>an intermediate hw layer between core logic and firmware. It is
>implemented in prestera_hw.c, the purpose of it is to encapsulate hw
>related logic, in future there is a plan to support more devices with
>different HW related configurations.
>
>The firmware has to be loaded each time device is reset. The driver is
>loading it from:
>
>    /lib/firmware/marvell/prestera_fw_img.bin
>
>The firmware image version is located within internal header and consists
>of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has hard-coded
>minimum supported firmware version which it can work with:
>
>    MAJOR - reflects the support on ABI level between driver and loaded
>            firmware, this number should be the same for driver and
>            loaded firmware.
>
>    MINOR - this is the minimal supported version between driver and the
>            firmware.
>
>    PATCH - indicates only fixes, firmware ABI is not changed.
>

It is usual that the file name contains a version. I think it is
good to make sure you are loading the version your driver is compatible
with. There could be multiple versions for multiple kernels.


>The firmware image will be submitted to the linux-firmware after the
>driver is accepted.

Hmm, not sure how this works, shouldn't it be submitted there first?



>
>The following Switchdev features are supported:

You don't need to mention "Switchdev". It is just a offloading layer for
bridge. Does not mean anything else now...


>
>    - VLAN-aware bridge offloading
>    - VLAN-unaware bridge offloading
>    - FDB offloading (learning, ageing)
>    - Switchport configuration
>
>CPU RX/TX support will be provided in the next contribution.
>
>Vadym Kochan (3):
>  net: marvell: prestera: Add Switchdev driver for Prestera family ASIC
>    device 98DX325x (AC3x)
>  net: marvell: prestera: Add PCI interface support
>  dt-bindings: marvell,prestera: Add address mapping for Prestera
>    Switchdev PCIe driver
>
> .../bindings/net/marvell,prestera.txt         |   13 +
> drivers/net/ethernet/marvell/Kconfig          |    1 +
> drivers/net/ethernet/marvell/Makefile         |    1 +
> drivers/net/ethernet/marvell/prestera/Kconfig |   24 +
> .../net/ethernet/marvell/prestera/Makefile    |    5 +
> .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
> .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
> .../marvell/prestera/prestera_drv_ver.h       |   23 +
> .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
> .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
> .../ethernet/marvell/prestera/prestera_pci.c  |  840 +++++++++
> .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
> 12 files changed, 5123 insertions(+)
> create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
>
>-- 
>2.17.1
>
