Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E428D4EE520
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbiDAARV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243312AbiDAARU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:17:20 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1893C72B;
        Thu, 31 Mar 2022 17:15:32 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-dacc470e03so1062975fac.5;
        Thu, 31 Mar 2022 17:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kgDedcBJcc+tv/OOgxKjgk/SoshOh6AR9hwsk4pYsLw=;
        b=1xsJ2ZfiQ5wEvzuC8CYkkWA4D4dVF0QRHSFazuz+YXFKE5EzIyjEAw6b1fL6qza+Qt
         fw2yGZq0WPJb2gWYQ3fqEaXXXc0y0anUChlWOorELWDjKiK+MjQ61b9sEcJFAzO/jM6w
         aJcw6qgbYLExQjGR3rPTvnuOMfHFHNwsYlMKzxr0I2QfIdcvIPblwCq0mXw+/5HoLTQP
         Q31fc2BeGpKxknfxoF93kbH6AIRM7ms7UGDj4/NlmaO48b13p7bORa5zv/Oo8kH2YR47
         UcAW4OhGkAy0L+ncUSt1pQgVyejNLLzsu+8sUDIygz+AEUvEfa2dTFaXbVcp/mHgPdTa
         kSxQ==
X-Gm-Message-State: AOAM532umhlA9LeJ2JStM71lg8gE6MJuCmDi2iDbprDLPjjRtiUuIY7Y
        aCvRcz6PtJCvz+cFSS9qnw==
X-Google-Smtp-Source: ABdhPJxOduw+Z9X08dI1UdH+GcjThmH7U3p+ZG1PL2p1hT2KQYDpoCnYsTC2oy0JMhvgskl1k1Dz6g==
X-Received: by 2002:a05:6870:f71f:b0:d7:5f1b:534f with SMTP id ej31-20020a056870f71f00b000d75f1b534fmr3922617oab.109.1648772131730;
        Thu, 31 Mar 2022 17:15:31 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g8-20020a9d2d88000000b005b238f7551csm462301otb.53.2022.03.31.17.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 17:15:30 -0700 (PDT)
Received: (nullmailer pid 1762367 invoked by uid 1000);
        Fri, 01 Apr 2022 00:15:29 -0000
Date:   Thu, 31 Mar 2022 19:15:29 -0500
From:   Rob Herring <robh@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, ulf.hansson@linaro.org,
        krzk+dt@kernel.org, shawnguo@kernel.org, s.hauer@pengutronix.de,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, qiangqing.zhang@nxp.com,
        devicetree@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        netdev@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] dt-bindings: imx: add nvmem property
Message-ID: <YkZEIR1XqJ6sseto@robh.at.kernel.org>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
 <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 12:11:04PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Mar 24, 2022 at 12:20:20PM +0800, Peng Fan (OSS) wrote:
> > From: Peng Fan <peng.fan@nxp.com>
> > 
> > To i.MX SoC, there are many variants, such as i.MX8M Plus which
> > feature 4 A53, GPU, VPU, SDHC, FLEXCAN, FEC, eQOS and etc.
> > But i.MX8M Plus has many parts, one part may not have FLEXCAN,
> > the other part may not have eQOS or GPU.
> > But we use one device tree to support i.MX8MP including its parts,
> > then we need update device tree to mark the disabled IP status "disabled".
> > 
> > In NXP U-Boot, we hardcoded node path and runtime update device tree
> > status in U-Boot according to fuse value. But this method is not
> > scalable and need encoding all the node paths that needs check.
> > 
> > By introducing nvmem property for each node that needs runtime update
> > status property accoridng fuse value, we could use one Bootloader
> > code piece to support all i.MX SoCs.
> > 
> > The drawback is we need nvmem property for all the nodes which maybe
> > fused out.
> 
> I'd rather not have that in an official binding as the syntax is
> orthogonal to status = "..." but the semantic isn't. Also if we want
> something like that, I'd rather not want to adapt all bindings, but
> would like to see this being generic enough to be described in a single
> catch-all binding.
> 
> I also wonder if it would be nicer to abstract that as something like:
> 
> 	/ {
> 		fuse-info {
> 			compatible = "otp-fuse-info";
> 
> 			flexcan {
> 				devices = <&flexcan1>, <&flexcan2>;
> 				nvmem-cells = <&flexcan_disabled>;
> 				nvmem-cell-names = "disabled";
> 			};
> 
> 			m7 {
> 				....
> 			};
> 		};
> 	};
> 
> as then the driver evaluating this wouldn't need to iterate over the
> whole dtb but just over this node. But I'd still keep this private to
> the bootloader and not describe it in the generic binding.

There's been discussions (under the system DT umbrella mostly) about 
bindings for peripheral enable/disable control/status. Most of the time 
it is in context of device assignment to secure/non-secure world or 
partitions in a system (via a partitioning hypervisor).

This feels like the same thing and could use the same binding. But 
someone has to take into account all the uses and come up with 
something. One off solutions are a NAK.

Rob
