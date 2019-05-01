Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535B910DE4
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfEAUWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:22:03 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39183 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfEAUWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 16:22:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id o39so109498ota.6;
        Wed, 01 May 2019 13:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=j6+33T0eQYv+IRslxaB17BzPQR0ZaM4rayHxbAHslak=;
        b=RE6QiWOQgI6pN7NXiR369Zc17nr6DSuJ+8WpLwe9HKX90iyJN3ZF/LZKuGuN5WX+OT
         mbyQ3IY/oE9sMAKNVibyhoYcDh43raPXJjnio8waBjPMRAFp6mmftR/ELP0LMm8ZE4U2
         HX3EMy9v/wYPmdA/JDgDBs81N4C0G4bET98BHO0/HrY36iLRDavO80l9UrsPRa4wbYBi
         974N3+L8n8iuG4KTGffGiRvRQIMkDOWVhZFa1aPJmYzK5+ZXvTuh0JETya+9IR7AMCns
         i+3etzKo9Cxo3sQYHdeigUcEG7xv05ClqArwQ5eHmSVjlE7t/a4Sp312u3NresQezP8n
         AksA==
X-Gm-Message-State: APjAAAU1ajGQxBVV1GNN8Al3jvWv9JDZ1pg/M+xqvlZGRmIO4eIIwgcO
        OcvIkxxVuHZfCHIjSwj71Q==
X-Google-Smtp-Source: APXvYqwBsg5utWlEXRbe3QYD7lyCysBSGwYTazCLxVYMMvMP+E5wWbFBBWdUCspop11+hVf0xHJhqQ==
X-Received: by 2002:a9d:3624:: with SMTP id w33mr19027211otb.284.1556742121379;
        Wed, 01 May 2019 13:22:01 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c26sm2891416otl.19.2019.05.01.13.22.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 May 2019 13:22:00 -0700 (PDT)
Date:   Wed, 1 May 2019 15:22:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Alban Bedel <albeu@free.fr>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/4] dt-bindings: doc: Reflect new NVMEM
 of_get_mac_address behaviour
Message-ID: <20190501202200.GB15495@bogus>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-3-git-send-email-ynezz@true.cz>
 <20190428165326.GI23059@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190428165326.GI23059@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 06:53:26PM +0200, Andrew Lunn wrote:
> On Sun, Apr 28, 2019 at 02:53:20PM +0200, Petr Štetiar wrote:
> > As of_get_mac_address now supports NVMEM under the hood, we need to update
> > the bindings documentation with the new nvmem-cell* properties, which would
> > mean copy&pasting a lot of redundant information to every binding
> > documentation currently referencing some of the MAC address properties.
> > 
> > So I've just removed all the references to the optional MAC address
> > properties and replaced them with the reference to the net/ethernet.txt
> > file.  While at it, I've also removed other optional Ethernet properties.
> 
> Hi Petr
> 
> I think each individual binding needs to give a hint if
> of_get_mac_address() is used, and hence if these optional properties
> are respected. The same is true for other optional properties. I don't
> want to have to look at the driver to know which optional properties
> are implemented, the binding should tell me. What the optional
> properties mean, and which order they are used in can then be defined
> in ethernet.txt.
> 
> So i would suggests something like:
> 
> The MAC address will be determined using the optional properties
> defined in ethernet.txt.
> 
> And leave all the other optional parameters in the bindings.

Yes. Generally we need to know which properties from a common pool of 
properties apply to a specific binding. Also there are typically 
additional constraints for a specific binding.

Rob
