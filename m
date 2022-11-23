Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAD2634F3A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiKWEzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiKWEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48495E0685
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C67ADB81E9A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9FC433B5;
        Wed, 23 Nov 2022 04:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179311;
        bh=izjQdC0/I1VUM68JTx8+eR6etiFBB7W3cFIbDtbxh+4=;
        h=From:To:Cc:Subject:Date:From;
        b=YFtSOQEMSdKWtXsnla7b91AFISTGOcsP7PrKa1eetg337uMwPO5cZA8L3gxj7kIZj
         4P2TbXo/SEZLoDrhz8fbeYrJmQCQbLYK5IWaqMs6ED6AbYghKstdp8Mi5hLyTRllQB
         ykjEshbkSmCTZElsn1cGl2SDatN0QwTMjWCt4/2/Us19smj+c/6hZUFGRshPYUp+wb
         o3w+pq286PsoWQaWBGx66wxXHYUSsV0igEsSUU1ocbiqBo0Gjjb+wLBIEM+cvWCttw
         ClLXbmFBaE3ozvF6MigvldAPGyQ26FZpWvduGTOapkJuT+dCEtIlckheOZF+mTa478
         GyvPiigAmbxPA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/12] net: Complete conversion to i2c_probe_new
Date:   Tue, 22 Nov 2022 20:54:55 -0800
Message-Id: <20221123045507.2091409-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reposting for Uwe the networking slice of his mega-series:
https://lore.kernel.org/all/20221118224540.619276-1-uwe@kleine-koenig.org/
so that our build bot can confirm the obvious.

fix mlx5 -> mlxsw while at it.

v2: pull the prep into net-next first

Uwe Kleine-König (12):
  net: dsa: lan9303: Convert to i2c's .probe_new()
  net: dsa: microchip: ksz9477: Convert to i2c's .probe_new()
  net: dsa: xrs700x: Convert to i2c's .probe_new()
  net/mlxsw: Convert to i2c's .probe_new()
  nfc: microread: Convert to i2c's .probe_new()
  nfc: mrvl: Convert to i2c's .probe_new()
  NFC: nxp-nci: Convert to i2c's .probe_new()
  nfc: pn533: Convert to i2c's .probe_new()
  nfc: pn544: Convert to i2c's .probe_new()
  nfc: s3fwrn5: Convert to i2c's .probe_new()
  nfc: st-nci: Convert to i2c's .probe_new()
  nfc: st21nfca: i2c: Convert to i2c's .probe_new()

 drivers/net/dsa/lan9303_i2c.c             | 5 ++---
 drivers/net/dsa/microchip/ksz9477_i2c.c   | 5 ++---
 drivers/net/dsa/xrs700x/xrs700x_i2c.c     | 5 ++---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 6 +++---
 drivers/nfc/microread/i2c.c               | 5 ++---
 drivers/nfc/nfcmrvl/i2c.c                 | 5 ++---
 drivers/nfc/nxp-nci/i2c.c                 | 5 ++---
 drivers/nfc/pn533/i2c.c                   | 5 ++---
 drivers/nfc/pn544/i2c.c                   | 5 ++---
 drivers/nfc/s3fwrn5/i2c.c                 | 5 ++---
 drivers/nfc/st-nci/i2c.c                  | 5 ++---
 drivers/nfc/st21nfca/i2c.c                | 5 ++---
 12 files changed, 25 insertions(+), 36 deletions(-)

-- 
2.38.1

