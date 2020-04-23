Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD331B5318
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgDWDVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWDVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:21:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B772AC03C1AA;
        Wed, 22 Apr 2020 20:21:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rh22so3550236ejb.12;
        Wed, 22 Apr 2020 20:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yECYkW6kYulgN7GYObELE37Oahgo3JXVTUsRcxmRGd8=;
        b=CsEcXpEeezisp/auKn+jJLIaiHHBpQWqfqGMN547pLZprSK/kexVpkioKWXuzczIFM
         pBYdAS6JnnKznDiSuMo/Nu9PgNHzEzbXtjB+cYsyXrtca5vaTZjU3WvgTBmbwaBp38pj
         kbdwd4xAfNy40AbMnifQPpwcL8N0G3SpW6X6VBrvwx2MwFPQhvLSRoc0nMhz3SyZ4rRu
         UD3j6HJ0pN7K6e028yeqncGq/d87m8IaHzJQhRaQ5o+/A0vZHeMk13a0GxYN708ATb2m
         wkDekiR7kLFGrTEyDGN1xCEGyckXsDXX9LB91ChifPvO5B77omW2/ArQyJYuqqv0uzCU
         OQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yECYkW6kYulgN7GYObELE37Oahgo3JXVTUsRcxmRGd8=;
        b=uFgW+RWE5Nb3hoqUjg1zYz1azBu/J9qZb3V1uaN7gleICroHDE3uGQ8iJA4UQG+Mev
         db6eYJw+wGJ0yphAFF6x1MScmiw2bQoo+wnp1vsyyUo0W8/efaSF1QaZqsjy7ykADRqs
         8Fvk+RF93Y4dKmm7t8mPbQGFOKvhx1gouAvzPv03UrJvh6lrtsN3WMrAGkZ4yVALCq9x
         fJLi1GzA4A5Z7DOqjKD8uEVfgmCDnN/ydwIBvx63NG9OWf23NvGtb0WFuSB0MVG00U6Y
         Otb/6MuXvPeZ9K5wumhV8lqGKjF+73cAzoOkb4fqbyZNhP45ndHXpbsaOk6P7/Y0QS44
         QY/g==
X-Gm-Message-State: AGi0PuZxgtmSoj2TNO4P1XPHbnNrg/N7TUB3qNbwzCTF2lP8rF4IvjSR
        SgPvTZQlmZBvdGjXHzMoJzbQWD5o
X-Google-Smtp-Source: APiQypKbZMGCTiMRruMWt2X4XvXZ1fma3UUHvfXKcG8tTqQ6vixibAz0T+YbotzjH2t0vLBhXqqNJg==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr1116839ejm.102.1587612092115;
        Wed, 22 Apr 2020 20:21:32 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j14sm263168ejy.72.2020.04.22.20.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:21:31 -0700 (PDT)
Subject: Re: [PATCH net-next v5 4/4] net: phy: tja11xx: add delayed
 registration of TJA1102 PHY1
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7615d9a6-4c21-5668-33af-fe9a71424f90@gmail.com>
Date:   Wed, 22 Apr 2020 20:21:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422092456.24281-5-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2020 2:24 AM, Oleksij Rempel wrote:
> TJA1102 is a dual PHY package with PHY0 having proper PHYID and PHY1
> having no ID. On one hand it is possible to for PHY detection by
> compatible, on other hand we should be able to reset complete chip
> before PHY1 configured it, and we need to define dependencies for proper
> power management.
> 
> We can solve it by defining PHY1 as child of PHY0:
> 	tja1102_phy0: ethernet-phy@4 {
> 		reg = <0x4>;
> 
> 		interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 
> 		reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
> 		reset-assert-us = <20>;
> 		reset-deassert-us = <2000>;
> 
> 		tja1102_phy1: ethernet-phy@5 {
> 			reg = <0x5>;
> 
> 			interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 		};
> 	};
> 
> The PHY1 should be a subnode of PHY0 and registered only after PHY0 was
> completely reset and initialized.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

You did not expand too much on why you had to use a workqueue to 
register the second PHY instance?
-- 
Florian
