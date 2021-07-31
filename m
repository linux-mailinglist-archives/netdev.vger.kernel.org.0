Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851863DC657
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhGaOkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhGaOkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 10:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F50960C3F;
        Sat, 31 Jul 2021 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627742412;
        bh=9w96jE3kBxCB5zl0EAoh95n9JLkJjpWwO1VSUFx433Q=;
        h=From:To:Cc:Subject:Date:From;
        b=mpdhzb+MRaVB3x84SckQJkVYzbjDaAQageG4qY+iKVduSlufMP5OBg5unhOO/uDLq
         Xio+xmX02pgxOi+9nyu/RqRUvYzzEkMXc2uSXyBuDuuDOGfbj0NB2A5TPS6ZFj186w
         fzu/6JLqpJga/JZwK8jFIqlH6vP9uaxm+GdwchwIbdigcAawhrjhGUgvjhyVW39Yzx
         R5f0R1c+W2mV5xYZzwkGDek9K35Q7sz6sW/lSBCCYq/k/vK//20+ER0WGKyvG4GzVW
         e76PtrBrdNSbbw0TDXsmSaCJSMfSrmB7WfRLIHK8fsyza7YjPMR0dJEoPyUuAdg7q8
         HFu9oOMP5Hjrw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: operstates: fix typo
Date:   Sat, 31 Jul 2021 07:40:07 -0700
Message-Id: <20210731144007.994515-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TVL -> TLV

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/operstates.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/operstates.rst b/Documentation/networking/operstates.rst
index 9c918f7cb0e8..f6b9cce5b201 100644
--- a/Documentation/networking/operstates.rst
+++ b/Documentation/networking/operstates.rst
@@ -111,7 +111,7 @@ it as lower layer.
 
 Note that for certain kind of soft-devices, which are not managing any
 real hardware, it is possible to set this bit from userspace.  One
-should use TVL IFLA_CARRIER to do so.
+should use TLV IFLA_CARRIER to do so.
 
 netif_carrier_ok() can be used to query that bit.
 
-- 
2.31.1

