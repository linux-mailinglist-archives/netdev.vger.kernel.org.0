Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE050339A70
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhCMAar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhCMAac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 19:30:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6283D64F8E;
        Sat, 13 Mar 2021 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615595431;
        bh=p7QJ57lJyKJd5zP8Jy8J9TriIrw3tkV0g0U+pWVY8/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjW7OKlwAVKupN6BviGrpaJaivxN0ynqMfVF8ab9eHy4xSNUyQCqp7lqpdh5qpNiW
         SCz374rpQ2v9NTgN9d9eajMobdMX9+OZoqoxR19EbqbUmYUGUM07m2J+Is9Mti8uES
         QH36KbSHmfcjSbru9LtFa+7A6X9XF6uQXgos6nAudOM+tYYW36Y1Xy9dKRPTjZdDcx
         5CIOAJbhU3DiCVAh/etjbZ/a42Wllymx/2xf0uGSgJPu5zX+BCZrJB19ZLzxoZ7dHC
         KWsOZ69H10/EuKJTZDzkvXYntYrKo/dtLP6PqHeoVCkJMIY5jtT1rcyJ52c83Nanqd
         DF8jpRa/1SKsg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, eranbe@nvidia.com,
        jiri@nvidia.com, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] docs: net: add missing devlink health cmd - trigger
Date:   Fri, 12 Mar 2021 16:30:26 -0800
Message-Id: <20210313003026.1685290-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313003026.1685290-1-kuba@kernel.org>
References: <20210313003026.1685290-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation is missing and it's not very clear what
this callback is for - presumably testing the recovery?

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/devlink/devlink-health.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-health.rst b/Documentation/networking/devlink/devlink-health.rst
index d52c9a605188..e37f77734b5b 100644
--- a/Documentation/networking/devlink/devlink-health.rst
+++ b/Documentation/networking/devlink/devlink-health.rst
@@ -74,6 +74,10 @@ User can access/change each reporter's parameters and driver specific callbacks
      - Allows reporter-related configuration setting.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_RECOVER``
      - Triggers reporter's recovery procedure.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_TEST``
+     - Triggers a fake health event on the reporter. The effects of the test
+       event in terms of recovery flow should follow closely that of a real
+       event.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE``
      - Retrieves current device state related to the reporter.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET``
-- 
2.30.2

