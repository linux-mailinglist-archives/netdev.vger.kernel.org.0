Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185434F8D7F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiDHER4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiDHERx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77E32E4BA2;
        Thu,  7 Apr 2022 21:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64FA961E16;
        Fri,  8 Apr 2022 04:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D0AC385A1;
        Fri,  8 Apr 2022 04:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649391349;
        bh=EStePIw+CMLR4aey6pRfe8ZFXCPEn48dQTN3ybwAr/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEuOEXcjBODPReRkKvtLXhreIDACN0N09wiZyKB7/Z6UvvaR/95s7cRC25j4oG8BN
         jMzFaBn2TWcFpdCWWFrQVc8iasb49xWlBNzd+XhODXE+tvX37NqHg1MDOT4oCCaW6I
         ZfW3xbbgn4AT5nh7DpvW2ffCX9lIoqpraU1aj9rpm9XyWNPj9kP2KxyYQNp+gvedEN
         +qb03yVwth+xnpKn7mXmoyTpc2bIbm/a4djfiJLHjHczRtg5LtO/A/z5X/U82kyVLZ
         IzmZNFPAy4E8CzOtlMUHdKrluqudyk/fkbYN3bvfvduPYDBsJ+wZw7FRsNMfaAqDBi
         faatoaNPDibLQ==
Date:   Thu, 7 Apr 2022 21:15:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 00/13] net: wwan: t7xx: PCIe driver for
 MediaTek M.2 modem
Message-ID: <20220407211547.6dac8246@kernel.org>
In-Reply-To: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Apr 2022 15:36:16 -0700 Ricardo Martinez wrote:
> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which
> is based on MediaTek's T700 modem to provide WWAN connectivity.
> The driver uses the WWAN framework infrastructure to create the following
> control ports and network interfaces:
> * /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
>   Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards
>   with [3][4] can use it to enable data communication towards WWAN.
> * /dev/wwan0at0 - Interface that supports AT commands.
> * wwan0 - Primary network interface for IP traffic.

Does not build here (allmodconfig, W=3D1, gcc 11).

drivers/net/wwan/t7xx/t7xx_hif_cldma.c: In function =E2=80=98t7xx_cldma_irq=
_work_cb=E2=80=99:
include/linux/find.h:40:23: error: array subscript =E2=80=98long unsigned i=
nt[0]=E2=80=99 is partly outside array bounds of =E2=80=98u32[1]=E2=80=99 {=
aka =E2=80=98unsigned int[1]=E2=80=99} [-Werror=3Darray-bounds]
   40 |                 val =3D *addr & GENMASK(size - 1, offset);
      |                       ^~~~~
drivers/net/wwan/t7xx/t7xx_hif_cldma.c:569:43: note: while referencing =E2=
=80=98l2_tx_int=E2=80=99
  569 |         u32 l2_tx_int_msk, l2_rx_int_msk, l2_tx_int, l2_rx_int, val;
      |                                           ^~~~~~~~~
In file included from ../include/linux/bitmap.h:9,
                 from ../include/linux/cpumask.h:12,
                 from ../arch/x86/include/asm/paravirt.h:17,
                 from ../arch/x86/include/asm/irqflags.h:63,
                 from ../include/linux/irqflags.h:16,
                 from ../include/linux/rcupdate.h:26,
                 from ../include/linux/rculist.h:11,
                 from ../include/linux/pid.h:5,
                 from ../include/linux/sched.h:14,
                 from ../include/linux/delay.h:23,
                 from ../drivers/net/wwan/t7xx/t7xx_hif_cldma.c:21:
include/linux/find.h:40:23: error: array subscript =E2=80=98long unsigned i=
nt[0]=E2=80=99 is partly outside array bounds of =E2=80=98u32[1]=E2=80=99 {=
aka =E2=80=98unsigned int[1]=E2=80=99} [-Werror=3Darray-bounds]
   40 |                 val =3D *addr & GENMASK(size - 1, offset);
      |                       ^~~~~
drivers/net/wwan/t7xx/t7xx_hif_cldma.c:569:54: note: while referencing =E2=
=80=98l2_rx_int=E2=80=99
  569 |         u32 l2_tx_int_msk, l2_rx_int_msk, l2_tx_int, l2_rx_int, val;
      |                                                      ^~~~~~~~~
