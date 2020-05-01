Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1671C1845
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgEAOp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgEAOpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:11 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8ABF24962;
        Fri,  1 May 2020 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344308;
        bh=pzHxb6+0BMwGBP20XE/vERTkLRS6llr8VQT18db+SvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arNEkdlZAqSVrmeLj1iMEDO/iGxi19RIrtgwZDjU6lG2uKacdBtBVtQ3IWVY/0VLO
         rxccxWfCAkTL7zU/L3IHITQewZxVolg2bMIOyrRWKdTz5tBxHckZIUtFD7DU7xjQJm
         Z1Z/rgZgxGZ6HjwnkGndfC930vZqbfc9iXU2XP8c=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuU-00FCfP-5u; Fri, 01 May 2020 16:45:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 36/37] net: docs: add page_pool.rst to index.rst
Date:   Fri,  1 May 2020 16:44:58 +0200
Message-Id: <393fa67c70efb0a427123bf6903db54205351711.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file is already in ReST format. Add it to the net
index.rst, in order to make it part of the documentation
body.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index f5733ca4fbcb..0186e276690a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -25,6 +25,7 @@ Contents:
    failover
    net_dim
    net_failover
+   page_pool
    phy
    sfp-phylink
    alias
-- 
2.25.4

