Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5B423AC4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhJFJrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237966AbhJFJqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACAE61042;
        Wed,  6 Oct 2021 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513503;
        bh=XowIppL/KzHC69bciPwXEUNPJLCa8thkeUAi+9/glwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGPeBQN5rLCQ3BQREXSbD8SW7uB2BxK64ZO+oiaUw2/NX/UjkPen980D00T2ztdit
         cT/rUXG5GaLy87m05uuKFvMarc73Nz7qX4Xx8oKYu8FTtyVw9wviig+02BVPFM/eT5
         16iAZml2nKFMrtvqBXXrYpEzJk+9OPx9z5KJFCDxdwFdrYLKg2mWIEATOfohBeJIP8
         fFu4NoMcx8bX8IrEgwKTEJyN/gzwAVccq26NsiZ2ZG+9Pm2bKNiu/rSofuhRQvFHv9
         9Xe7g2Wf7Y9ag64b6rcM2qfquUDyPMtIFU/VndcM6fWR0Y4VmNpoYCExIuApQczDYs
         ybPOjtyjHkWIQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     jiri@nvidia.com, stephen@networkplumber.org, dsahern@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next 3/3] man: devlink-port: remove extra .br
Date:   Wed,  6 Oct 2021 11:44:55 +0200
Message-Id: <20211006094455.138504-3-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006094455.138504-1-atenart@kernel.org>
References: <20211006094455.138504-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br. were added between options of the same command. That is not needed
and makes the output to be one 3 lines for no particular reason.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 man/man8/devlink-port.8 | 2 --
 1 file changed, 2 deletions(-)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index e5686deae573..e48c573578ca 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -52,10 +52,8 @@ devlink-port \- devlink port configuration
 .IR FLAVOUR " ]"
 .RB "[ " pcipf
 .IR PFNUMBER " ]"
-.br
 .RB "[ " sfnum
 .IR SFNUMBER " ]"
-.br
 .RB "[ " controller
 .IR CNUM " ]"
 .br
-- 
2.31.1

