Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC414EF49
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAaPOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:14:36 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:53538 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgAaPOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:14:36 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VFEUSS042071;
        Fri, 31 Jan 2020 09:14:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580483670;
        bh=oGFn7FCda5lV95p7QFBd+eBDB4foT+y/egIAbRIGLYc=;
        h=From:To:CC:Subject:Date;
        b=LXxZk9X+REmReSOpHtvghDrZMqxEri6/hwsykvS4WgD+Nxsz1VSZKEo19BxeK5Jym
         zHtp+7t311Ole9CTosX1a5w4ueiCCUhyHjR1+vIuMs8urYZSZyT+khTAuB8a9I3bnq
         YXI6pYp3ZhvdiP9JJHmgzxgD1ZeoOyAlazDbj+RU=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VFEUmL060081
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 09:14:30 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 09:14:29 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 09:14:29 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VFETJ8117450;
        Fri, 31 Jan 2020 09:14:29 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-master 0/1] DP83867 Speed optimization feature
Date:   Fri, 31 Jan 2020 09:11:09 -0600
Message-ID: <20200131151110.31642-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Speed optimization, also known as link downshift, enables fallback to 100M
operation after multiple consecutive failed attempts at Gigabit link
establishment. Such a case could occur if cabling with only four wires
were connected instead of the standard cabling with eight wires.
Speed optimization also supports fallback to 10M if link establishment fails
in Gigabit and in 100M mode.

Speed optimization can be enabled via strap or via register configuration.
The 48 pin devices do not have the ability to strap this feature and the PHY
team suggested to enable this bit for all use cases.

Dan

Dan Murphy (1):
  net: phy: dp83867: Add speed optimization feature

 drivers/net/phy/dp83867.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

-- 
2.25.0

