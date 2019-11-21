Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E151047AD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfKUAl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:41:57 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40544 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfKUAl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:41:57 -0500
Received: by mail-lf1-f67.google.com with SMTP id v24so1082267lfi.7
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 16:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9a/7fGMMNS8/KWbgBFaFPQLcoptwh1r6lhKq50CN1G0=;
        b=hIn8TcQgTZYAlqZCu0dI5eyi9jb8NZTiDTzZHSdIbKpK/wCzKMuk4qQp7Z/mjnGcf3
         4BobXgaBLd2bdWH0GeBXEDOxEWjUgTWANiSLx8WRxrF3Dhx645PeLOm1vxEd3cmjY/i+
         NAbr8iegloW8w2CTFSzqMZdbkEr+orRKMH8fbvA+6JyqFfl2BkmeO0kuXXwop0pp93xA
         oUofq5MaaCFKtedhwcA1Hmqrnf8a8RCUxKv0RMvKPbOGQxvYKhtxBNbWNrZhMU26SYis
         rJLeUHrtw/bcrM/LImcoPL3+sa31PTCBLYJpMVtstVUD+hq+WzKVY/FT2emwOFRVRzhr
         mlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9a/7fGMMNS8/KWbgBFaFPQLcoptwh1r6lhKq50CN1G0=;
        b=cCg24DG7+SwbHAaVcu4A3AkNUC7YDgUs08MJ1vby1zDBOyPdBJV2UdUJZPB+IfxPnD
         NAIH3OWE3a8cS3OcfwJpQmGLITCNo2ltp9BEzFMnN09jnZQWlhKoqKNB15dqgdHuB/lZ
         mD5+D6U9Zuo2zX+DBHZ1HwPbM9CIYbMEXBtxlZJisYKaY6yonHe1eKwhh+v7LLdn2QTK
         GRT2IxJ2BxEk+JZpAwkBscimDUS+wbf8edQFKmWd6m+599ox2zim4hSaKA4v79SF82g9
         wrRubjOJ2tZpT7a6FF1M4jDwvjDqK9w4gLJSfVcxIEHMAJZQ5YZa5Y0D9Z3GmtyfxVrd
         RqwQ==
X-Gm-Message-State: APjAAAV99qg4Tt6uoa/9JWED9fwIFRDs8fjKUmUJS0z6PNyLbeea4m1P
        dPwEt5BQt7ZAiBwH0kmOZQ78wg==
X-Google-Smtp-Source: APXvYqwgETYq/jCkSe4GuG7JhVKmSzc+9kK44ApcyVRgIy0bE9DqH9jezgOKjMZ5JpGPbBShnUUExw==
X-Received: by 2002:ac2:59ce:: with SMTP id x14mr5350596lfn.49.1574296914663;
        Wed, 20 Nov 2019 16:41:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o26sm306235lfi.57.2019.11.20.16.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 16:41:54 -0800 (PST)
Date:   Wed, 20 Nov 2019 16:41:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 16/16] Documentation: net: octeontx2: Add RVU HW and
 drivers overview.
Message-ID: <20191120164137.6f66a560@cakuba.netronome.com>
In-Reply-To: <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 23:18:06 +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Added high level overview of OcteonTx2 RVU HW and functionality of
> various drivers which will be upstreamed.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Please double check this renders the way you expect. You may want to
add empty lines before lists.

> diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
> index c1f7f75..8aba64b 100644
> --- a/Documentation/networking/device_drivers/index.rst
> +++ b/Documentation/networking/device_drivers/index.rst
> @@ -22,6 +22,7 @@ Contents:
>     intel/iavf
>     intel/ice
>     google/gve
> +   marvell/octeontx2
>     mellanox/mlx5
>     netronome/nfp
>     pensando/ionic
> diff --git a/Documentation/networking/device_drivers/marvell/octeontx2.rst b/Documentation/networking/device_drivers/marvell/octeontx2.rst
> new file mode 100644
> index 0000000..c8a5150
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/marvell/octeontx2.rst
> @@ -0,0 +1,162 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +=============================================
> +Marvell OcteonTx2 RVU Kernel Drivers
> +=============================================

Shouldn't these lines be the length of the text?

> +
> +Copyright (c) 2019 Marvell International Ltd.
> +
> +Contents
> +========
> +
> +- `Overview`_
> +- `Drivers`_
> +- `Basic packet flow`_
> +
> +Overview
> +========
> +Resource virtualization unit (RVU) on Marvell's OcteonTX2 SOC maps HW
> +resources from the network, crypto and other functional blocks into
> +PCI-compatible physical and virtual functions. Each functional block
> +again has multiple local functions (LFs) for provisioning to PCI devices.
> +RVU supports multiple PCIe SRIOV physical functions (PFs) and virtual
> +functions (VFs). PF0 is called the administrative / admin function (AF)
> +and has privileges to provision RVU functional block's LFs to each of the
> +PF/VF.
> +
> +RVU managed networking functional blocks
> + - Network pool or buffer allocator (NPA)
> + - Network interface controller (NIX)
> + - Network parser CAM (NPC)
> + - Schedule/Synchronize/Order unit (SSO)
> + - Loopback interface (LBK)
> +
> +RVU managed non-networking functional blocks
> + - Crypto accelerator (CPT)
> + - Scheduled timers unit (TIM)
> + - Schedule/Synchronize/Order unit (SSO)
> +   Used for both networking and non networking usecases
> +
> +Resource provisioning examples
> + - A PF/VF with NIX-LF & NPA-LF resources works as a pure network device
> + - A PF/VF with CPT-LF resource works as a pure cyrpto offload device.

s/cyrpto/crypto/

> +
> +.. kernel-figure::  resource_virtualization_unit.svg
> +   :alt:	RVU
> +   :align:	center
> +   :figwidth:	60em
> +
> +   RVU HW block connectivity

The diagram isn't really bringing much value if you ask me. The text in
the last section is quite a bit better. Perhaps show packet flow?

> +RVU functional blocks are highly configurable as per software requirements.
> +
> +Firmware setups following stuff before kernel boots
> + - Enables required number of RVU PFs based on number of physical links.
> + - Number of VFs per PF are either static or configurable at compile time.

compile time of the firmware?

> +   Based on config, firmware assigns VFs to each of the PFs.
> + - Also assigns MSIX vectors to each of PF and VFs.
> + - These are not changed after kernel boot.

Can they be changed without FW rebuild?

> +Drivers
> +=======
> +
> +Linux kernel will have multiple drivers registering to different PF and VFs
> +of RVU. Wrt networking there will be 3 flavours of drivers.
> +
> +Admin Function driver
> +---------------------

> +Physical Function driver
> +------------------------

Thanks for the description, I was hoping you'd also provide more info
on how the software componets of the system fit together. Today we only
have an AF driver upstream. Without the PF or VF drivers the card is
pretty much unusable with only the upstream drivers, right?

There is a bunch of cgx_* exports in the AF module, which seem to have
no uses upstream, too (they are only called from rvu_cgx.c which is
compiled into the same module).

We'd like to see you build up a self-sufficient upstream-only solution,
and adding more and more code to the AF driver with unused exports
doesn't really inspire confidence this is the direction.
