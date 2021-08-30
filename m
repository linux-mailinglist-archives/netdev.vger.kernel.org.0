Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BC03FBA9C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhH3RIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:08:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56420 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231890AbhH3RIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 13:08:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BBDB64CF47;
        Mon, 30 Aug 2021 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1630343264; x=
        1632157665; bh=AVBw2F3L9Uktk6U3pXIDtnZY8vB0ngZRv+dPO9a+R+g=; b=c
        9GJF8bfsC81qv6/fgWYBqaN24mz0QtKAHfbCigT08zYn3bPoRC6oGK/QiUF21hX1
        K0sj1/agzxdRUY6NMkhSmLYqKBuM8eTMvibcozQInaC6OmimgnVKo8IlJUepNcHg
        qAbPhIRxvbDOjiGCxMa+cK97vivQlvzgSqRlt87f8o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n6-ecEbC7yS2; Mon, 30 Aug 2021 20:07:44 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0F3E44CF49;
        Mon, 30 Aug 2021 20:07:40 +0300 (MSK)
Received: from fedora.mshome.net (10.199.0.170) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 30
 Aug 2021 20:07:39 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH 0/1] net/ncsi: add get mac address command for Intel
Date:   Mon, 30 Aug 2021 20:18:05 +0300
Message-ID: <20210830171806.119857-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.170]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NCSI Intel command to get MAC address from host and set it on interface.

Ivan Mikhaylov (1):
  net/ncsi: add get MAC address command to get Intel i210 MAC address

 net/ncsi/internal.h    |  3 +++
 net/ncsi/ncsi-manage.c | 25 ++++++++++++++++++++++++-
 net/ncsi/ncsi-pkt.h    |  6 ++++++
 net/ncsi/ncsi-rsp.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 1 deletion(-)

-- 
2.31.1

