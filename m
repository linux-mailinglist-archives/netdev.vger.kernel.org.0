Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7354632CCB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKUTQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiKUTQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506D5D39F3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 031B2B815C8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82742C433C1;
        Mon, 21 Nov 2022 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058148;
        bh=Ocq8Na86H7gzyPdQCYQb+kRB2CBifmolNvKidJc+O60=;
        h=From:To:Cc:Subject:Date:From;
        b=TmxuJABrmX/mBq4SqFdnrI7sJ+VvDHAKTpCGiAsg6LGd8RGAAb6SgTL6oAZtaoF4M
         vruJbK4KCFv82ly4M6i/YYg/+TkzOuenavu0fAlD/uATP7OMu4cXY4W9PIz8dWCL4D
         4TI2+dOkighl22kCa++KKUtCkKqC/iUFqKlN9fcZbI3ioQlUw42YEuYimFvP7ai8Yt
         27HVsYtjsmb/ctKbz3isddCL4Srp6FLBMmeWrzD2f+a6yggv2i6lpE0ldPJMhMfI+C
         eGlb/u1qoCxVhqkeBHF45mBr2s6TF0deA40OOAgVQFf+6qv4Ab5Ilbn3LeeDTYCBW/
         k67NxfLjVXKuw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] net: Complete conversion to i2c_probe_new
Date:   Mon, 21 Nov 2022 11:15:34 -0800
Message-Id: <20221121191546.1853970-1-kuba@kernel.org>
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

