Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3273DC659
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhGaOlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233196AbhGaOlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 10:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3381560BD3;
        Sat, 31 Jul 2021 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627742456;
        bh=sM0qIIYDSM6uxLbTF8xR4+8YYGeZoXUG+nR6TJptVG0=;
        h=From:To:Cc:Subject:Date:From;
        b=YCDueqslvMwOfxLzFMKpmeScRfuuzBAHyHtoe9Ah9F8ahNuRQM9ewEfupGFxvAhWN
         j4Xld27pskoPVVRD/8iSCiJhuaB5fgrsXolMXup87xMqG9kwdEsk9mctnxBRUBZBmj
         mR2dKr3pSiFkUT3YlxVmUnFqARqlKUtRA2eePxFtila2wcTCET0UTOe6LWxoRiwMOG
         wcauUIN/XfyQko+wG2kPzTqUfrtNSIdqpdxnRLtEEbepKUYhygzWf0FBdQYfb/gLAU
         9fT4Cg3zqbE09BD4K0NCE7K4lRnlmUrF6IBaBD2wZJGXjgDKxYDqOpuN3LKs63hlOA
         n7wvdlSiyCOOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: operstates: document IF_OPER_TESTING
Date:   Sat, 31 Jul 2021 07:40:52 -0700
Message-Id: <20210731144052.1000147-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IF_OPER_TESTING is in fact used today.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/operstates.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/operstates.rst b/Documentation/networking/operstates.rst
index f6b9cce5b201..1ee2141e8ef1 100644
--- a/Documentation/networking/operstates.rst
+++ b/Documentation/networking/operstates.rst
@@ -73,7 +73,9 @@ TLV IFLA_OPERSTATE
  state (f.e. VLAN).
 
 IF_OPER_TESTING (4):
- Unused in current kernel.
+ Interface is in testing mode, for example executing driver self-tests
+ or media (cable) test. It can't be used for normal traffic until tests
+ complete.
 
 IF_OPER_DORMANT (5):
  Interface is L1 up, but waiting for an external event, f.e. for a
-- 
2.31.1

