Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7DB52F40F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiETT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiETT4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:56:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA977C166
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 305DDB82B7E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5396C385AA;
        Fri, 20 May 2022 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653076572;
        bh=my0o/7CaDUYq/AN4Rn0Wuu3kLwyvMGTQUAXM+SEtOSk=;
        h=From:To:Cc:Subject:Date:From;
        b=QJ67aT8VTxZUF968GewvtyC+NgOq/f/2NHRnnFuZTbrMyxT0olDVoGYQWfgWvb8Nn
         ugqnwiAqAY5OXR1iesO+3Fk4NkceYmaI5EwDKY5qyY9YKv74O+OzRQwFUNXWxaQTPp
         P4NPmWzQRqah4NiVIm/1XzULhHFjiavTyYxy23jE9Zqt22f8WcpKwR3iVIrUV/XJSB
         0hNkhxmYpq3H+15rscCEoK5dC+HnnooacQWIFzRxHKPo/bLIyxq2fcYunBS9yVOyAp
         oGOq2Q0PcSRKIDMl1eggFxs/O0AB6tvpeK9puRYYCRRFBsursZ+l2AroYdEt0aBIpk
         fAIfS4U5HxBKg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] eth: silence the GCC 12 array-bounds warnings 
Date:   Fri, 20 May 2022 12:56:02 -0700
Message-Id: <20220520195605.2358489-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence the array-bounds warnings in Ethernet drivers.
v2 uses -Wno-array-bounds directly.

Jakub Kicinski (3):
  eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
  eth: ice: silence the GCC 12 array-bounds warning
  eth: tg3: silence the GCC 12 array-bounds warning

 drivers/net/ethernet/broadcom/Makefile  | 5 +++++
 drivers/net/ethernet/intel/ice/Makefile | 5 +++++
 drivers/net/ethernet/mediatek/Makefile  | 5 +++++
 3 files changed, 15 insertions(+)

-- 
2.34.3

