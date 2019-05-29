Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73C92E908
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE2XYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:24:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfE2XYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lOs9I1Q5TpHdV0azkZFthZRFM+snH/1rUpp9utXdcSE=; b=FU9ElF6P6lDqm6h3dPoEvUwUlc
        5BD+FUXSYe7zSQRHkrVztejCXjsIaKev8lALU7oVJ64JzZA5cyHpwPncRh2NgsSLDawp0DPoavepd
        /gWEoLnTYHLug8tei36FbEiTZ38E+fGlPPuP3tQj6m8dvewPf4mAGLY/hX0c+lv0qiuQVZ+Ch8uQP
        FC10E8C7qBMYcqXWzxYRfavgM2lf20qmsZOZhmrglFVf9p3/6DhUPz+e+prnXW0h4n5v1VkOJoS7Z
        EYTsFgKsT5m4FF/yT6E9ArW3fi6nSIngNii9bzTEkifsZ9FG04a5EGtJwueN09rKrRRO69PdFtsgr
        ttC5KLcQ==;
Received: from 177.132.232.81.dynamic.adsl.gvt.net.br ([177.132.232.81] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hW7vL-0005Rt-EW; Wed, 29 May 2019 23:23:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hW7vJ-0007yA-10; Wed, 29 May 2019 20:23:57 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 21/22] docs: net: sja1105.rst: fix table format
Date:   Wed, 29 May 2019 20:23:52 -0300
Message-Id: <c8f6ddd2d538e36f6036681f5756f6ea9499039f.1559171394.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559171394.git.mchehab+samsung@kernel.org>
References: <cover.1559171394.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a table there with produces two warnings when built
with Sphinx:

    Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.
    Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.

It will still produce a table, but the html output is wrong, as
it won't interpret the second line as the continuation for the
first ones, because identation doesn't match.

After the change, the output looks a way better and we got rid
of two warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/networking/dsa/sja1105.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index ea7bac438cfd..cb2858dece93 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -86,13 +86,13 @@ functionality.
 The following traffic modes are supported over the switch netdevices:
 
 +--------------------+------------+------------------+------------------+
-|                    | Standalone |   Bridged with   |   Bridged with   |
-|                    |    ports   | vlan_filtering 0 | vlan_filtering 1 |
+|                    | Standalone | Bridged with     | Bridged with     |
+|                    | ports      | vlan_filtering 0 | vlan_filtering 1 |
 +====================+============+==================+==================+
 | Regular traffic    |     Yes    |       Yes        |  No (use master) |
 +--------------------+------------+------------------+------------------+
 | Management traffic |     Yes    |       Yes        |       Yes        |
-|    (BPDU, PTP)     |            |                  |                  |
+| (BPDU, PTP)        |            |                  |                  |
 +--------------------+------------+------------------+------------------+
 
 Switching features
-- 
2.21.0

