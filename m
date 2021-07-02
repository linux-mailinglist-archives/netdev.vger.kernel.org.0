Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5B3B9F96
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhGBLTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:19:09 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33918 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230498AbhGBLTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 07:19:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DB8A346759;
        Fri,  2 Jul 2021 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1625224593; x=
        1627038994; bh=LT52yX2+1sgdqwo6AJLkCSNgc56psjUMyc9SnqouNRc=; b=t
        urOmgmPPa+oOyMmrYIMCU+zcLdgK1d6zizAPaObiI2tazyhsnUtu49dsYopKu9QG
        gjLSvA68DTuDEkQOCVuxxtpz4eMCMtFVu7xxPJDXZ7br1lTmabe0E1a8o73n5voR
        UOrG/WnIfpb8mdGUQk00vXW+WmQWdPpgHjYFjwkmdE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vsor2mjJayvm; Fri,  2 Jul 2021 14:16:33 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 49715412FC;
        Fri,  2 Jul 2021 14:16:29 +0300 (MSK)
Received: from localhost.yadro.com (10.199.0.133) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 2 Jul
 2021 14:16:29 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH 0/2] Add NCSI Intel OEM command to keep PHY link up on
Date:   Fri, 2 Jul 2021 14:25:17 +0300
Message-ID: <20210702112519.76385-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.133]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NCSI Intel OEM command to keep PHY link up and prevents any channel
resets during the host load. Also includes dummy response handler for Intel
manufacturer id.

Ivan Mikhaylov (2):
  net/ncsi: add NCSI Intel OEM command to keep PHY up
  net/ncsi: add dummy response handler for Intel boards

 net/ncsi/Kconfig       |  6 ++++++
 net/ncsi/internal.h    |  5 +++++
 net/ncsi/ncsi-manage.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 net/ncsi/ncsi-rsp.c    |  9 +++++++-
 4 files changed, 67 insertions(+), 1 deletion(-)

-- 
2.31.1

