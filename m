Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18E6149CA2
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgAZT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:59:48 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:23807 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZT7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580068786;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=7eEvDm1iNo2636JssuRLJw4y+Cbk2kdvSN2z9mnSGN4=;
        b=NUwScCdM2vibQTdhvfrAxu045vpk5lLCJvH4BL/HZFo+Ei+fI+IsExGoQ8+ivXwbg/
        8RnWOW4qsRkD8I3ySfgmiv9SskYBsYewuc2DzLt81sY1K8/tF+jnFpcvr0YJzw3wY3o+
        VgwnQGlvQgv4XmAbENOxFcRS2dfYcUS+mhHuibkL8MdheqwUpYoc1I7eenpD3fTOZw5p
        oDGhi5dCOkxlc2DLvOKbeuMGBxqBFnw22amt3iNXgJYTPaImGYgoAd19FdNU4ugfNXlc
        Q5+iJQbXX5zRaJYl4DOLCrHYv9urpbDzZNQ6ZEhHwShzS5GAuYdMqFaF4F3JDn+ZrxKm
        DFtA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrrwDuiNA=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.7 DYNA|AUTH)
        with ESMTPSA id k0645aw0QJxYF28
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sun, 26 Jan 2020 20:59:34 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: ***UNCHECKED*** Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti, power-gpio as optional
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <87ftg2chwh.fsf@kamboji.qca.qualcomm.com>
Date:   Sun, 26 Jan 2020 20:59:34 +0100
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
Message-Id: <74D71976-B2C8-4B4A-AF9A-F32A42BA72D8@goldelico.com>
References: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com> <20200126153116.2E6E8C433A2@smtp.codeaurora.org> <8FB64063-5DE1-4C13-8647-F3C5B0D3E999@goldelico.com> <87ftg2chwh.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

> Am 26.01.2020 um 17:16 schrieb Kalle Valo <kvalo@codeaurora.org>:
>=20
> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
>=20
>> Hi,
>>=20
>>> Am 26.01.2020 um 16:31 schrieb Kalle Valo <kvalo@codeaurora.org>:
>>>=20
>>> "H. Nikolaus Schaller" <hns@goldelico.com> wrote:
>>>=20
>>>> It is now only useful for SPI interface.
>>>> Power control of SDIO mode is done through mmc core.
>>>>=20
>>>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>>>> Acked-by: Rob Herring <robh@kernel.org>
>>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>>=20
>>> Failed to apply to wireless-drivers-next, please rebase and resend.
>>=20
>> On which commit and/or tree do you want to apply it?
>=20
> I said it above, wireless-drivers-next:
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-nex=
t.git/

Ah, sorry. I did overlook it.

I could easily cherry pick it so I think that the guard lines of the =
original submission did not match.

v3 (rebased on tag wireless-drivers-next-2020-01-26) coming immediately.

BR and thanks,
Nikolaus

