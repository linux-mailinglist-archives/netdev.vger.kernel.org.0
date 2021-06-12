Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF093A4F0A
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 15:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFLNDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 09:03:08 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:43116 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230470AbhFLNDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 09:03:05 -0400
Date:   Sat, 12 Jun 2021 13:00:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1623502861;
        bh=pgwY2LSzrTH3x6cddXIr2d/PpxKxnWBnWbNdx+MeaIo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=R3EfeI/qLvB3XtNMyPPJGZ2lfAlWHHeOIMHnuhmolSn1ZjiPG9nmQbfF0qZ6QC0OO
         CjaEG9Z2rFmvy096uZGobcgSpGKvJw7Igs1lZFJ4U6qek2wPmXw9njdu4yMnPYH1uk
         /ztfBzM9NLGgXrDy1VQXgMcJuXOeUXbjz3ihwbDI=
To:     Kalle Valo <kvalo@codeaurora.org>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: Re: [PATCH] ath10k: demote chan info without scan request warning
Message-ID: <f39034ea-f4da-1564-e22f-398e4a1ae077@connolly.tech>
In-Reply-To: <20210612103640.2FD93C433F1@smtp.codeaurora.org>
References: <20210522171609.299611-1-caleb@connolly.tech> <20210612103640.2FD93C433F1@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On 12/06/2021 11:36 am, Kalle Valo wrote:
> Caleb Connolly <caleb@connolly.tech> wrote:
>
>> Some devices/firmwares cause this to be printed every 5-15 seconds,
>> though it has no impact on functionality. Demote this to a debug
>> message.
>>
>> Signed-off-by: Caleb Connolly <caleb@connolly.tech>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Is this meant to be an Ack?
>
> On what hardware and firmware version do you see this?
I see this on SDM845 and MSM8998 platforms, specifically the OnePlus 6
devices, PocoPhone F1 and OnePlus 5.
On the OnePlus 6 (SDM845) we are stuck with the following signed vendor fw:

[    9.339873] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214
chip_family 0x4001 board_id 0xff soc_id 0x40030001
[    9.339897] ath10k_snoc 18800000.wifi: qmi fw_version 0x20060029
fw_build_timestamp 2019-07-12 02:14 fw_build_id
QC_IMAGE_VERSION_STRING=3DWLAN.HL.2.0.c8-00041-QCAHLSWMTPLZ-1

The OnePlus 5 (MSM8998) is using firmware:

[ 6096.956799] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214
chip_family 0x4001 board_id 0xff soc_id 0x40010002
[ 6096.956824] ath10k_snoc 18800000.wifi: qmi fw_version 0x1007007e
fw_build_timestamp 2020-04-14 22:45 fw_build_id
QC_IMAGE_VERSION_STRING=3DWLAN.HL.1.0.c6-00126-QCAHLSWMTPLZ-1.211883.1.2786=
48.
>
> --
> https://patchwork.kernel.org/project/linux-wireless/patch/20210522171609.=
299611-1-caleb@connolly.tech/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
>

--
Kind Regards,
Caleb

