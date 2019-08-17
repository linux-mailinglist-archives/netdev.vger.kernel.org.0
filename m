Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543E791096
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfHQNbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:31:13 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36645 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfHQNbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:31:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 793F4AA9;
        Sat, 17 Aug 2019 09:31:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Z+9Mx8+bhfHdatoLj4O1iCh930PuLiRRKdim7/PgPx0=; b=bhS4nXlL
        xxlrpScqkwX/obR+P53QMhfwcI6PWb9vz6dECC14n36t/irnp8eSCrs4CRvubr5I
        kBpEHvNlTPZB7PtBFPboLw06ybP/WNZbYHDLWCd42z1KYW5kOyl2C7zlQN14zOWh
        5D4tuoqB14CVDIH403ivE8sLy54khDI4+iyXaWJK5dy68JI2pYEs6Ia8bF59ENxE
        UZo98i8KCHvvTZtdmIcSzztAbuCPbvulS6oJ3EIaRGZFhRFfp3gpJ9YaM022IT2B
        jSYh8xyaaPogOmITeW5+zTowrUyMW9mLQDDZuFVDsp7bx4L9iaFP30s2PBiFY7yB
        fCezv6Bzy/lFNA==
X-ME-Sender: <xms:oAFYXXJAQzep2jLAg5stkROinUWtPXu3Fvgw6h07ib8FoPX_92eyDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudeg
X-ME-Proxy: <xmx:oAFYXRH-kLV0TiCe_J8y1-cqGd2Z6yL4G25073DB2e-AzvXYr_jqCQ>
    <xmx:oAFYXc0SGe4Ynr4fy3Mjck5gjylmyElQsm2CL0EE3PS9_dOGEQFSTA>
    <xmx:oAFYXRI6d5v2H3uKLsa7x7NjPUGmz8ju6GZ542JdwUoGP_l-I7YmAA>
    <xmx:oAFYXWjb2QcQFhkg0Pn24iQwRvNTLR9LFaReF0By7uOiH1wrAQAqug>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4AE9A80060;
        Sat, 17 Aug 2019 09:31:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 16/16] Documentation: Add a section for devlink-trap testing
Date:   Sat, 17 Aug 2019 16:28:25 +0300
Message-Id: <20190817132825.29790-17-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index fe4f6e149623..c20c7c483664 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -196,3 +196,13 @@ narrow. The description of these groups must be added to the following table:
    * - ``buffer_drops``
      - Contains packet traps for packets that were dropped by the device due to
        an enqueue decision
+
+Testing
+=======
+
+See ``tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh`` for a
+test covering the core infrastructure. Test cases should be added for any new
+functionality.
+
+Device drivers should focus their tests on device-specific functionality, such
+as the triggering of supported packet traps.
-- 
2.21.0

