Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E686900C6
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBIHOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBIHOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:14:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F2C1B33C;
        Wed,  8 Feb 2023 23:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ne9BZXE2iGM8OzEUId4GcMH1B4GCk5QE1QnyEU0ZMDY=; b=Gnu931rUugqu6/NTy96e4cSCb3
        YMPfyooaHOAUgFp2TnsirmkhX4rtEbdKrfewKNx1cnlLYCehfbOc9rSYcVTJTAkB3zXuXfkpMFO/c
        +QbVHWMs5e2kq8xc7DyTdNV1mM2dnSGs5Oua2etemHzKoCVzIwNUZ1SUlRbu4Xou4+f6So4bLMynB
        GE28fgtIFXNhXmNMBZoOj0ptK/DcpORE3poIdIrEE76JMeobIljmWeD67pj3GiHoHdgH9WkVpC/00
        PQSlm4vi5Q65OIzZdOpfIABFn8OVhuPjWZm5vMDlxw9PiRJmXr6pPrt+6euJsGLGQW4/FMz5bUR1s
        5W4QgASA==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQ18A-000LPt-Bf; Thu, 09 Feb 2023 07:14:06 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Mukesh Ojha <quic_mojha@quicinc.com>
Subject: [PATCH 03/24] Documentation: core-api: correct spelling
Date:   Wed,  8 Feb 2023 23:13:39 -0800
Message-Id: <20230209071400.31476-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209071400.31476-1-rdunlap@infradead.org>
References: <20230209071400.31476-1-rdunlap@infradead.org>
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
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
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
