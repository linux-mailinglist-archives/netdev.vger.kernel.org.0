Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF441E17F1
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgEYW4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:56:06 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:50525 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgEYW4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:56:05 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 5255C8066C;
        Tue, 26 May 2020 10:56:03 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1590447363;
        bh=ZMRob+0ctuRiuZToWIvZ4v9nfwliXnBhCHGT1KikOsE=;
        h=From:To:Cc:Subject:Date;
        b=zTFfBPkHBQ+FkZ34aZyuftnXiCnYplWuyEr7UMfwLIjQzA5Hwt6TiRDGNIdOW0dGS
         tzPKwReGbXqILaGV25t0a/ih0db74NIJqUt7yzgUExevr4C0uPkFqbYIPc7raovpy7
         hEB6mKmEG4b6Mxx9M3/xp7Zabgs4kycigeoD9qdc3nYTxYDYY3vXMl0NkEwEAAfdmI
         vxuiArfa5bgCfQ14LVADtIU0laFabh8ofYUl7UjwOd/a7rc3jMPDHexrUtr1u/tv4C
         hmmaMb/vKECB8c+vzfz+wr+c1ZENXWC8miuNtH+uxn21X1MoOFF+4U5VhzyEl9gk9t
         nSVu7h6YaAOkQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ecc4d030000>; Tue, 26 May 2020 10:56:03 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 11E7113ED4B;
        Tue, 26 May 2020 10:56:02 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 0499C28006C; Tue, 26 May 2020 10:56:03 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: sctp: Fix spelling in Kconfig help
Date:   Tue, 26 May 2020 10:55:59 +1200
Message-Id: <20200525225559.13596-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change 'handeled' to 'handled' in the Kconfig help for SCTP.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 net/sctp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 6e2eb1dd64ed..68934438ee19 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -31,7 +31,7 @@ menuconfig IP_SCTP
 	  homing at either or both ends of an association."
=20
 	  To compile this protocol support as a module, choose M here: the
-	  module will be called sctp. Debug messages are handeled by the
+	  module will be called sctp. Debug messages are handled by the
 	  kernel's dynamic debugging framework.
=20
 	  If in doubt, say N.
--=20
2.25.1

