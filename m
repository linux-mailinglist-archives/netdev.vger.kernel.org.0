Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3915D4A5C40
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiBAM2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:28:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbiBAM2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:28:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0192F61524;
        Tue,  1 Feb 2022 12:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD77EC340EB;
        Tue,  1 Feb 2022 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643718462;
        bh=JbkAYC/M1v6wy+velggKtiIsj1hfd2OT5WgmxqSpRmo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MvrZsek1b6VXbur1sjrSrW9r5HERM81Yh71gmHzYA9DzrL4MGX45gsGNTkUS2FCCv
         Uk2LK0Ly8BTw9MdkDWc4CANUy0x8xK8FNWg81k3HA9UKjOvX1WLvFe8aEXIyUoE7HO
         zZQCBOKH1AV1a6C7Jw/xokCSENcxjaOIJ3glevudARnyyvtU2lD/EFlCVy0kDGicoH
         ke6CONaBXhJ+yYQ9hBO01aWYGgUG5sdtY2z7T+Sr8xJQGgdLRpGd1j7CSRuikONVLZ
         7CE1k1DuL0yLZeoo6CtFFia21ojZFhRFUaXQP0SxiPfyP2RaUR1q6Pu4ECPsrxZinZ
         iana8DFBgKVqQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220131160713.245637-2-marcan@marcan.st>
References: <20220131160713.245637-2-marcan@marcan.st>
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164371845418.16633.10070643455446160726.kvalo@kernel.org>
Date:   Tue,  1 Feb 2022 12:27:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:

> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
> the CLM blob is released in the device remove path.
> 
> Fixes: 82f93cf46d60 ("brcmfmac: get chip's default RAM info during PCIe setup")
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

8 patches applied to wireless-next.git, thanks.

5e90f0f3ead0 brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
d19d8e3ba256 brcmfmac: firmware: Allocate space for default boardrev in nvram
6d766d8cb505 brcmfmac: pcie: Declare missing firmware files in pcie.c
9466987f2467 brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
b50255c83b91 brcmfmac: pcie: Fix crashes due to early IRQs
9cf6d7f2c554 brcmfmac: of: Use devm_kstrdup for board_type & check for errors
e7191182adc5 brcmfmac: fwil: Constify iovar name arguments
b4bb8469e90e brcmfmac: pcie: Read the console on init and shutdown

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220131160713.245637-2-marcan@marcan.st/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

