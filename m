Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C805527894
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 17:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiEOP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiEOP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 11:56:33 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E5813F80
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 08:56:32 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id qGbcngusBVfTCqGbdnSibo; Sun, 15 May 2022 17:56:31 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 15 May 2022 17:56:31 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sburla@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] octeon_ep: Fix the error handling path of octep_request_irqs()
Date:   Sun, 15 May 2022 17:56:25 +0200
Message-Id: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I send a small serie to ease review and because I'm sighly less confident with
the 2nd patch.

They are related to the same Fixes: tag, so they obviously could be merged if
it is preferred.

Christophe JAILLET (2):
  octeon_ep: Fix a memory leak in the error handling path of
    octep_request_irqs()
  octeon_ep: Fix irq releasing in the error handling path of
    octep_request_irqs()

 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.34.1

