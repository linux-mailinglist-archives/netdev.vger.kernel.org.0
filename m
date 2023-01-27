Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE36967DDAA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 07:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjA0GkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 01:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjA0GkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 01:40:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A966A302;
        Thu, 26 Jan 2023 22:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qlUJ3CMMUxoxYqDl8JIHZ9anTd1fSJcrpcu8FtmDAao=; b=BIx0ATmWfrFZDlC/MziOy4jRkb
        FDNiawwI+Awc7ZFj7lXnT9GZ4iSBRQumccLjJKEuSBQVTU4s5eAtJKyh86WD7pSXg+vaOcvN0i7U+
        kBFcyMc8E+XmcAHDC0ijljCS6pXLKAkBM0PdkxqUicckxX7ZxtrGduirPksWcHDPW1d3JCjGlHDJP
        L6gNh/lsrGyLFJmKrzwJRAC/ByISF2X02Xnsr53Pjo46lKCXDWXu8LC9oafwrpmHFWbIL+1GSXidO
        U7GgoyyqwSVlnkCS/pOo4Ocq8pzwnAitMKlX/lBEC0nDX/1P0S/8W3qPBgd++H2sEP+IB6s66wCo/
        4/GkDRmg==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLIPD-00DM0u-SQ; Fri, 27 Jan 2023 06:40:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 05/35] Documentation: core-api: correct spelling
Date:   Thu, 26 Jan 2023 22:39:35 -0800
Message-Id: <20230127064005.1558-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127064005.1558-1-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct spelling problems for Documentation/core-api/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/core-api/packing.rst |    2 +-
 Documentation/core-api/padata.rst  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -- a/Documentation/core-api/packing.rst b/Documentation/core-api/packing.rst
--- a/Documentation/core-api/packing.rst
+++ b/Documentation/core-api/packing.rst
@@ -161,6 +161,6 @@ xxx_packing() that calls it using the pr
 
 The packing() function returns an int-encoded error code, which protects the
 programmer against incorrect API use.  The errors are not expected to occur
-durring runtime, therefore it is reasonable for xxx_packing() to return void
+during runtime, therefore it is reasonable for xxx_packing() to return void
 and simply swallow those errors. Optionally it can dump stack or print the
 error description.
diff -- a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
--- a/Documentation/core-api/padata.rst
+++ b/Documentation/core-api/padata.rst
@@ -42,7 +42,7 @@ padata_shells associated with it, each a
 Modifying cpumasks
 ------------------
 
-The CPUs used to run jobs can be changed in two ways, programatically with
+The CPUs used to run jobs can be changed in two ways, programmatically with
 padata_set_cpumask() or via sysfs.  The former is defined::
 
     int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
