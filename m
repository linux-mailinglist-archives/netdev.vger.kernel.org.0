Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E055F3BF1
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 06:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJDEDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 00:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJDEDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 00:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670B41C139
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 21:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14EABB818ED
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 04:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A234C433C1;
        Tue,  4 Oct 2022 04:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664856209;
        bh=yShIdkwlVnwMduYFpgC5h2l+2dv1h5CPSgulXECm9xs=;
        h=From:To:Cc:Subject:Date:From;
        b=XzSivu/K7dvfufdEvl/2kfMkUkOv+ERgFUUyyju9cebIFB3m8w48k9pCmekgJSOx1
         VUJEhvvL/LN6+qTwobOe5Otd4mlmZAxUrVtC9nB7GEu5eqbtzBgSpSRvIKlcqhke3w
         8PPWn+0ZEHwaALUiWogr5vDh27YvZCvkg2mX/8Kjdqt1bIHDikIA6UeIm/TTQt2GJt
         dWOlsu+WCgUi5hvMHZFmRBH5IEE2laynTX/9vreHeV0JqsoW0e2E0K0w7NxHnaWzTG
         GfYCoF8mdQxGh1NPBO7bNJ6sbfNO1CKirc0uq49B1tYLsNh5PbiRTe43Sho14KPelG
         0WY+kti9MjbqQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, linux@rempel-privat.de,
        andrew@lunn.ch, bagasdotme@gmail.com
Subject: [PATCH net-next] eth: pse: add missing static inlines
Date:   Mon,  3 Oct 2022 21:03:27 -0700
Message-Id: <20221004040327.2034878-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

build bot reports missing 'static inline' qualifiers in the header.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: linux@rempel-privat.de
CC: andrew@lunn.ch
CC: bagasdotme@gmail.com
CC: lkp@intel.com
---
 include/linux/pse-pd/pse.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pse-pd/pse.h b/include/linux/pse-pd/pse.h
index fd1a916eeeba..fb724c65c77b 100644
--- a/include/linux/pse-pd/pse.h
+++ b/include/linux/pse-pd/pse.h
@@ -110,16 +110,16 @@ static inline void pse_control_put(struct pse_control *psec)
 {
 }
 
-int pse_ethtool_get_status(struct pse_control *psec,
-			   struct netlink_ext_ack *extack,
-			   struct pse_control_status *status)
+static inline int pse_ethtool_get_status(struct pse_control *psec,
+					 struct netlink_ext_ack *extack,
+					 struct pse_control_status *status)
 {
 	return -ENOTSUPP;
 }
 
-int pse_ethtool_set_config(struct pse_control *psec,
-			   struct netlink_ext_ack *extack,
-			   const struct pse_control_config *config)
+static inline int pse_ethtool_set_config(struct pse_control *psec,
+					 struct netlink_ext_ack *extack,
+					 const struct pse_control_config *config)
 {
 	return -ENOTSUPP;
 }
-- 
2.37.3

