Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847C36975EC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjBOFhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBOFht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:37:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966A35AD;
        Tue, 14 Feb 2023 21:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3DQRN1CQ/XqMIvWvWF20UaQJ2HBfRPScgCtiXy5hN3U=; b=0QJivvrrBkYjIm/Kknb4P6rRrs
        BKrobwAo5ZXdvux1S1ecaeoPJPKkizTrANRjU81ZgVqaNP0h7B3KkGolSUCQkoMMbpttfDEHOTOWV
        zjX79Yrx/22jG8Atz7dvW0BJvZap8cTqfqrtHCEFXTM6WhDlFUnWkRyp8HTlpwORelLpfX3snX5sG
        i5otESatwnG4WHvurojSVUhXHNYVa0AbiUbg+Uzi/ptDLo5/GogrvRIbDYEcrv/DDw9eBIG5VxDkm
        gJYPJv/s2Qhrs9ixykTQ++VwszhVhySVGYzT9eBY8erwAmk8qgk4Yh3U2JVN9ZRh6Nalg1iwSKEkO
        MiAmSbFA==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSAUD-004naN-Ga; Wed, 15 Feb 2023 05:37:45 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>
Subject: [PATCH v3] Documentation: core-api: padata: correct spelling
Date:   Tue, 14 Feb 2023 21:37:44 -0800
Message-Id: <20230215053744.11716-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
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

Correct spelling problems for Documentation/core-api/padata.rst as
reported by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
v3: split into a separate patch as requested by Jakub.

 Documentation/core-api/padata.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
