Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACF2478A6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgHQVRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:17:46 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54042 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgHQVRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:17:45 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07HLHeKI110454;
        Mon, 17 Aug 2020 16:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597699060;
        bh=+fXjcHIFUBdPO3vLDBX1iXC1f4KJLhxR5aQPbt/Q/H4=;
        h=From:To:Subject:Date;
        b=Smc4nIbrDQt1jB/Ahsjmk6SMwKtckWIcSbIb68fk3pXiajzJNu0CINzcBptu/Itmi
         e8IA8HqZYRs4cQhl9S/zVtNbSeycLdsfEYpH+wY17BnjchaGQgq4RVJBHrq7xZL4mu
         N0eeI7Y9vJNFEJnlYIurflcSc9LLQ32zvYZPEwZ8=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07HLHemw082996
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 16:17:40 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 17
 Aug 2020 16:17:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 17 Aug 2020 16:17:40 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07HLHb8R073931;
        Mon, 17 Aug 2020 16:17:38 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>
Subject: [PATCH iproute2 v5 0/2] iplink: hsr: add support for creating PRP device
Date:   Mon, 17 Aug 2020 17:17:35 -0400
Message-ID: <20200817211737.576-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enhances the iproute2 iplink module to add support
for creating PRP device similar to HSR. The kernel part of this
is already merged to v5.9 master

v4 - addressed comment from Stephen Hemminger
   - Sending this with a iproute2 prefix so that this can
     be merged to v5.9 iprout2 if possible.
v3 of the series is rebased to iproute2-next/master at
git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
and send as v4.

Please apply this if looks good.


Murali Karicheri (2):
  iplink: hsr: add support for creating PRP device similar to HSR
  ip: iplink: prp: update man page for new parameter

 ip/iplink_hsr.c       | 17 +++++++++++++++--
 man/man8/ip-link.8.in |  9 ++++++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.17.1

