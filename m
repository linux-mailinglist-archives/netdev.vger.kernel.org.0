Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A64E394D4
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbfFGSyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:54:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732072AbfFGSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mHEm7r32i41wuvh2vJqP9wlH6DungDTiNI9w2Kuzi+E=; b=bBC3KuFZL7+EMxxGJvhoEUBOaH
        V2Bhc3nD6r0vlzs2t7fLzSLuJ1Uf52VIbvI7yOjGxokp/VOes/rGIFvxcgpNTHrHheSybr+59ELSY
        5SoAomcb8l43sOrKfrajCf1G4V4kOvgx1o0LKJZv9clSGzzCG4BdcE2hxxWku2jgrVBHYdsWTqcEl
        tj4HCHdwCID3ZXuClr1ucV7DYb3sYzMQX5vURoZWgB5Mzhf7TaZHmrwtX2h3joHCgwFRMyxhX6C+z
        ETI62aFY9Kox8e1IKXHu3MICyP4z5n5KR84Sd3UtQgKtmjr+ohTAhpdlqtnN1HNOCGVTxK+/0DFZs
        wlFb50dA==;
Received: from [179.181.119.115] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZK0d-0005sa-Ja; Fri, 07 Jun 2019 18:54:39 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hZK0b-0007FN-IJ; Fri, 07 Jun 2019 15:54:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 14/20] docs: net: sja1105.rst: fix table format
Date:   Fri,  7 Jun 2019 15:54:30 -0300
Message-Id: <a2417b1817f946ea56fc944646fba3137037a390.1559933665.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
References: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
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

