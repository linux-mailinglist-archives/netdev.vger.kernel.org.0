Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8191349102E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 19:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiAQSUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 13:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiAQSUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 13:20:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72279C061574;
        Mon, 17 Jan 2022 10:20:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE83B81151;
        Mon, 17 Jan 2022 18:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0C7C36AE7;
        Mon, 17 Jan 2022 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642443606;
        bh=XqlsuvsI2zGRiD3mhCiQ5ztRlavu05NdmDc6XNOtFlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z82aMkICwVjCVqU9T+ZFcw0IScnG2g7WamSA3SO7CyTEtM/uqHFkDuAJDNLt3xvUK
         VgfzmTM++WlEl+1iIx/+Fz5UitnafnO7L3eUWRbv15vSvibdTAei5wRB8Afcr82kdG
         HNHUbMqaptkxlGfO4uZ6IHVK1tUp0nntQ1AFTFv6gi5mGDstLMVDw+tyQCqlkCcGan
         eKqROs7nixGXj2Yx4XRuZWH+z4uQQ6xacw3BpUsgA/85MOhnpyMUyipxZd7rUlLL/a
         DSXFgo21ZbYfeDsh2qvWSVWixVXDgcjAB5UF4DUfjwTiYnWaLYlHjJVY4lMny2DfVX
         E6L392oEvjbaw==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, lkp@intel.com
Subject: [PATCH wireless v2 2/2] MAINTAINERS: remove extra wireless section
Date:   Mon, 17 Jan 2022 20:19:58 +0200
Message-Id: <20220117181958.3509-2-kvalo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220117181958.3509-1-kvalo@kernel.org>
References: <20220117181958.3509-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's an unneeded and almost empty wireless section in MAINTAINERS, seems to
be leftovers from commit 0e324cf640fb ("MAINTAINERS: changes for wireless"). I
don't see any need for that so let's remove it.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---

v2:

* new patch

 MAINTAINERS | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f67e7dae2c55..ae00e2b5e8dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13441,10 +13441,6 @@ F:	include/net/tls.h
 F:	include/uapi/linux/tls.h
 F:	net/tls/*
 
-NETWORKING [WIRELESS]
-L:	linux-wireless@vger.kernel.org
-Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-
 NETXEN (1/10) GbE SUPPORT
 M:	Manish Chopra <manishc@marvell.com>
 M:	Rahul Verma <rahulv@marvell.com>
-- 
2.20.1

