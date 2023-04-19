Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355646E7C0A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDSOO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjDSOOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4631791D;
        Wed, 19 Apr 2023 07:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41AF060C12;
        Wed, 19 Apr 2023 14:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10608C433D2;
        Wed, 19 Apr 2023 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681913602;
        bh=+p00QP5/h9exgjfULX2JyvDzcIbvbzctcsjVv6xlmMc=;
        h=From:To:Cc:Subject:Date:From;
        b=IDY7onV1awLB/okgBqSnektZLne3XQ4x/E4ZrV3XasMFc2g9d5izJ8sT+LAiTDv1/
         +3QW7++ST1o7gNglup2lP5uG22naWQOuGmLqshOVVMGtkSdDRVyq72DcJX8+PlOoDk
         GZ5SakFMlZPYugu47gi7OLPjG3JkD398W1ysmGXd03xWdiBYKNeowKhu2xo/ISSmyC
         oYIEVVZV+xDnfqAQYn3KGFcwThuMf/8uVTyKxeJpoNd6vcuEpJp5jjgkEewNwyz+N+
         wBUhMfB/5CZJkb1zO4LkuW7MRhEKlGh/10MpoRiLXrUGLEoGxhxFdYDq5zjBd3WMXO
         fatyMHXbsHkgQ==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Hal Feng <hal.feng@starfivetech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Samin Guo <samin.guo@starfivetech.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: linux-next: manual merge of the net-next tree with the clk tree
Date:   Wed, 19 Apr 2023 15:13:14 +0100
Message-Id: <20230419141314.76640-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  MAINTAINERS

between commit:

  63a30e1f44d5e ("MAINTAINERS: generalise StarFive clk/reset entries")

from the clk tree and commit:

  b76eaf7d7ede3 ("dt-bindings: net: Add support StarFive dwmac")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc MAINTAINERS
index 8c77a6a3f2c56,4fc57dfd5fd0a..0000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -19911,6 -19928,20 +19937,13 @@@ M:	Emil Renner Berthing <kernel@esmil.d
  S:	Maintained
  F:	arch/riscv/boot/dts/starfive/
  
+ STARFIVE DWMAC GLUE LAYER
+ M:	Emil Renner Berthing <kernel@esmil.dk>
+ M:	Samin Guo <samin.guo@starfivetech.com>
+ S:	Maintained
+ F:	Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
+ F:	drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
+ 
 -STARFIVE JH7100 CLOCK DRIVERS
 -M:	Emil Renner Berthing <kernel@esmil.dk>
 -S:	Maintained
 -F:	Documentation/devicetree/bindings/clock/starfive,jh7100-*.yaml
 -F:	drivers/clk/starfive/clk-starfive-jh7100*
 -F:	include/dt-bindings/clock/starfive-jh7100*.h
 -
  STARFIVE JH7110 MMC/SD/SDIO DRIVER
  M:	William Qiu <william.qiu@starfivetech.com>
  S:	Supported
