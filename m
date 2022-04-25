Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C440E50EBA5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiDYWYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbiDYV3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55A8220CE;
        Mon, 25 Apr 2022 14:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF016147E;
        Mon, 25 Apr 2022 21:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64745C385A4;
        Mon, 25 Apr 2022 21:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650922009;
        bh=2a6f0s0gfgQOFCVygX88D/Jy9FT1s2II/UBEFfZwGmU=;
        h=From:To:Cc:Subject:Date:From;
        b=JzoZI6Thq9FaEgO3Mkkbp4aFCZ3Z7SguW+p4EFcL/hZwSR71eWB7lQrtCdStFiwJC
         D1lPI1kl/uUpuHDl39mZR33MBDxQfDwUZcMx2SOy8esXcCAupoEdZ86ahHPPsUFq+A
         JW4VUzQSpKpID+SI91ORDXSUAEiRDLsbzLhKFSgCZQ15+6n37sCSLPSKpNF5s2mG5f
         YariGsa+QPrpVyHoYSKQJpukgLJFnbYGqFIv36Zt/sswY+hMhqKvhMnSbLTTgeE31A
         oKKpvQMEKelT7D27Rauoujy0YlPFS8O0rD0kkaRnWGhQf+ZfoAYH4GrM+RJ0lCvqCb
         M/zD88dCkupKw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/2] net: Remove unused __SLOW_DOWN_IO
Date:   Mon, 25 Apr 2022 16:26:42 -0500
Message-Id: <20220425212644.1659070-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Remove unused mentions of __SLOW_DOWN_IO.

Bjorn Helgaas (2):
  net: wan: atp: remove unused eeprom_delay()
  net: remove comments that mention obsolete __SLOW_DOWN_IO

 drivers/atm/nicstarmac.c                     | 5 -----
 drivers/net/ethernet/dec/tulip/winbond-840.c | 2 --
 drivers/net/ethernet/natsemi/natsemi.c       | 2 --
 drivers/net/ethernet/realtek/atp.h           | 4 ----
 4 files changed, 13 deletions(-)

-- 
2.25.1

