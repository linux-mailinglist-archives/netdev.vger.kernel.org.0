Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F27301375
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbhAWF7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbhAWF73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:59:29 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87CFC06174A;
        Fri, 22 Jan 2021 21:58:48 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i141so7714572yba.0;
        Fri, 22 Jan 2021 21:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oide6CHNT8SKIJYSTcFoPxC8WbuXvbV+vIaGxgnvUBU=;
        b=J8zuf6vYdLp05gY6IMWEpt+KibwAC1MZhtV1T7MsUl8Yc+/AQo0pUEB+2IvqhEqhjY
         9zHfj90Mc9Avqnb85pjc/DRbhaHtzLUfT4BjJYBEflZyxYp8Ky+eShj42h821tqHE9WS
         JdY59HIEoHsyNLLAAN+PbI1mqVHAQtmfBcm+abt0e055FyeXJiSiVaF0RE7Gw0vF7PRr
         zilruEErZYpCozYfSkQraV8CN3Xuw1CIOQ+q7nezs41WBDqgRsIyy+aKDz7xrHFBDQkr
         E0haGehZQDIKVJpzlDVyqBCKMPP8LG1snHjXDtqSNxS6pBhDpSGcxuZU9uWXsmfhqB0v
         N+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=oide6CHNT8SKIJYSTcFoPxC8WbuXvbV+vIaGxgnvUBU=;
        b=iJsD8i6XELmswH6QIHum2vhxWvAyl7Qg0zx6LLYIRQ7TYLjVs0n5boDrt9FrZ5Wx75
         rS//2IZR4Uj9So4InlfzyqJLDw3E2VIPUD5aK4/ZVJDQLctpkLzo77eHjtYh7v4tPEpY
         vBJGe4RwveAB+PHV1qjhyV2UEV22UZAWodoSZPIHyIX7rbnf7k3lElab1VIezUN9iV/7
         nQC6Nc6bRNvHdWguIrQ923B5eNjYNuiTyQbAnPJq6eP+fu4qZfzDBIKktUyHaZP7jaOt
         h6yQlIP9MviWY+kVHYBgAXinyMlh00wT/x4auR2b2pmMYdBH8M71jBNyAXmSvr2RQ6dW
         mG1w==
X-Gm-Message-State: AOAM5329nIJc5jNYp2hxZONcjvqUuNn5NGtKnD8k8LGbPaxE5/R9eVpX
        ORkZMw4h4liuXiBw8GiNrFzmu4jpUAYKN+4Um+Wn18AbMVTeXWXL
X-Google-Smtp-Source: ABdhPJx/qP4zLOV5+rSPgDsQ66/Dt0+7RXWlllLHYNymUKp0xBwQ1PqgSO/QSzzu9vI6UKHV2phjzCAHcdyHyfeLD/I=
X-Received: by 2002:a25:688c:: with SMTP id d134mr11842671ybc.477.1611381527772;
 Fri, 22 Jan 2021 21:58:47 -0800 (PST)
MIME-Version: 1.0
References: <CAD-N9QUdXFhTqZXpjg02Ya7viR8WmkORbU7pwNTquNg8k_kzMg@mail.gmail.com>
In-Reply-To: <CAD-N9QUdXFhTqZXpjg02Ya7viR8WmkORbU7pwNTquNg8k_kzMg@mail.gmail.com>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Sat, 23 Jan 2021 13:58:21 +0800
Message-ID: <CAD-N9QUrKZXQtT6of0jQpMvOt9g0AXc1Mwa4Df1pUjUJqWVfww@mail.gmail.com>
Subject: Re: Duplicate crash reports related with smsc75xx/smsc95xx and root
 cause analysis
To:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 1:40 PM =E6=85=95=E5=86=AC=E4=BA=AE <mudongliangabc=
d@gmail.com> wrote:
>
> Dear kernel developers,
>
> I found that on the syzbot dashboard, =E2=80=9CKMSAN: uninit-value in
> smsc75xx_read_eeprom (2)=E2=80=9D [1],
> "KMSAN: uninit-value in smsc95xx_read_eeprom (2)" [2], "KMSAN:
> uninit-value in smsc75xx_bind" [3],
> "KMSAN: uninit-value in smsc95xx_reset" [4], "KMSAN: uninit-value in
> smsc95xx_wait_eeprom (2)" [5]
> should share the same root cause.
>
> ## Root Cause Analysis && Different behaviors
>
> The root cause of these crash reports resides in the
> "__smsc75xx_read_reg/__smsc95xx_read_reg". Take __smsc95xx_read_reg as
> an example,
>
> -------------------------------------------------------------------------=
----------------------------------------
> static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index=
,
>                                             u32 *data, int in_pm)
> {
>         u32 buf;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
>
>         BUG_ON(!dev);
>
>         if (!in_pm)
>                 fn =3D usbnet_read_cmd;
>         else
>                 fn =3D usbnet_read_cmd_nopm;
>
>         ret =3D fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
>                  | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                  0, index, &buf, 4);
>         if (unlikely(ret < 0)) {
>                 netdev_warn(dev->net, "Failed to read reg index 0x%08x: %=
d\n",
>                             index, ret);
>                 return ret;
>         }
>
>         le32_to_cpus(&buf);
>         *data =3D buf;
>
>         return ret;
> }
>
>
> static int __must_check smsc95xx_eeprom_confirm_not_busy(struct usbnet *d=
ev)
> {
>         unsigned long start_time =3D jiffies;
>         u32 val;
>         int ret;
>
>         do {
>                 ret =3D smsc95xx_read_reg(dev, E2P_CMD, &val);
>                 if (ret < 0) {
>                         netdev_warn(dev->net, "Error reading E2P_CMD\n");
>                         return ret;
>                 }
>
>                 if (!(val & E2P_CMD_BUSY_))
>                         return 0;
>         ......
> }
> -------------------------------------------------------------------------=
----------------------------------------
>
> In a special situation, local variable "buf" is not initialized with
> "fn" function invocation. And the ret is bigger than zero, and buf is
> assigned to "*data". In its parent function -
> smsc95xx_eeprom_confirm_not_busy, KMSAN reports "uninit-value" when
> accessing variable "val".
> Note, due to the lack of testing environment, I don't know the
> concrete reason for the uninitialization of "buf" local variable.
>
> The reason for such different crash behaviors is that the event -
> "buf" is not initialized is random when
> "__smsc75xx_read_reg/__smsc95xx_read_reg" is invoked.
>
> ## Patch
>
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index 4353b370249f..a8e500d92285 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -76,7 +76,7 @@ static int smsc75xx_phy_gig_workaround(struct usbnet *d=
ev);
>  static int __must_check __smsc75xx_read_reg(struct usbnet *dev, u32 inde=
x,
>                                             u32 *data, int in_pm)
>  {
> -       u32 buf;
> +       u32 buf =3D 0;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
>
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 4c8ee1cff4d4..dae3be723e0c 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -70,7 +70,7 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames
> per Rx transaction");
>  static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 inde=
x,
>                                             u32 *data, int in_pm)
>  {
> -       u32 buf;
> +       u32 buf =3D 0;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
>
> If you can have any issues with this statement or our information is
> useful to you, please let us know. Thanks very much.
>
> [1] =E2=80=9CKMSAN: uninit-value in smsc75xx_read_eeprom (2)=E2=80=9D - u=
rl
> [2] =E2=80=9CKMSAN: uninit-value in smsc95xx_read_eeprom (2)=E2=80=9D - U=
RL
> [3] "KMSAN: uninit-value in smsc75xx_bind" -
> [4] "KMSAN: uninit-value in smsc95xx_reset" -
> [5] "KMSAN: uninit-value in smsc95xx_wait_eeprom (2)" -

Add links for all five bug reports:

[1] =E2=80=9CKMSAN: uninit-value in smsc75xx_read_eeprom (2)=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3D2fb4e465ed593338d043227e7617cbdfaa03=
ba01
[2] =E2=80=9CKMSAN: uninit-value in smsc95xx_read_eeprom (2)=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3D0629febb76ae17ff78874aa68991e542506b=
1351
[3] "KMSAN: uninit-value in smsc75xx_bind" -
https://syzkaller.appspot.com/bug?id=3D45ee70ca00699d61239bbf9ebc790e33f83a=
dd6a
[4] "KMSAN: uninit-value in smsc95xx_reset" -
https://syzkaller.appspot.com/bug?id=3Dde07a0d125f8f1716eacb7e2ee4ceca251b2=
1511
[5] "KMSAN: uninit-value in smsc95xx_wait_eeprom (2)" -
https://syzkaller.appspot.com/bug?id=3Db4eb76261b208b986ad7683e686c6be4200a=
7109

>
> --
> My best regards to you.
>
>      No System Is Safe!
>      Dongliang Mu
