Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC251684D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfEGQpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 12:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfEGQpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 12:45:11 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C9921019;
        Tue,  7 May 2019 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557247509;
        bh=iM8J/j10jYr+vXCxXzUjgCYgZk17YUkoK9VE/2fhJ1I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=INXumkFeyNf58pU/qjd3huFH5ZfaxLIpyMXHCnZHxbXpsPJF6T1W6Vkh88hhOGvrJ
         GIheX5UtWz5QwB5Diw5nYE1jqJSPYf2nUHSJh66NP2uXzpdCBhwXjr4Np+l7L8hUOv
         mxoIiNV+EIzMpgJ0Ex/W0XZsuvBDRvLXKk1WcejY=
Received: by mail-qt1-f173.google.com with SMTP id f24so9394033qtk.11;
        Tue, 07 May 2019 09:45:09 -0700 (PDT)
X-Gm-Message-State: APjAAAW38M9Gj0afQsWp34yIMtcPqexEj+ZkKDww0vcMTa0oFMgsPMU2
        lL3t6er9pY7fTllc6G2RqfdislO1NyFIcY2ddQ==
X-Google-Smtp-Source: APXvYqy7rk1sMMIHbSD/9OOZe8P3NIAyg7u8OPXuXWtwWi2WaDv6h/Xnf9ZSQ+8dUBlM+SULUoG2eW9wkEEg+3BdjGk=
X-Received: by 2002:ac8:641:: with SMTP id e1mr27644859qth.76.1557247508777;
 Tue, 07 May 2019 09:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <1556893635-18549-1-git-send-email-ynezz@true.cz> <1556893635-18549-3-git-send-email-ynezz@true.cz>
In-Reply-To: <1556893635-18549-3-git-send-email-ynezz@true.cz>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 7 May 2019 11:44:57 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLt6UFU_6bmh3Pc0taXUgMtAEV7kL7eZU13cLOjoakf=Q@mail.gmail.com>
Message-ID: <CAL_JsqLt6UFU_6bmh3Pc0taXUgMtAEV7kL7eZU13cLOjoakf=Q@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] dt-bindings: doc: reflect new NVMEM
 of_get_mac_address behaviour
To:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 9:27 AM Petr =C5=A0tetiar <ynezz@true.cz> wrote:
>
> As of_get_mac_address now supports NVMEM under the hood, we need to updat=
e
> the bindings documentation with the new nvmem-cell* properties, which wou=
ld
> mean copy&pasting a lot of redundant information to every binding
> documentation currently referencing some of the MAC address properties.
>
> So I've just removed all the references to the optional MAC address
> properties and replaced them with the small note referencing
> net/ethernet.txt file.
>
> Signed-off-by: Petr =C5=A0tetiar <ynezz@true.cz>
> ---
>
>  Changes since v2:
>
>  * replaced only MAC address related optional properties with a text
>    referencing ethernet.txt
>
>  Documentation/devicetree/bindings/net/altera_tse.txt           |  5 ++--=
-
>  Documentation/devicetree/bindings/net/amd-xgbe.txt             |  5 +++-=
-
>  Documentation/devicetree/bindings/net/brcm,amac.txt            |  4 ++--
>  Documentation/devicetree/bindings/net/cpsw.txt                 |  4 +++-
>  Documentation/devicetree/bindings/net/davinci_emac.txt         |  5 +++-=
-
>  Documentation/devicetree/bindings/net/dsa/dsa.txt              |  5 ++--=
-
>  Documentation/devicetree/bindings/net/ethernet.txt             |  6 ++++=
--
>  Documentation/devicetree/bindings/net/hisilicon-femac.txt      |  4 +++-
>  .../devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt         |  4 +++-
>  Documentation/devicetree/bindings/net/keystone-netcp.txt       | 10 ++++=
+-----
>  Documentation/devicetree/bindings/net/macb.txt                 |  5 ++--=
-
>  Documentation/devicetree/bindings/net/marvell-pxa168.txt       |  4 +++-
>  Documentation/devicetree/bindings/net/microchip,enc28j60.txt   |  3 ++-
>  Documentation/devicetree/bindings/net/microchip,lan78xx.txt    |  5 ++--=
-
>  Documentation/devicetree/bindings/net/qca,qca7000.txt          |  4 +++-
>  Documentation/devicetree/bindings/net/samsung-sxgbe.txt        |  4 +++-
>  .../devicetree/bindings/net/snps,dwc-qos-ethernet.txt          |  5 +++-=
-
>  .../devicetree/bindings/net/socionext,uniphier-ave4.txt        |  4 ++--
>  Documentation/devicetree/bindings/net/socionext-netsec.txt     |  5 +++-=
-
>  .../devicetree/bindings/net/wireless/mediatek,mt76.txt         |  5 +++-=
-
>  Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt   |  4 ++--
>  21 files changed, 58 insertions(+), 42 deletions(-)

[...]

> diff --git a/Documentation/devicetree/bindings/net/keystone-netcp.txt b/D=
ocumentation/devicetree/bindings/net/keystone-netcp.txt
> index 04ba1dc..3a65aab 100644
> --- a/Documentation/devicetree/bindings/net/keystone-netcp.txt
> +++ b/Documentation/devicetree/bindings/net/keystone-netcp.txt
> @@ -135,14 +135,14 @@ Optional properties:
>                 are swapped.  The netcp driver will swap the two DWORDs
>                 back to the proper order when this property is set to 2
>                 when it obtains the mac address from efuse.
> -- local-mac-address:   the driver is designed to use the of_get_mac_addr=
ess api
> -                       only if efuse-mac is 0. When efuse-mac is 0, the =
MAC
> -                       address is obtained from local-mac-address. If th=
is
> -                       attribute is not present, then the driver will us=
e a
> -                       random MAC address.
>  - "netcp-device label":        phandle to the device specification for e=
ach of NetCP
>                         sub-module attached to this interface.
>
> +The MAC address will be determined using the optional properties defined=
 in
> +ethernet.txt, as provided by the of_get_mac_address API and only if efus=
e-mac

Don't make references to Linux in bindings. You can talk about
expectations of client programs (e.g Linux, u-boot, BSD, etc.) though.

Rob
