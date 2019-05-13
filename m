Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67AF1B1D8
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 10:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfEMIZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 04:25:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44302 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfEMIZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 04:25:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id c5so14120060wrs.11
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 01:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CFnJlSE37e0qcpiE/Eug6pzyk4B93LF5pUyn1cquuXE=;
        b=G9+Dp8vGHd4rxJSONLC7omfsNFCgkiA4GeNmWbiYQjEENlZKU0vhk6gWaNAvEYRRvd
         XBZ1ARIQLGwq8vEo9KB5edfLqmyEbR1bzyna5dCCSw8SDZ+yEbSyKJpbYApb+VOB/fJT
         LC3h2n4uFi/eE8Lto2wkPdmk61t5SHr20jRgFIzZH7lgkakaG4KfUIv6Wb1f8KFDtGlS
         Z6E0dhS8L8rrwBWzaQ5jMatqehyRf4lC2+MNN1nGoqhWc7VCohmZSKnKrAKt1fUcq3+/
         V9URhe/aLb4H/LNFnWqvlC2FQeIACyE97jnbXQPUDEjkaDm2RN79iD0Hm4uWyvKOqE10
         NNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CFnJlSE37e0qcpiE/Eug6pzyk4B93LF5pUyn1cquuXE=;
        b=Pnrrh8XRw1buPf+PC16lUjoF8LekLtFEspC8h9+azo4tewQqz3lsg5I3nXSf6a756X
         VFgdXSuRP52gEQ+QarVw0G1bzXCVFbA3DA3ZcABgNM/6BwKOdZHJL2gzskjOE7XRrTej
         37NpjM1wu7j5ogGohrvvixOURudFXxgNJgWIDoyDDlYJyjnHCihQu7siSoNf6pqsvysf
         Ki5hF+zKxotxmbjkaxbat51T3yC8u4RexIC5erOyeAWGT2o4z1wSNUz7I81vUBiq5sqz
         Gypq8frSpzo6kYWLNzzBmisyh7pV5YP9Zr/xNsJXPokVIWGvOhGsS5i0CPbVBXrAZU3W
         Dtug==
X-Gm-Message-State: APjAAAVfZq7NOvDM/mpgttO3N5nrePHSQtXj/jt4qHNRfWSnmkR8Ja8R
        XOTBMuMs+rITpZtjc2XizLRJYA==
X-Google-Smtp-Source: APXvYqyE/7VHgCt/LGYrTOtcyHjwajRI1PEMprCZlDsXU7P3GvszVGDXPrfrWbJNMrbZGUaUtbhtgw==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr6154510wru.44.1557735957085;
        Mon, 13 May 2019 01:25:57 -0700 (PDT)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id x18sm12773049wrw.14.2019.05.13.01.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 01:25:56 -0700 (PDT)
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz> <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <547abcff-103a-13b8-f42a-c0bd1d910bbc@linaro.org>
Date:   Mon, 13 May 2019 09:25:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190511144444.GU81826@meh.true.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/05/2019 15:44, Petr Štetiar wrote:
>          };
>   
> +Another example where we've MAC address for eth1 stored in the NOR EEPROM as
> +following sequence of bytes (output of hexdump -C /dev/mtdX):
> +
> + 00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
> + 00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|
> +
> +Which means, that MAC address is stored in EEPROM as D4:EE:07:33:6C:20, so
> +ASCII delimited by colons, but we can't use this MAC address directly as
> +there's only one MAC address stored in the EEPROM and we need to increment last
> +octet/byte in this address in order to get usable MAC address for eth1 device.
> +
> + eth1_addr: eth-mac-addr@18a {
> +     reg = <0x18a 0x11>;
> +     byte-indices = < 0 2
> +                      3 2
> +                      6 2
> +                      9 2
> +                     12 2
> +                     15 2>;
> +     byte-transform = "ascii";
> +     byte-increment = <1>;
> +     byte-increment-at = <5>;
> +     byte-result-swap;


> + };
> +
> + &eth1 {
> +     nvmem-cells = <&eth1_addr>;
> +     nvmem-cell-names = "mac-address";
> + };
> +
>   = Data consumers =
>   Are device nodes which consume nvmem data cells/providers.

TBH, I have not see the full thread as I don't seem to be added to the 
original thread for some reason!

Looking at the comments from last few emails, I think the overall idea 
of moving the transformations in to nvmem core looks fine with me. I 
remember we discuss this while nvmem was first added and the plan was to 
add some kinda nvmem plugin/transformation interface at cell/provider 
level. And this looks like correct time to introduce this.

My initial idea was to add compatible strings to the cell so that most 
of the encoding information can be derived from it. For example if the 
encoding representing in your example is pretty standard or vendor 
specific we could just do with a simple compatible like below:

eth1_addr: eth-mac-addr@18a {
	compatible = "xxx,nvmem-mac-address";
	reg = <0x18a 0x11>;	
};

&eth1 {
	nvmem-cells = <&eth1_addr>;
	nvmem-cell-names = "mac-address";
}

thanks,
srini
