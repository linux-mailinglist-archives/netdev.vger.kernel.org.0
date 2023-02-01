Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3E686DCA
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjBASU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjBASUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AB57C301
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F6526190F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6E7C433EF;
        Wed,  1 Feb 2023 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275619;
        bh=5Luc8OaAwDWxPdGHuq6/ORN2Y3RaEYS/ccM4pWE4YkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUPOnSwUD4QI1MIzvITB8zVEuS4O4O3hOeKRuHKK9KdEczWSCLQMG12zkD0LUfPJv
         jddHPSBp0dNw6NWzslZ+lFAXnaLeMQmLy0kT96grHx3VlycNcNWWRLo2ny+4g2QMmC
         Ip1DO18xII1GSRY+HwXm0SMXSpLpzfZB7onViBTb547t7sAo3WjEG2/DFu6JwcwqQV
         flNSi4Le/0Tee8Y3eJb3/gSkAfesKg0vr9Ya1rHYo9Y+nlee8eXX94tve/7qUG0y3L
         xKe6e2g1Z5gvnqDz4sEGIQr4tIZu5Cy5kI/TuJPVG+O2OyVhO+Sr6H2kpGGnXnKE23
         fgMhpAb21jQ9Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, john@phrozen.org,
        nbd@nbd.name, lorenzo@kernel.org
Subject: [PATCH net 2/4] mailmap: add John Crispin's entry
Date:   Wed,  1 Feb 2023 10:20:12 -0800
Message-Id: <20230201182014.2362044-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201182014.2362044-1-kuba@kernel.org>
References: <20230201182014.2362044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John has not been CCed on some of the fixes which perhaps resulted
in the lack of review tags:

Subsystem MEDIATEK ETHERNET DRIVER
  Changes 50 / 295 (16%)
  Last activity: 2023-01-17
  Felix Fietkau <nbd@nbd.name>:
    Author 8bd8dcc5e47f 2022-11-18 00:00:00 33
    Tags 8bd8dcc5e47f 2022-11-18 00:00:00 38
  John Crispin <john@phrozen.org>:
  Sean Wang <sean.wang@mediatek.com>:
    Author 880c2d4b2fdf 2019-06-03 00:00:00 7
    Tags a5d75538295b 2020-04-07 00:00:00 10
  Mark Lee <Mark-MC.Lee@mediatek.com>:
    Author 8d66a8183d0c 2019-11-14 00:00:00 4
    Tags 8d66a8183d0c 2019-11-14 00:00:00 4
  Lorenzo Bianconi <lorenzo@kernel.org>:
    Author 08a764a7c51b 2023-01-17 00:00:00 68
    Tags 08a764a7c51b 2023-01-17 00:00:00 74
  Top reviewers:
    [12]: leonro@nvidia.com
    [6]: f.fainelli@gmail.com
    [6]: andrew@lunn.ch
  INACTIVE MAINTAINER John Crispin <john@phrozen.org>

map his old address to the up to date one.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Cc: john@phrozen.org
Cc: nbd@nbd.name
Cc: lorenzo@kernel.org
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 8deff4cec169..ac3decd2c756 100644
--- a/.mailmap
+++ b/.mailmap
@@ -214,6 +214,7 @@ Jisheng Zhang <jszhang@kernel.org> <jszhang@marvell.com>
 Jisheng Zhang <jszhang@kernel.org> <Jisheng.Zhang@synaptics.com>
 Johan Hovold <johan@kernel.org> <jhovold@gmail.com>
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
+John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
 Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
-- 
2.39.1

