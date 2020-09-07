Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4525F69C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgIGJgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgIGJgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 05:36:49 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D92C061573;
        Mon,  7 Sep 2020 02:36:48 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x14so13057045oic.9;
        Mon, 07 Sep 2020 02:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cePeFxPoNoJDCzd23ACFb/6BsCv5I8F1VVlSAM3tueA=;
        b=g5VzGNKZucVFsp84RldxQxOHa4zEu5HC8WL4QO7gTYaQZuxJ7dxHKpUZUYhqoAjjEx
         I4KFXrXsr/tf/L/TakL0e+dbzZjW+OYy570Ec0DtRgXYHtmcyBGFNbmENGuAyi3Wo2KH
         wF8ttarUs89EOkFRBvPJninvPmGeDDnpnq9nWdwKwP0C2nHCje39L062ZUXMaGP4pa2G
         aX6ikFFNP9FK0h6hh/GjA9lvTQqhf/29iDRgsqqAoPIwomfeSsNg3CtF582fL928scNG
         bkRb5BKMCZz7+nS3hpKuDylSmlK5zTul4o6d/Qj6kfshr4R07BpJmDJDpZkdf9PanRqX
         S3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cePeFxPoNoJDCzd23ACFb/6BsCv5I8F1VVlSAM3tueA=;
        b=tXm3YeEVTqBd4yi9M4T7Rd/ieY8DGNR5+11LxH6O2qcrSxnn0pis+4f6wHAmkIO2rZ
         sN1hpQgeFzg4klGvKUgOoaWWOKUms6SSW+T4qkNCFHNASelUIUdn7z1G/5MfvHQDf879
         gMH5bVrXzvNPn3ANhcHfHXmnZi9uz8ZuNpFOptkWaqVDN6YvGjpxO67IiRmDsuX5MvIi
         WcONxHlRBB1JcHVJoTNmTKJzF1l/oMRY8Uy/zVBQSChIuEOIudcRcIWqhCgKiyxOH8V3
         hcTt3qyThzrsfSqwtIPW7cMuilKh4HjhMde3gec2vNtB02/ppl25M8aVnPu26w9OJkr1
         pkig==
X-Gm-Message-State: AOAM530cR2VvM6xh3jccoDsXX+Lw8HrAww+JXu3IBAeawOrs45G0rZwY
        2mxgifCzQB8mTj7ZsSVnTsn+GZvL0JtmMloklt4=
X-Google-Smtp-Source: ABdhPJy/9gGw0ka8hElWBRaIMhpWSt4Gcnvhs5l2yGfIjp1xBTJs+45WtTpOGiEjbV38iWex0E6lb7iRmIcFyflQHig=
X-Received: by 2002:aca:d409:: with SMTP id l9mr11252190oig.70.1599471408164;
 Mon, 07 Sep 2020 02:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191026132110.4026-1-sashal@kernel.org> <20191026132110.4026-17-sashal@kernel.org>
In-Reply-To: <20191026132110.4026-17-sashal@kernel.org>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 7 Sep 2020 11:36:37 +0200
Message-ID: <CAKfDRXjjuW4VM03HeVoeEyG=cULUK8ZXexWu48rfFvJE+DD8_g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 17/33] net: usb: qmi_wwan: add Telit 0x1050 composition
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Oct 26, 2019 at 3:27 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Daniele Palmas <dnlplm@gmail.com>
>
> [ Upstream commit e0ae2c578d3909e60e9448207f5d83f785f1129f ]
>
> This patch adds support for Telit FN980 0x1050 composition
>
> 0x1050: tty, adb, rmnet, tty, tty, tty, tty
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index e406a05e79dcd..57e9166b4bff3 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1252,6 +1252,7 @@ static const struct usb_device_id products[] =3D {
>         {QMI_FIXED_INTF(0x2357, 0x0201, 4)},    /* TP-LINK HSUPA Modem MA=
180 */
>         {QMI_FIXED_INTF(0x2357, 0x9000, 4)},    /* TP-LINK MA260 */
>         {QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)}, /* Telit LE922A */
> +       {QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)}, /* Telit FN980 */
>         {QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},    /* Telit ME910 */
>         {QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},    /* Telit ME910 dual modem=
 */
>         {QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},    /* Telit LE920 */
> --
> 2.20.1
>

When testing the FN980 with kernel 4.14, I noticed that the qmi device
was not there. Checking the git log, I see that this patch was never
applied. The patch applies fine, so I guess it was just missed
somewhere. If it could be added to the next 4.14 release, it would be
much appreciated.

BR,
Kristian
