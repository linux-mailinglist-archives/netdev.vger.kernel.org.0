Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46A74F1818
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378481AbiDDPSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378487AbiDDPR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:17:56 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8662C652;
        Mon,  4 Apr 2022 08:16:00 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id r8so10391610oib.5;
        Mon, 04 Apr 2022 08:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=w0TYTDCl2b2Z4blu+zCKIcUNIe20JrsvaCgfIx0hYQ0=;
        b=G+WRNlGovbAFASv0w2mF5CZ4WmccHVjwbtb9ka0857Xwd9ILPnhTJiHjcTM1kYLl/N
         NICthUTQspOrlzsb+VFDZC1LhsDx20pAV6GMeYrw+4v8Z/Uu9WVAxi6ffmRoWyYG8El7
         4Yi3NpV2tICd+S3gtZjNovHPfJvxh87Wq2Z8l6Vt6615Wgn0OlomDhYwyyhopaYJoggD
         SnGWOIELQWUJ+buCsSebHUNhn9XY1ywCG6p1m7vozuMl74xztlITflV5HiJ9evy0+oTk
         Dws4LpafjQV8xQ2F+eBEIePb658ldrxpyCHON8PctRmiWIl7q6rb+sUOIJrOWbPdoLKy
         Rk6Q==
X-Gm-Message-State: AOAM5334cuGFaTqOr0jw30h+bjJ6JoMZM62CjR4OcRKruwEZsa9pgV85
        VCe1lcCOqPTOsNaBLhaI7w==
X-Google-Smtp-Source: ABdhPJw/UeiNa/TNOL111ajz5ykV/iRwx/NMUA0QKwx+VAvJD/2hePRPcQyIxNnM2OP/ds4d+1MCpQ==
X-Received: by 2002:a54:470f:0:b0:2ef:8a55:b94f with SMTP id k15-20020a54470f000000b002ef8a55b94fmr23909oik.243.1649085359902;
        Mon, 04 Apr 2022 08:15:59 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q39-20020a4a88ea000000b0032165eb3af8sm4121702ooh.42.2022.04.04.08.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 08:15:58 -0700 (PDT)
Received: (nullmailer pid 1346118 invoked by uid 1000);
        Mon, 04 Apr 2022 15:15:57 -0000
Date:   Mon, 4 Apr 2022 10:15:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Stefano Stabellini <stefanos@xilinx.com>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4] dt-bindings: imx: add nvmem property
Message-ID: <YksLrXDVWYk1R1Jp@robh.at.kernel.org>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
 <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
 <YkZEIR1XqJ6sseto@robh.at.kernel.org>
 <DU0PR04MB94179B979091FC517FB8AEC388E39@DU0PR04MB9417.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DU0PR04MB94179B979091FC517FB8AEC388E39@DU0PR04MB9417.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 02, 2022 at 01:52:28AM +0000, Peng Fan wrote:
> > Subject: Re: [PATCH 0/4] dt-bindings: imx: add nvmem property
> > 
> > On Thu, Mar 24, 2022 at 12:11:04PM +0100, Uwe Kleine-König wrote:
> > > Hello,
> > >
> > > On Thu, Mar 24, 2022 at 12:20:20PM +0800, Peng Fan (OSS) wrote:
> > > > From: Peng Fan <peng.fan@nxp.com>
> > > >
> > > > To i.MX SoC, there are many variants, such as i.MX8M Plus which
> > > > feature 4 A53, GPU, VPU, SDHC, FLEXCAN, FEC, eQOS and etc.
> > > > But i.MX8M Plus has many parts, one part may not have FLEXCAN, the
> > > > other part may not have eQOS or GPU.
> > > > But we use one device tree to support i.MX8MP including its parts,
> > > > then we need update device tree to mark the disabled IP status
> > "disabled".
> > > >
> > > > In NXP U-Boot, we hardcoded node path and runtime update device tree
> > > > status in U-Boot according to fuse value. But this method is not
> > > > scalable and need encoding all the node paths that needs check.
> > > >
> > > > By introducing nvmem property for each node that needs runtime
> > > > update status property accoridng fuse value, we could use one
> > > > Bootloader code piece to support all i.MX SoCs.
> > > >
> > > > The drawback is we need nvmem property for all the nodes which maybe
> > > > fused out.
> > >
> > > I'd rather not have that in an official binding as the syntax is
> > > orthogonal to status = "..." but the semantic isn't. Also if we want
> > > something like that, I'd rather not want to adapt all bindings, but
> > > would like to see this being generic enough to be described in a
> > > single catch-all binding.
> > >
> > > I also wonder if it would be nicer to abstract that as something like:
> > >
> > > 	/ {
> > > 		fuse-info {
> > > 			compatible = "otp-fuse-info";
> > >
> > > 			flexcan {
> > > 				devices = <&flexcan1>, <&flexcan2>;
> > > 				nvmem-cells = <&flexcan_disabled>;
> > > 				nvmem-cell-names = "disabled";
> > > 			};
> > >
> > > 			m7 {
> > > 				....
> > > 			};
> > > 		};
> > > 	};
> > >
> > > as then the driver evaluating this wouldn't need to iterate over the
> > > whole dtb but just over this node. But I'd still keep this private to
> > > the bootloader and not describe it in the generic binding.
> > 
> > There's been discussions (under the system DT umbrella mostly) about
> > bindings for peripheral enable/disable control/status. Most of the time it is in
> > context of device assignment to secure/non-secure world or partitions in a
> > system (via a partitioning hypervisor).
> > 
> > This feels like the same thing and could use the same binding. But someone
> > has to take into account all the uses and come up with something. One off
> > solutions are a NAK.
> 
> Loop Stefano.
> 
> Per my understanding, system device tree is not a runtime generated device
> tree, in case I am wrong.

I said it was part of 'system DT' discussions, not that you need 'system 
DT'. There's been binding patches on the list from ST for the 'trustzone 
protection controller' if I remember the name right. I think there was 
another proposal too.


> To i.MX, one SoC has many different parts, one kind part may not have
> VPU, another part may not have GPU, another part may be a full feature
> one. We have a device tree for the full feature one, but we not wanna
> introduce other static device tree files for non-full feature parts.
> 
> So we let bootloader to runtime setting status of a device node according
> to fuse info that read out by bootloader at runtime.

Sounds like the same problem for the OS perspective. A device may or may 
not be available to the OS. The reason being because the device is 
assigned to TZ or another core vs. fused off doesn't matter.


> I think my case is different with system device tree, and maybe NXP i.MX
> specific. So I would introduce a vendor compatible node, following Uwe's
> suggestion. We Just need such binding doc and device node in Linux kernel
> tree. The code to scan this node is in U-Boot.

Again, device assignment is a common problem. I'm only going to accept a 
common solution.

Rob
