Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C82172FC4
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 05:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgB1EYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 23:24:07 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42638 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730800AbgB1EYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 23:24:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id h8so816763pgs.9;
        Thu, 27 Feb 2020 20:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mUWNeWyqQitDrTxSvaUeR/q3HDom+yqhZVfbWyM9nlg=;
        b=pU8usZAluZVny7eJfMqEtmnvxaK39wkyj67xrgHsLPsixWBFQ+Xyi/GMhWIYPzrbI5
         Q1plRLK3u94hL4lj98jxQ4vos6wCqr/oN1ExMQTOZU+/WtcXDHgbU7ag3PE4zrobCYNN
         1ZL1EfKGWyu05tF/Xb76TnIYntnXTfm1vJREBJVXpMOqAfUSnDwuDGSm5ZKuJ5EphONh
         KHqLz3GCnHku3AVMjBClF72oHev8DyNpZFwAApYyRSeIVWmSd5p1VCmlsj0hApvZOIw3
         fhJ9n8/77IFDiXG5QRaX40ayCOHrOvthrnY1dA3lTaDujEmzu6Gs/4FARQQ9KTG1Drii
         k02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mUWNeWyqQitDrTxSvaUeR/q3HDom+yqhZVfbWyM9nlg=;
        b=DDLp9j1968MMNwyFJlMrsMgBy38JHG0PRAAzSR3uOZc21i463ykeYLRFzgNTp3kA6B
         HFXwsSGS+IOrr+hxndl9JdYc457gDmVcjFY7PPKkmROM+pC1N0uORSymNiS0Jo52UcAF
         iBT993MgCuT6KVLAgGhht1729pJx5Dm5fT25K+kzoYg7KgiNLt0lTmB4jp9N6xbzOVfd
         d2Fb7S9A7V5Nbfn0NlLArUhlXf/PldE7htripF658t2R0NcgzUvOLL1naAxTI4Rr7286
         Y5Z+HyohPOu5NcAfYmDLbd6ux7nOl8J0AOvg3UGJD2dNU/npLkkoCZvlGotpOgGoci/l
         tjtQ==
X-Gm-Message-State: APjAAAU3VnAQstfYnoAoUa8dVRr1WfA2LRWCjn45ggvqXe4wJxRde1vu
        lsJMkChV7fLH9xHaa5FNkv9eOkk4
X-Google-Smtp-Source: APXvYqznGAnNJjpaSO3hjzo0LvzALKUZzxL7oD2/skv5dqhA4J9FYnuuTnpOrxMvzVzSvG5NBpOSIA==
X-Received: by 2002:a63:3f4f:: with SMTP id m76mr2552445pga.353.1582863846014;
        Thu, 27 Feb 2020 20:24:06 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 3sm8910116pfi.13.2020.02.27.20.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 20:24:05 -0800 (PST)
Subject: Re: [RFC net-next 3/3] dt-bindings: marvell,prestera: Add address
 mapping for Prestera Switchdev PCIe driver
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-4-vadym.kochan@plvision.eu>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <b06f87c3-d872-af3a-8042-6bd94e08e4b9@gmail.com>
Date:   Thu, 27 Feb 2020 20:24:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225163025.9430-4-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2020 8:30 AM, Vadym Kochan wrote:
> Document requirement for the PCI port which is connected to the ASIC, to
> allow access to the firmware related registers.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---
>  .../devicetree/bindings/net/marvell,prestera.txt    | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
> index 83370ebf5b89..103c35cfa8a7 100644
> --- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
> +++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
> @@ -45,3 +45,16 @@ dfx-server {
>  	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
>  	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
>  };
> +
> +Marvell Prestera SwitchDev bindings
> +-----------------------------------
> +The current implementation of Prestera Switchdev PCI interface driver requires
> +that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:

It is always a bit disturbing to document what a driver does, or want in
a Device Tree binding. If it is necessary for the PCIe device to have
multiple ranges defined such that the necessary BARs are available, that
is what is necessary, no need to mention what the driver or firmware does.

> +
> +&cp0_pcie0 {
> +	ranges = <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
> +		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
> +		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
> +	phys = <&cp0_comphy0 0>;
> +	status = "okay";
> +};
> 

-- 
Florian
