Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982647A277
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhLSVyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:54:09 -0500
Received: from sender3-op-o10.zoho.com ([136.143.184.10]:17602 "EHLO
        sender3-op-o10.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbhLSVyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:54:08 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1639950839; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=kcQdreH73cqLViVtqEpIGVz14O1qaZ3olEC71ChRfn848WsDrk4d3Z7JJCTxrIM9PbItIukH+DD8KleqkDRP+TP9ljwH+eob3sgFenna19MtCDZ3XodkpjReVJaoYQ+lbr1/M0jgQ/lMKKoHD97nb9rIh4cFzad02xVEWg+9APg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1639950839; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uWkTsA0WTLF2dPZ6Dart/n9hh7INePx8oXoqZ9hqus0=; 
        b=PmaN5P59I5K1eVnfCrKlyWF4g0R3P0mX0p7WswMaG7Hil6OE9rVXSAkb6bsQlyyMm6dGKTJt1ZxH6IJKsgZNycufurNCtdF5lh4y8wwFZFmsSQziG7GN5ZqWrPMO69GqR6a7sqfGuORucLj1W4AnkL0qrmadQH1Eru1KwsLAZy0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1639950839;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=uWkTsA0WTLF2dPZ6Dart/n9hh7INePx8oXoqZ9hqus0=;
        b=blFKNiYoD/Z4FiUMBuwGbvZzhGIWlf9Ryd9VuImtQ5RfyAAfOxdpi0IxmoIgyIuJ
        GghZHTZrCOLu2f/an2nPGrsxFxioZ/IbthLkvzgv5YYfcwKJlkR5DnO25AETemNF4fm
        dCe0cFqO9X6VTqFE6ppiLU2uYBdLE7rDfdBy1k+k=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1639950836204864.1288975768281; Sun, 19 Dec 2021 13:53:56 -0800 (PST)
Message-ID: <7e17c2f1-2868-5e17-7873-a729ddfec1e9@arinc9.com>
Date:   Mon, 20 Dec 2021 00:53:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v2 08/13] dt-bindings: net: dsa: realtek-mdio:
 document new interface
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-9-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20211218081425.18722-9-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/12/2021 11:14, Luiz Angelo Daros de Luca wrote:
> realtek-mdio is a new mdio driver for realtek switches that use
> mdio (instead of SMI) interface.
> 
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   .../bindings/net/dsa/realtek-mdio.txt         | 91 +++++++++++++++++++
>   MAINTAINERS                                   |  2 +-
>   2 files changed, 92 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
> new file mode 100644
> index 000000000000..71e0a3d09aeb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
> @@ -0,0 +1,91 @@
> +Realtek MDIO-based Switches
> +==========================
> +
> +Realtek MDIO-based switches use MDIO protocol as opposed to Realtek
> +SMI-based switches. The realtek-mdio driver is an mdio driver and it must
> +be inserted inside an mdio node.
> +
> +Required properties:
> +
> +- compatible: must be exactly one of (same as realtek-smi):
> +      "realtek,rtl8365mb" (4+1 ports)
> +      "realtek,rtl8366"               (not supported yet)
> +      "realtek,rtl8366rb" (4+1 ports)
> +      "realtek,rtl8366s"  (4+1 ports) (not supported yet)
> +      "realtek,rtl8367"               (not supported yet)
> +      "realtek,rtl8367b"              (not supported yet)
> +      "realtek,rtl8368s"  (8 port)    (not supported yet)
> +      "realtek,rtl8369"               (not supported yet)
> +      "realtek,rtl8370"   (8 port)    (not supported yet)
> +
> +Required properties:
> +- reg: MDIO PHY ID to access the switch
> +
> +Optional properties:
> +- realtek,disable-leds: if the LED drivers are not used in the
> +  hardware design this will disable them so they are not turned on
> +  and wasting power.
> +
> +See net/dsa/dsa.txt for a list of additional required and optional properties
> +and subnodes of DSA switches.
> +
> +Optional properties of dsa port:
> +
> +- realtek,ext-int: defines the external interface number (0, 1, 2). By default, 1.

You should introduce this with ("net: dsa: realtek: rtl8365mb: rename 
extport to extint, add "realtek,ext-int"") instead.
