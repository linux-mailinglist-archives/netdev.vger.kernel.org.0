Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF441C769A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgEFQfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:35:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52534 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbgEFQfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:35:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GZcW1088886;
        Wed, 6 May 2020 11:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782938;
        bh=vhGRFxrLxPKWXoDZs4vfMZqtTgCc++eaf3Q4SLFft8o=;
        h=From:To:Subject:Date;
        b=lZ50TRZ0paEN1p/9b+d3g0+OzsacvbNyjaG86Wx3k9Dvspdo32iWvLAjNTMFGOIFv
         IinSRtBwCU1rQOj4J85Aj2+c8NgSGZnW/EAHmrNg3Tiug0nt+WNR86Q0/bx65QkWq/
         FT/yPoV+s5Wd7Rgytu43ls3M4JSsWRmbaRFQ7RtU=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GZc5O028097
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:35:38 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:35:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:35:38 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GZbQG128992;
        Wed, 6 May 2020 11:35:37 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 0/2] iproute2: Add PRP support
Date:   Wed, 6 May 2020 12:35:35 -0400
Message-ID: <20200506163537.3958-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the RFC patch series to add prp link type in iproute2. This
is dependent on the kernel patch series with subject line 

"[net-next RFC PATCH 00/13] net: hsr: Add PRP driver

Murali Karicheri (2):
  add support for PRP similar to HSR
  prp: update man page for PRP

 include/uapi/linux/if_link.h |  16 ++++-
 ip/Makefile                  |   5 +-
 ip/iplink_hsr.c              | 111 +++-------------------------------
 ip/iplink_hsr_prp_common.c   | 114 +++++++++++++++++++++++++++++++++++
 ip/iplink_hsr_prp_common.h   |  24 ++++++++
 ip/iplink_prp.c              |  60 ++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++++
 7 files changed, 252 insertions(+), 107 deletions(-)
 create mode 100644 ip/iplink_hsr_prp_common.c
 create mode 100644 ip/iplink_hsr_prp_common.h
 create mode 100644 ip/iplink_prp.c

-- 
2.17.1

