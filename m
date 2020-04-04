Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9420019E7F6
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 00:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgDDWmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 18:42:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51792 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDDWmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 18:42:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id z7so10877493wmk.1;
        Sat, 04 Apr 2020 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UhZ4xDcWDqeg6FTQjZVKOgJ1UEGx1WqVkP8SU3VMeTk=;
        b=t4aoTqR2yvaFlTV3dJbH23tuO1qhmpy1XwymZJSpxkM7FlB1aV8bN6uwt8AdoONejk
         f1NOHqjGZSXZnZtmVn22o7aTaQQCaHgyenWNQvokLuR8sznPoL4GqmAPfRhhKHBOlEAZ
         Dx0wYOpIsfdcwxI0ArYIrBfqSyfc8VXKbIB5xjXumRfpj8FCElWFkOyUfP3FpwWKXls8
         jGDO/dkkzCwezm54PSSqsRXLiigWpqf9t9y8kIhylMLoriiBjJIrbMvvWb7TKB4xR0Ll
         wgdP40EqiIVizvqFxJvUqK5kCcp9fBn9TY5vzfehBbvYDDks4qUI6yx+vHaCVv6aCgkD
         X6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UhZ4xDcWDqeg6FTQjZVKOgJ1UEGx1WqVkP8SU3VMeTk=;
        b=llgZmGVRvXeXBbfN8wctykPMj1W3twP9F+Bunn/9lByhRTTbmMAqAHlgiTaGiA000g
         D/U39l3v5blNmkboAN6+NFnPqqr2hssIpb1+rSech+4IrkvnHvOBFPTCPMNaCkjZENOO
         G1BPexdtX8fB21S5EaYW/qB+H/O1uPExV7V+RSWBG0z7k7HbqoPrHv4d3LxKWVc4t0mG
         8smhO5QLv9sl83bAk88RV+hhwssVqVQFcxo6KHFqesEkM8Po9u/2NLTHmRBFvewOiG+R
         C6ROUfiacadFIz20V1pGidcorHsrQpxmmPg4TOKpM4+jGsjbNHwV/4VTCNWpFLoMm7ux
         gFsw==
X-Gm-Message-State: AGi0PubHzYgnhV5qij9V+gmkDntGFyX3jutpu8m3vyIIr64WHF2h4XSd
        4FpvrmITDrf5Fzar2f5Vl1A=
X-Google-Smtp-Source: APiQypKEDtbRolvE7dQt1YrVi4hf1cTVJ2Vut49YGM6p3qVUhjT530GbHtMUSUZgt6tX6H9c8P8W2w==
X-Received: by 2002:a1c:4987:: with SMTP id w129mr16337706wma.168.1586040161380;
        Sat, 04 Apr 2020 15:42:41 -0700 (PDT)
Received: from localhost.localdomain (p200300F13710ED00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3710:ed00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id a67sm296947wmc.30.2020.04.04.15.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 15:42:40 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     alistair@alistair23.me
Cc:     alistair23@gmail.com, anarsoul@gmail.com,
        devicetree@vger.kernel.org, johan.hedberg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, mripard@kernel.org, netdev@vger.kernel.org,
        wens@csie.org, max.chou@realtek.com, hdegoede@redhat.com
Subject: RE: [PATCH 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Sun,  5 Apr 2020 00:42:05 +0200
Message-Id: <20200404224205.1643238-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200404204850.405050-1-alistair@alistair23.me>
References: <20200404204850.405050-1-alistair@alistair23.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alistair,

+Cc Max Chou, he may be interested in this also

[...]
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/realtek,rtl8723bs-bt.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: RTL8723BS/RTL8723CS Bluetooth Device Tree Bindings
I suggest you also add RTL8822C here (as well as to the compatible enum
and the description below). commit 848fc6164158d6 ("Bluetooth: hci_h5:
btrtl: Add support for RTL8822C") adde support for that chip but didn't
add the dt-binding documentation.

[...]
> +  device-wake-gpios:
> +    description:
> +      GPIO specifier, used to wakeup the BT module (active high)
> +
> +  enable-gpios:
> +    description:
> +      GPIO specifier, used to enable the BT module (active high)
> +
> +  host-wake-gpios:
> +    desciption:
> +      GPIO specifier, used to wakeup the host processor (active high)
regarding all GPIOs here: it entirely depends on the board whether these
are active HIGH or LOW. even though the actual Bluetooth part may
require a specific polarity there can be (for example) a transistor on
the board which could be used to invert the polarity (from the SoC's
view).

also "make dt_binding_check" reports:
  properties:host-wake-gpios: 'maxItems' is a required property
I assume that it'll be the same for the other properties

> +firmware-postfix: firmware postfix to be used for firmware config
there's no other dt-binding that uses "firmware-postfix" yet. However,
there are a few that use "firmware-name". My opinion hasn't changed
since Vasily has posted this series initially: I would not add that
property for now because there seems to be a "standard" config blob
(which works for "all" boards), see Hans' analysis result of the ACPI
config blobs for RTL8723BS: [0].
Getting that "standard" config blob into linux-firmware would be
awesome (I assume licensing is not an issue here, Hans can probably give
more details here). I'm not sure about the licenses of "board specific"
config blobs and whether these can be added to linux-firmware.

also indentation seems wrong here

> +reset-gpios: GPIO specifier, used to reset the BT module (active high)
indentation seems wrong here too

also please note that there is currently no support for this property
inside the hci_h5 driver and you don't seem to add support for it within
this series either. so please double check that the reset GPIO is really
wired up on your sopine board.

> +required:
> +  - compatible
> +
> +examples:
> +  - |
> +    &uart1 {
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
> +        status = "okay";
AFAIK the "status" property should be omitted from examples

also please add a "uart-has-rtscts" propery, see
Documentation/devicetree/bindings/serial/serial.yaml
Also please update patch #3.


Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/rtl_bt/rtl8723bs_config-OBDA8723.bin?id=e6b9001e91110c654573b8f8e2db6155d10d3b57
