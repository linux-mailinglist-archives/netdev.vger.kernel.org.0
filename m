Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB0BF207
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfIZLoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:44:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50653 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbfIZLoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:44:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 84BEC21B8B;
        Thu, 26 Sep 2019 07:44:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Sep 2019 07:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HQkMv389+W0vaHyRgQj+Lu+Gov3yBhv0Ji6dsPWgGWE=; b=GXexsKFu
        gfRs2Mpc0q8bjZPcyLMaviOPUjNgJJhsCXvPJANDeBJcQTVphy7rkAfUfdbE4PFI
        Ws8oTetoeKuCwUDKAx+hN7bUaRs7T0oEWC5EQQ6fcUt5qkCx63CGFuLZcMLjeZS4
        gyXxGEdRPNIdzs/N07Zp7RHZtIMG7Kc9v1ThbpFf9WMt3Vsn6bU+WWFhVlNq9iGd
        BLMIwFtpkC+psyP4mzEUJmOMSupAWIlR64MCOZlRrYXpruhHRhKYEOK8Q0cFUBED
        RoODNaP1RF4BrXJHnUOO7KKWvu5GPCNs011S6oLRV8e4QLvFEQm7ad9RQToBhzri
        CjJ0cpx/iwRbXA==
X-ME-Sender: <xms:l6SMXbSjT_gxRNqz4lmcpCPf_R7-FeVQ8rcve6oiYvt2F969mvvfBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:l6SMXRBhEepHPEIdo4Uf142A6Mtk1SUtjSsI-5BsI53O_s1Ya9n1Ow>
    <xmx:l6SMXb2gBWMUSLndXQWpGzFdyU6OC4sGVhtRUBUte9T7E8_OMu19nw>
    <xmx:l6SMXfVHClt_BBw6GYVHQwrtEvoxhMd7IUQdJvfQzb7MbTE1s1qAhg>
    <xmx:l6SMXZRr6g2roF8xuHc0kPe1uwxqg0rtzd5YqSqQ-c0KtKvnd-R1QQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27FE680063;
        Thu, 26 Sep 2019 07:44:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/3] Documentation: Clarify trap's description
Date:   Thu, 26 Sep 2019 14:43:39 +0300
Message-Id: <20190926114340.9483-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926114340.9483-1-idosch@idosch.org>
References: <20190926114340.9483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Alex noted that the below description might not be obvious to all users.
Clarify it by adding an example.

Fixes: f3047ca01f12 ("Documentation: Add devlink-trap documentation")
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Reviewed-by: Alex Kushnarov <alexanderk@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index c20c7c483664..8e90a85f3bd5 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -143,7 +143,8 @@ be added to the following table:
    * - ``port_list_is_empty``
      - ``drop``
      - Traps packets that the device decided to drop in case they need to be
-       flooded and the flood list is empty
+       flooded (e.g., unknown unicast, unregistered multicast) and there are
+       no ports the packets should be flooded to
    * - ``port_loopback_filter``
      - ``drop``
      - Traps packets that the device decided to drop in case after layer 2
-- 
2.21.0

