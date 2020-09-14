Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FEC269287
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgINRHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:07:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45308 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgINRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:06:50 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08EH6dnr084797;
        Mon, 14 Sep 2020 12:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600103199;
        bh=AhFiLuygFh+2yYIkixEOIzQQVa2U789K+AxFzRU6O/I=;
        h=From:To:CC:Subject:Date;
        b=jFis8ZHFwrn7383XiV5B3ENtKNnN+1Y3X+z/MZPaHHNJNLSpejHt39rCo3n4OI4Xn
         18yCez93tII7sYMn3jF9kpCmyBdW+X+GeCF750ZlNXNmtmKIakfsbhzL58SnI+SRAp
         S3EoQrlVHkuWWb+YJWOs1aasTATWLHAAwuI7TFPQ=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08EH6dPI084385;
        Mon, 14 Sep 2020 12:06:39 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 14
 Sep 2020 12:06:39 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 14 Sep 2020 12:06:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08EH6dwG008867;
        Mon, 14 Sep 2020 12:06:39 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 0/1] Adding 100base FX support
Date:   Mon, 14 Sep 2020 12:06:37 -0500
Message-ID: <20200914170638.22451-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

I am adding the 100base Fx support for the ethtool.  There are a few PHYs that
support the Fiber connection and the ethtool should be able to properly display
that the PHY supports the 100base-FX Full and Half Duplex modes.

I am adding this support in the ethtool first and then submit the fiber bits
into the kernel.

If the kernel needs to be updated first then I can prepare those patches and
reference them.

Dan

Dan Murphy (1):
  ethtool: Add 100BaseFX half and full duplex link modes

 ethtool.c            | 6 ++++++
 netlink/settings.c   | 2 ++
 uapi/linux/ethtool.h | 2 ++
 3 files changed, 10 insertions(+)

-- 
2.28.0

