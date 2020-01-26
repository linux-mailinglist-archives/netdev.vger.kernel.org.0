Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6188149BBD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 17:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAZQDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 11:03:53 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:13734 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgAZQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 11:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580054628;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2PNO1/c46RHFtyhHk/O9HQMuWsUZHHEAaOB0sL7r4Pw=;
        b=aRTRqD92HPjzkZ/TiMD0b5BsIvhqVPmo/g19reIU8agO73xmXNS2XcJkqEhDi3/nUE
        YNHKuBhv3Zs/TJlj/uYZEnQQQS+UudFMyb/gmt/ufLLmOQDuUVJkPpMzosZuPQ47FXoD
        4965sJJDBP2zMlywonqNuuYeS7lFa6glNiRAKxNk3OqHtONEVamj8Tq4s7U446SddqPZ
        Cwx2VdkUzK2WSlT4sIzDMch7x/MvhJtJCxvb63qSsE7Ku6PTqWOWH0uribxuvkkR7Krh
        /HjIvkOb4t6W9LHRorBs2UF7NijSbiJLu5NE3BQxJLPULfRYnwcuiuweFE4GXWzQeNLC
        /u8g==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrrwDuiNA=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.7 DYNA|AUTH)
        with ESMTPSA id k0645aw0QG3bETx
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sun, 26 Jan 2020 17:03:37 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: ***UNCHECKED*** Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti, power-gpio as optional
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200126153116.2E6E8C433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 17:03:36 +0100
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8FB64063-5DE1-4C13-8647-F3C5B0D3E999@goldelico.com>
References: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com> <20200126153116.2E6E8C433A2@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Am 26.01.2020 um 16:31 schrieb Kalle Valo <kvalo@codeaurora.org>:
>=20
> "H. Nikolaus Schaller" <hns@goldelico.com> wrote:
>=20
>> It is now only useful for SPI interface.
>> Power control of SDIO mode is done through mmc core.
>>=20
>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>> Acked-by: Rob Herring <robh@kernel.org>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>=20
> Failed to apply to wireless-drivers-next, please rebase and resend.

On which commit and/or tree do you want to apply it?

> fatal: sha1 information is lacking or useless =
(drivers/net/wireless/ti/wl1251/sdio.c).
> error: could not build fake ancestor
> Applying: wl1251: remove ti,power-gpio for SDIO mode
> Patch failed at 0001 wl1251: remove ti,power-gpio for SDIO mode
> The copy of the patch that failed is found in: .git/rebase-apply/patch
>=20
> 2 patches set to Changes Requested.
>=20
> 11298403 [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,power-gpio as =
optional
> 11298399 [v2,2/2] wl1251: remove ti,power-gpio for SDIO mode
>=20
> --=20
> https://patchwork.kernel.org/patch/11298403/
>=20
> =
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpat=
ches

BR and thanks,
Nikolaus Schaller

