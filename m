Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE81123E344
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgHFUiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:38:08 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54308 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFUiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 16:38:07 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 076KbDtL064153;
        Thu, 6 Aug 2020 15:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596746233;
        bh=b4KcAyNUt+re+45bPA+cQKYqhRGR7myAHCCc7SPoqXw=;
        h=From:To:Subject:Date;
        b=E3jeXemAixkO0b8J8U09pFXZbqMibDRMQ5tcy8eSmnYGdOEtvxSBpYYKsk+l9NIfG
         dNWXtXxK+drR89Bnu+tv3UupkoAqlB2iVLGH4nmHbqIzsPQyGX0pED4XIhp8hP3hQ7
         gF5HfDcO5OoD/gInsZmhy0DLfItALrPJhfUWFXSU=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 076KbDZ6122693
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Aug 2020 15:37:13 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 6 Aug
 2020 15:37:13 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 6 Aug 2020 15:37:13 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076KbCeh075449;
        Thu, 6 Aug 2020 15:37:12 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <kuznet@ms2.inr.ac.ru>
Subject: [net-next iproute2 PATCH v4 0/2] iplink: hsr: add support for creating PRP device
Date:   Thu, 6 Aug 2020 16:37:10 -0400
Message-ID: <20200806203712.2712-1-m-karicheri2@ti.com>
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
is already merged to net-next and the same can be referenced
at https://www.spinics.net/lists/linux-api/msg42615.html

v3 of the series is rebased to iproute2-next/master at
git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
and send as v4.

Please apply this if looks good.

Murali Karicheri (2):
  iplink: hsr: add support for creating PRP device similar to HSR
  ip: iplink: prp: update man page for new parameter

 ip/iplink_hsr.c       | 19 +++++++++++++++++--
 man/man8/ip-link.8.in |  9 ++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

-- 
2.17.1

