Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1635E557
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbhDMRtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347341AbhDMRtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 13:49:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8781C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 10:49:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u11so5209525pjr.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=j8r1UA1SAzvucbYLVyzqDfM6oA8DqW9YeJSaDX1Bd68=;
        b=fpNkGfM6+/VbGTzqdHKcFbVm2EymRyXIsLMtH0iWQuN/nPxMVNH5JplRiWWa6Z5u5g
         2qBGUGSD0wqt4fsoLad3/+XvfpBRhPDdgOwF4LI0UA69y21QGsMUcNHeCIq617gugHUY
         P9vbgyfJeomda1dRSjxX/u7D7M6BMRBUIWqvK50R9cJLwacTX2vuLOIic/IZ02iN9M0y
         KZLfyD1k0Y+UDz6z+VGrB9PBnkX+Ky/HeLKVTXueCBHmWd5bZTbx7CGA3XdPeHcJJtTm
         9Pp4ejoyVnHhmT9UW6cuMZuid0rffqBsQtB9RbW1yd37Dgnz1AJgypSXctzMuZNpR3G5
         8jyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j8r1UA1SAzvucbYLVyzqDfM6oA8DqW9YeJSaDX1Bd68=;
        b=EyCoM6rPYIE1kVEYqDPjKT+HweKu3gP751Jea9uhyN7xYv4Zv5LN543SMojKL4u+bH
         UtRMSnrVcMs/B3PMg7YC9PfxF7vunimtLjNyxGwMzQdGrRCXAeSN61ZwQNuKJ2kic+sq
         /W94q6qCLx0haDqD8opJqdjLk0UY9ZzZlrgeA5YiL5Tl3ODOh/XuVt1RgiiaLOnOludJ
         fTwHQefUqi6sOgPO9gDmtNualpYyfurtyLtW0zgsT8XWZEhCKcQPJfJjvLXb1/wiDaN0
         AliPpd777Gusf+CayqnpeY/0pxpO8e6xujSniExKkytEcqpGG+NFJdgnCLkWv86lXJdn
         WjfQ==
X-Gm-Message-State: AOAM533JdC/OgAsZJr9qIGl9qd/Xiw+E0p0m2+0MnkudwSP97xWCNR+m
        TwcvkZ6Ji4JbaD5MYe4lH2YbhDo0BVz+bA==
X-Google-Smtp-Source: ABdhPJxmXhsbTeuf1evTGiiA8VHbiZjc5/Dzq02V97PL+qDqsA2Mhbheq9YAlesnaSsAiO3qI5fTpA==
X-Received: by 2002:a17:90a:868c:: with SMTP id p12mr1213482pjn.82.1618336164282;
        Tue, 13 Apr 2021 10:49:24 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m4sm14143930pgu.4.2021.04.13.10.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:49:23 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 13 Apr 2021 20:49:15 +0300
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK
 conversion
Message-ID: <20210413174915.uu2senujpqubmcnw@skbuf>
References: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
 <YHRVv/GwCmnRN14j@lunn.ch>
 <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:09:37AM +0200, Michal Vokáč wrote:
> On 12. 04. 21 16:14, Andrew Lunn wrote:
> > > [1] https://elixir.bootlin.com/linux/v5.12-rc7/source/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi#L101
> > 
> > &fec {
> > 	pinctrl-names = "default";
> > 	pinctrl-0 = <&pinctrl_enet>;
> > 	phy-mode = "rgmii-id";
> > 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
> > 	phy-reset-duration = <20>;
> > 	phy-supply = <&sw2_reg>;
> > 	phy-handle = <&ethphy0>;
> > 	status = "okay";
> > 
> > 	mdio {
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 
> > 		phy_port2: phy@1 {
> > 			reg = <1>;
> > 		};
> > 
> > 		phy_port3: phy@2 {
> > 			reg = <2>;
> > 		};
> > 
> > 		switch@10 {
> > 			compatible = "qca,qca8334";
> > 			reg = <10>;
> > 
> > 			switch_ports: ports {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 
> > 				ethphy0: port@0 {
> > 					reg = <0>;
> > 					label = "cpu";
> > 					phy-mode = "rgmii-id";
> > 					ethernet = <&fec>;
> > 
> > 					fixed-link {
> > 						speed = <1000>;
> > 						full-duplex;
> > 					};
> > 				};
> > 
> > The fec phy-handle = <&ethphy0>; is pointing to the PHY of switch port
> > 0. This seems wrong.
> 

Actually, the phy-handle is pointing directly to the switch port 0 node.

> I do not understand. Why this seems wrong?

The phy-handle property should point to a node representing a PHY
device. If a fixed-link subnode is present, no phy-handle is needed.

> The switch has four ports. Ports 2 and 3 have a PHY and are connected
> to the transformers/RJ45 connectors. Port 0 is MII/RMII/RGMII of
> the switch. Port 6 (not used) is a SerDes.
> 
> > Does the FEC have a PHY? Do you connect the FEC
> > and the SWITCH at the RGMII level? Or with two back to back PHYs?
> > 
> > If you are doing it RGMII level, the FEC also needs a fixed-link.
> 
> The FEC does not have PHY and is connected to the switch at RGMII level.
> Adding the fixed-link { speed = <1000>; full-duplex; }; subnode to FEC
> does not help.
> 

Did you also remove the extra phy-handle when you tested?

Ioana
