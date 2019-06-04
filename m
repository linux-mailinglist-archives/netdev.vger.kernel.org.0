Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8290634A22
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfFDOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:19:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfFDOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mHEm7r32i41wuvh2vJqP9wlH6DungDTiNI9w2Kuzi+E=; b=jPFvLa/U3KJt0ExnziAo0Whzxg
        hVvhgBlZbHrctlj7QSwcNNF2S6kBP5kug81KuEGym3pcUCYAjFw+vcEQRq8jeAIiIBYW1AumnhVJe
        IuuU1Vkv1DSe6Vd21/3r3uCKQjwAwi+VFLnaeRbQgVrELhGbMHEMZNdiQVbPEpRU1HlO2pnJXCivZ
        be+Peblso/vKBZ8HxaYuNHXV3hP7m3f89hOs8lKMKZ8LW+xxr67Z3f0ypXpfYEvA40G6ugB4iiF8t
        kcXPdHcOH1j9adMdzcXxRht9j85r4hMx/6J6Ks11nJaKptLYVyZPlEPTB49yqnkB1l55grvGVOIj8
        x3OOchog==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Ru-T2; Tue, 04 Jun 2019 14:18:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002lo-U8; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH v2 17/22] docs: net: sja1105.rst: fix table format
Date:   Tue,  4 Jun 2019 11:17:51 -0300
Message-Id: <562fc336c61138fdd7ab06e95337cb86bfa099fe.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
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
Acked-by: Vladimir Oltean <olteanv@gmail.com>
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

