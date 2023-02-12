Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A92C693939
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBLSBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 13:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBLSBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 13:01:09 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CC3593
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:Message-Id:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yIdGBfeyjdZPazlRN8Y4jgtlUUTjlHmelO5IISCY0HM=; b=Lv5/cLXaM7SMw1I/IQp7pV6mmf
        CThuE/EVsSMLzqFmkTYk6seuHcSDtucFPwv6npUovPDuLEG580x7SFMkHhuTb4SQI2rYHaUT3CoPa
        20GHR4ZnBrAmmU+jNsMJPJYvLKia+qBMVc2bUuDuMHBAwuY3mtw/2Ft4eV2hrB/dp4T3PDfElljMY
        DzGPG4TyxUfkHpOgzF8OAjRI/PW2/TIY4e9RitJiVigIiPO8fSr6Qpp1X+fzJqUz3+uemJrYG2dSm
        iZu9WhEUWgxEXovUW0PuUGMO+kVxR7JsMAk9ANFtC8T43Ju6XGn+kM6xTYsS3YJxSHED1Ah2XSsC/
        8XXJjGDg==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRGeo-003ZnT-AX; Sun, 12 Feb 2023 18:00:58 +0000
Message-Id: <cover.1676221818.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 12 Feb 2023 09:10:18 -0800
Subject: [PATCH net v5 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 12 Feb 2023 18:00:58 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5: Some additional patch cleanups.
v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 94 +++++++++++---------
 1 file changed, 52 insertions(+), 42 deletions(-)

-- 
2.34.1

