Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCD27D7B7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgI2UKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:10:12 -0400
Received: from mout.gmx.net ([212.227.17.21]:35797 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgI2UKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601410205;
        bh=G6HceT0It0VlXbkDsImh0/RDdHE+KDDap8TVy5//N4o=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dr7ImIkmx8nsv+XPfGIyWN0GxMqnWROpgJjxQJoHIMzdLDaur3BeSRsacm2jAOJQr
         fjky65m8whlw/WCPopzC/yz9jO8SGl0efHzRcm5/gx5bgL3obK1/HWBR93o4S7TbHv
         BdiBZs8Z/UEIqLUbEAH5h+EBE9ESknRH+PpFPObQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1N8XU1-1kRQXU0Idt-014X64; Tue, 29 Sep 2020 22:10:05 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net v2 2/4] via-rhine: VTunknown1 device is really VT8251 South Bridge
Date:   Tue, 29 Sep 2020 13:09:41 -0700
Message-Id: <20200929200943.3364-3-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929200943.3364-1-kevinbrace@gmx.com>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:GW05DPbECrhikbB6dMRNw5XO/0scZtqzrPCR/tViZCEwC2EiZ8G
 oqec+Qc8MVytU2dOgHWBbe//WuTM9wF3oK4Lidb72KtRrzGMn2hD9YdV7fbX9myrQEtlVxd
 i31CnlPhuHhMkJrd1R2q5q7YveR5pgiHzZ1jm3foRvkVhl5854sUULL66pS30eajfsEuZL6
 aVoJ03hhdly3/0y2enbuA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lNVK4CllrZA=:bnfIa5PgiSiKUXaNNYT3Uj
 OkZkEt1yYoSTL0CC17/+Cm8KtHHN4fI6a8KIIt2BUq4nNAyENjpeY8sT5dUWo7lEM4be325Fo
 4PqlwdlA8THoTTe318EqTeJXmWNX0IolS/WwYLucUvCQlMRkAvl4wC6Gs5ax1X+vFZWOtkIF9
 U6t7e/jBuhMksp0ZabNxnn4jTUecKBASxqu89TnE6B+O6c3gLOvCyktvpcs6qcFmBfjZZnxFP
 zu5bfe3mmhvXKXbIYw0YQZ2cpVMCXcdtwi26otXygaqdK4mqb7fpzhhW1+3iGD1Yn8PmPwe+J
 NvtWCbjvSvgvlcTBiXWlTnk8K9mZi8faGXDpQbcWFIKwCckxpEkwmNCB6oBfDqnTTelubyJa6
 rk4K9Y+vB+XtnDno6UokTcFk8QDVOKo58MUtpxTxY1DCAF/MypeEFD625ab4j24IcXWCPsClq
 GkH9KgLzszICG7yuEul3O98rcNnvR2KwaCOa7AZVvWszYdBhjqDtFZi270g5yuWC7I+4FsICH
 VMZqr3l24s3AoahQj2QuG1iR3xe2HTCxzVhi3zwpttl3IGee9qW3zuT79IZ7DmME/QTHpuF+E
 qiajkakMhS0Sbw7AbHG12oLRQ1xZrKCTEjephSWUSxR+JF+yMwwWr+Ge3wTL+9u9nz2zRQ010
 YypmHIoQhkjNC+CbUmgUjiIFpioKJAGuAMUfIC1Lry9ka0H95xfw8P0r6OcnH8/jyH7P3ujw7
 sHFYIevQ5//wrkjlptCg4p4PfJmXizaoS/9aVc4c3gh6kjRiFBq5zZMB6YQw4IaI+H3PJFNNs
 IZGi1nv70doszMfGwGkHj8GuoiZwpBAsaveZ51UzamooLO7pI32j5dlWfthG91CXAz7s3A9Cf
 CS+W5NYXV0BUXKG8P3wSe7pvUbnLSj2CyZxEemxmaIZwXA4CY61Z48Qg5lfzZ3T+2l2Qdhrj5
 EUOlGo67NxxQoRp1+tCZUwlDUaPHjcOfyiVH7cnP/peliuEiyP8DFj3wzPe2cFFPpUDJ6D2PP
 FBxp+jQpDIEiJvSJQZ0HKPYR8jMlYt7F4xAOuGiFsrf1mbr4lSev5gTWodWKobl3Z63toDzuE
 ndLOMKJ9+TJlwdCmcltzbYdwnZcqKDnHglXaydNrdv5/nkhvJoiTUX2CLy90rdc1V3cVm0qbU
 hwA4rmxojfJyFm8d5+9Qy3JRdIodC+CsRiOXNxrC4ruct40JjdmsvFYlkKsjjlzj/RXXrddeP
 StLYQnLcsBBKPUnYWadVR4+YSxEW2LNlsCtSnsw==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

The VIA Technologies VT8251 South Bridge's integrated Rhine-II
Ethernet MAC comes has a PCI revision value of 0x7c.  This was
verified on ASUS P5V800-VM mainboard.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 drivers/net/ethernet/via/via-rhine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index a20492da3407..d3a2be2e75d0 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -243,7 +243,7 @@ enum rhine_revs {
 	VT8233		=3D 0x60,	/* Integrated MAC */
 	VT8235		=3D 0x74,	/* Integrated MAC */
 	VT8237		=3D 0x78,	/* Integrated MAC */
-	VTunknown1	=3D 0x7C,
+	VT8251		=3D 0x7C,	/* Integrated MAC */
 	VT6105		=3D 0x80,
 	VT6105_B0	=3D 0x83,
 	VT6105L		=3D 0x8A,
=2D-
2.17.1

