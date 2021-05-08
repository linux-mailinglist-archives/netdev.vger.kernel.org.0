Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A86376F95
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhEHEhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 00:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhEHEho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 00:37:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B4EC061574;
        Fri,  7 May 2021 21:36:42 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s20so6249124plr.13;
        Fri, 07 May 2021 21:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/yACCLoLjWj71rRpDVAkzTVCU1v7fPrPUuAe69j3t0=;
        b=Q1VP5bUmjbxBe0gwmaKJc20Zx5rr8NbjLmO8s0+7kP4HiCdyymowAWNTEa5LmVzvRU
         tO2wQ7sL61+grgHxaLLCU04cI72X3Y09X5X9wrPwVRGIZDrXyBNpS7rmoLIprg/HigA5
         Vs2BeFmlUu9Ly7zXt2AefAsQAUEx3LpF/1Zr7LS8nkeOVSIxHPbL+x14GN8tpoQhOzi0
         tgdj0u/IAnw37l3GKb3ZDr3yZEys0wOSLCfqMJJIScpqkPtCrqQxxG/9/7dJ1OLLmP9m
         KIeRNdndpJfckPzFZ7I0JJCe1yaaZB2MGN8h2byBO4+s3RtyUteopGalR3eTfB4Xpsai
         vMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/yACCLoLjWj71rRpDVAkzTVCU1v7fPrPUuAe69j3t0=;
        b=B5yE+0IuRPqFyIrrS4Fb7IZJjXy7WlLYBYh1CqV342yBbZONi9fY1M7SQRYTzEQL/v
         XpwdalIQ78w2a67ofMajwcuY6pXO4A/91J/jnjtKpsRMNS0Oav4IlGo3EfKecPdEJR0n
         8/Ivm71OeZ0eDty94I+5cYo87JSxGNL2n6pbhfYxXlNvSrZ+RWQVd4NeLol0m84NW62B
         RISlHfj+fx//6IQO75++wgxak6rm/7Ff/c+aWxL0M0p3vJ+RnK0CtPk/35tL6Lz3YDG7
         B5tQjBE/fUBvX2UMBhq1TKrdAfJ9DtDeC/vdYxCztopF10Ou6jyD7sAvJaN6zDAO7uUb
         KDFg==
X-Gm-Message-State: AOAM532QdgStG+0eS9z3R9XNlLu/8dXuez24TG+Sp1SwTFtAV+svG46h
        mh8pGFdMt2jYAGB+EzCpXNy354u4694=
X-Google-Smtp-Source: ABdhPJwa+TTYjGb3ij9mTNt5uOje7bGCpqdm36RINauSz9nllzkuD0PjXKp+M4lg5iLY/nHCpZ3G+g==
X-Received: by 2002:a17:90a:4a0e:: with SMTP id e14mr28611002pjh.209.1620448601585;
        Fri, 07 May 2021 21:36:41 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:b550:fa0a:6372:fbcf? ([2600:1700:dfe0:49f0:b550:fa0a:6372:fbcf])
        by smtp.gmail.com with ESMTPSA id j10sm5989196pfn.207.2021.05.07.21.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 21:36:40 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 23/28] net: dsa: register of_mdiobus if a
 mdio node is declared
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-23-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd58ebca-c1d4-28c4-6bee-368ba6225f34@gmail.com>
Date:   Fri, 7 May 2021 21:36:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-23-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> Some switch have phy port that use the internal switch mdio bus and can
> have different phy regs than the one declared in the ports node. Add
> support for this specific case by registering the mdiobus with the mdio
> node and permit the port to declare a phy-handle defined inside the
> switch node.
> 
> This is an example from the qca8337 switch where the 5 phy port should
> use the internal mdiobus and would benefits from this.
> 
> switch10: switch@10 {
>         compatible = "qca,qca8337";
>         #address-cells = <1>;
>         #size-cells = <0>;
>         reg = <0x10>;
> 
>         ports {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 port@0 {
>                         reg = <0>;
>                         label = "cpu";
>                         ethernet = <&gmac1>;
>                         phy-mode = "rgmii-id";
> 
>                         fixed-link {
>                                 speed = <1000>;
>                                 full-duplex;
>                         };
>                 };
> 
>                 port@1 {
>                         reg = <1>;
>                         label = "lan1";
> 
>                         phy-handle = <&phy_port0>;
>                         phy-mode = "internal";
>                 };
> 
>                 port@2 {
>                         reg = <2>;
>                         label = "lan2";
> 
>                         phy-handle = <&phy_port1>;
>                         phy-mode = "internal";
>                 };
> 
>                 port@3 {
>                         reg = <3>;
>                         label = "lan3";
> 
>                         phy-handle = <&phy_port2>;
>                         phy-mode = "internal";
>                 };
> 
>                 port@4 {
>                         reg = <4>;
>                         label = "lan4";
> 
>                         phy-handle = <&phy_port3>;
>                         phy-mode = "internal";
>                 };
> 
>                 port@5 {
>                         reg = <5>;
>                         label = "wan";
> 
>                         phy-handle = <&phy_port4>;
>                         phy-mode = "internal";
>                 };
> 
>                 port@6 {
>                         reg = <6>;
>                         label = "cpu";
>                         ethernet = <&gmac2>;
>                         phy-mode = "sgmii";
> 
>                         fixed-link {
>                                         speed = <1000>;
>                                         full-duplex;
>                         };
>                 };
>         };
> 
>         mdio {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 phy_port0: phy@0 {
>                         reg = <0>;
>                 };
> 
>                 phy_port1: phy@1 {
>                         reg = <1>;
>                 };
> 
>                 phy_port2: phy@2 {
>                         reg = <2>;
>                 };
> 
>                 phy_port3: phy@3 {
>                         reg = <3>;
>                 };
> 
>                 phy_port4: phy@4 {
>                         reg = <4>;
>                 };
>         };
> };
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  net/dsa/dsa2.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 3c3e56a1f34d..79adabe3e2a7 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -14,6 +14,7 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/of.h>
>  #include <linux/of_net.h>
> +#include <linux/of_mdio.h>
>  #include <net/devlink.h>
>  
>  #include "dsa_priv.h"
> @@ -721,6 +722,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	devlink_params_publish(ds->devlink);
>  
>  	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> +		struct device_node *mdio;
> +
>  		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
>  		if (!ds->slave_mii_bus) {
>  			err = -ENOMEM;
> @@ -729,7 +732,15 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  		dsa_slave_mii_bus_init(ds);
>  
> -		err = mdiobus_register(ds->slave_mii_bus);
> +		mdio = of_get_child_by_name(ds->dev->of_node, "mdio");
> +
> +		if (mdio) {

This probably needs to be if (of_device_is_available(mdio)), since one
could conceivably declare the switch internal MDIO bus but put a
disabled status property not to use it.
-- 
Florian
